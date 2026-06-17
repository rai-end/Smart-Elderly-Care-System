import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/userStore.js'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    component: () => import('../views/LoginPage.vue')
  },
  {
    path: '/user/:userId?',
    name: 'home',
    component: () => import('../views/HomePage.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/admin',
    component: () => import('../views/AdminPage.vue'),
    meta: { requiresAuth: true, role: 'admin' }
  },
  {
    path: '/ai-chat',
    name: 'AiChat',
    component: () => import('../views/AiChatPage.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const userStore = useUserStore()

  if (!to.meta.requiresAuth) {
    next()
    return
  }

  const isUserLogin = !!localStorage.getItem('deviceId')
  const isAdminLogin = localStorage.getItem('userRole') === 'admin'

  if (!isUserLogin && !isAdminLogin) {
    console.log('[路由守卫] 未登录，跳转到登录页')
    next('/login')
    return
  }

  const userRole = localStorage.getItem('userRole') || 'user'
  if (to.meta.role === 'admin' && userRole !== 'admin') {
    alert('无管理员权限！')
    next(from.path)
    return
  }

  console.log(`[路由守卫] 已登录（角色：${userRole}），放行`)
  next()
})

export default router