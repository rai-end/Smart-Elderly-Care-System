import { defineStore } from 'pinia'
import { adminLogin, login as userLogin } from '../api/index.js'

export const useUserStore = defineStore('user', {
  state: () => ({
    token: localStorage.getItem('token') || '',
    userInfo: JSON.parse(localStorage.getItem('userInfo') || 'null'),
    isLogin: !!localStorage.getItem('deviceId'),
    isAdmin: localStorage.getItem('userRole') === 'admin'
  }),
  actions: {
    async loginAction(loginForm) {
      try {
        console.log('[Store] 开始登录，账号:', loginForm.username)

        this.logout()

        if (loginForm.username === 'admin') {
          console.log('[Store] 管理员登录，调用 /admin/login')

          const res = await adminLogin(loginForm)
          console.log('[Store] 管理员接口返回:', res)

          if (res && res.code === 200) {
            this.token = res.token || 'admin-token'
            this.userInfo = {
              userName: res.adminName || '管理员',
              deviceId: 'admin'
            }
            this.isLogin = true
            this.isAdmin = true

            localStorage.setItem('token', this.token)
            localStorage.setItem('userInfo', JSON.stringify(this.userInfo))
            localStorage.setItem('userRole', 'admin')

            console.log('[Store] 管理员登录成功')
            return true
          } else {
            throw new Error(res?.msg || '管理员账号或密码错误')
          }
        } else {
          console.log('[Store] 普通用户登录')

          const res = await fetch('http://localhost:8080/user/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              deviceId: loginForm.username,
              password: loginForm.password
            })
          }).then(r => r.json())

          console.log('[Store] 普通用户接口返回:', res)

          if (res.code === 200 && res.data) {
            this.token = res.data.token || 'user-token'
            this.userInfo = {
              ...res.data,
              deviceId: res.data.deviceId || loginForm.username
            }
            this.isLogin = true
            this.isAdmin = false

            localStorage.setItem('token', this.token)
            localStorage.setItem('userInfo', JSON.stringify(this.userInfo))
            localStorage.setItem('deviceId', this.userInfo.deviceId)
            localStorage.setItem('userRole', 'user')

            console.log('[Store] 普通用户登录成功')
            return true
          }

          return false
        }
      } catch (error) {
        console.error('[Store] 登录异常:', error)
        return false
      }
    },
    logout() {
      this.token = ''
      this.userInfo = null
      this.isLogin = false
      this.isAdmin = false

      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
      localStorage.removeItem('deviceId')
      localStorage.removeItem('userRole')
    }
  }
})