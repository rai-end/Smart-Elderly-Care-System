<template>
  <div class="login-container">
    <div class="login-card">

      <div class="login-title">智能老人监测系统 - 登录</div>

      <div class="form-item">
        <label for="username">用户名</label>
        <input
            id="username"
            v-model="loginForm.username"
            placeholder="请输入用户名"
            class="form-input"
            :disabled="isLoading"
        />
      </div>

      <div class="form-item">
        <label for="password">密码</label>
        <input
            id="password"
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            class="form-input"
            :disabled="isLoading"
        />
      </div>

      <button
          class="login-btn"
          @click="handleLogin"
          :disabled="isLoading || !loginForm.username || !loginForm.password"
      >
        <span v-if="!isLoading">登录</span>
        <span v-if="isLoading">登录中...</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useUserStore } from '../stores/userStore.js'
import { useRouter } from 'vue-router'

import request from '../api/request.js'

const router = useRouter()
const userStore = useUserStore()


const loginForm = ref({
  username: '',
  password: ''
})


const isLoading = ref(false)


const handleLogin = async () => {
  try {

    isLoading.value = true


    const res = await request({
      url: '/user/login', // 后端登录接口地址
      method: 'POST',
      data: {
        deviceId: loginForm.value.username, // 对应后端的device_id字段
        password: loginForm.value.password
      }
    })


    userStore.token = res.token
    userStore.userInfo = res.userInfo
    userStore.isLogin = true
    userStore.isAdmin = res.userInfo.role === 'admin'


    if (userStore.isAdmin) {
      router.push('/admin')
    } else {
      router.push('/user')
    }

  } catch (error) {

    alert(error.msg || '登录失败，请检查账号密码或网络状态')
  } finally {

    isLoading.value = false
  }
}
</script>

<style scoped>
.login-container {
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;

  background: linear-gradient(135deg, #F8F5F0, #F5E8D5) !important;
  background-image:
      radial-gradient(1px 1px at 25px 5px, #D3540015, transparent),
      radial-gradient(1px 1px at 50px 25px, #D3540010, transparent) !important;
  background-repeat: repeat !important;
  background-size: 200px 200px !important;
  box-sizing: border-box;
}

.login-card {
  width: 400px;
  padding: 40px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 16px;

  box-shadow: 0 8px 32px rgba(211, 84, 0, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(211, 84, 0, 0.1);

  box-sizing: border-box;

  overflow: hidden;
}

.login-title {
  text-align: center;
  margin-bottom: 30px;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  font-size: 28px;
  font-weight: 700;
  letter-spacing: 1px;

  background: linear-gradient(90deg, #D35400, #E67E22);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.form-item {
  margin-bottom: 20px;
  box-sizing: border-box;
}
.form-item label {
  display: block;
  margin-bottom: 8px;
  color: #D35400;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  font-weight: 500;
  font-size: 14px;
}

.form-input {
  width: 100%;
  padding: 12px 15px;
  border: 1px solid #E67E2230;
  border-radius: 8px;
  background: rgba(255, 250, 240, 0.9);
  color: #333333;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  font-size: 16px;
  transition: all 0.3s ease;
  box-sizing: border-box;

  outline: none;
}
.form-input:focus {
  border-color: #E67E22;
  box-shadow: 0 0 8px rgba(211, 84, 0, 0.2);
}
.form-input::placeholder {
  color: #886644;
  opacity: 0.7;
}
.form-input:disabled {
  background: rgba(255, 250, 240, 0.5);
  cursor: not-allowed;
}

.login-btn {
  width: 100%;
  padding: 12px;
  border: none;
  border-radius: 8px;
  background: linear-gradient(90deg, #D35400, #E67E22);
  color: white;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(211, 84, 0, 0.2);
  box-sizing: border-box;

  user-select: none;
}
.login-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(211, 84, 0, 0.3);
}
.login-btn:active:not(:disabled) {
  transform: translateY(0);
}
.login-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

@media (max-width: 480px) {
  .login-card {
    width: 90%;
    padding: 30px;
  }
  .login-title {
    font-size: 24px;
  }
  .form-input {
    padding: 10px 12px;
    font-size: 14px;
  }
}
</style>