<template>
  <div class="root-container" :class="{ 'login-bg': showLogin }">
    <div class="carousel-container" v-if="!showLogin">
      <div class="carousel-wrapper" ref="carouselWrapper">
        <div
            class="carousel-item"
            v-for="(item, index) in carouselList"
            :key="index"
            :style="{
            transform: `rotateY(${getItemAngle(index)}deg) translateZ(${radius}px)`,
            opacity: Math.abs(getItemAngle(index)) < 90 ? 1 : 0.2
          }"
        >
          <img :src="item.img" alt="轮播图" class="carousel-img" />
        </div>
      </div>
      <button class="carousel-control prev" @click="prev()">
        <i>←</i>
      </button>
      <button class="carousel-control next" @click="next()">
        <i>→</i>
      </button>

      <button class="enter-btn" @click="showLogin = true">
        前往体验
      </button>
    </div>

    <div class="login-container" v-if="showLogin">
      <div class="login-bg-decoration">
        <div class="bg-circle circle-1"></div>
        <div class="bg-circle circle-2"></div>
        <div class="bg-circle circle-3"></div>
      </div>

      <div class="login-card">
        <div class="card-decoration"></div>
        <div class="login-title">智能老人监测系统 </div>
        <div class="form-wrapper">
          <div class="form-item">
            <label for="username">设备ID/管理员账号</label>
            <div class="input-container">
              <input
                  id="username"
                  v-model="loginForm.username"
                  placeholder="请输入设备ID（如DEV001）或管理员账号（admin）"
                  class="form-input"
                  :disabled="isLoading"
              />
            </div>
          </div>

          <div class="form-item">
            <label for="password">密码</label>
            <div class="input-container">
              <input
                  id="password"
                  v-model="loginForm.password"
                  type="password"
                  placeholder="请输入密码（如123456）"
                  class="form-input"
                  :disabled="isLoading"
              />
            </div>
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
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/userStore.js'

import { login, adminLogin } from '../api/index.js'

const showLogin = ref(false)
document.documentElement.style.overflow = 'hidden'
document.body.style.overflow = 'hidden'

const router = useRouter()

const loginForm = ref({
  username: '',
  password: ''
})
const isLoading = ref(false)

const carouselWrapper = ref(null)
const carouselList = ref([
  { img: '/src/assets/1.png' },
  { img: '/src/assets/2.png' },
  { img: '/src/assets/3.png' }
])
const radius = ref(450)
const currentIndex = ref(0)
const autoPlayTimer = ref(null)

const getItemAngle = computed(() => {
  const total = carouselList.value.length
  const angleStep = 360 / total
  return (index) => (index - currentIndex.value) * angleStep
})

const prev = () => {
  currentIndex.value = (currentIndex.value - 1 + carouselList.value.length) % carouselList.value.length
  updateCarousel()
}
const next = () => {
  currentIndex.value = (currentIndex.value + 1) % carouselList.value.length
  updateCarousel()
}
const updateCarousel = () => {
  if (carouselWrapper.value) carouselWrapper.value.style.transform = 'rotateY(0deg)'
}

const startAutoPlay = () => {
  autoPlayTimer.value = setInterval(next, 5000)
}

const handleLogin = async () => {
  try {
    isLoading.value = true
    const userStore = useUserStore()
    let res = null

    if (loginForm.value.username === 'admin') {
      res = await adminLogin({
        account: loginForm.value.username,
        password: loginForm.value.password
      })

      if (res.code !== 200) {
        throw new Error(res.msg || '管理员账号或密码错误')
      }

      userStore.isLogin = true
      userStore.userInfo = {
        role: 'admin',
        account: loginForm.value.username
      }
      localStorage.setItem('adminToken', res.token || 'admin_token')
      localStorage.setItem('userRole', 'admin')
      router.push('/admin')
    } else {
      res = await login({
        deviceId: loginForm.value.username,
        password: loginForm.value.password
      })

      if (res.code !== 200) {
        throw new Error(res.msg || '设备ID或密码错误')
      }

      userStore.isLogin = true
      userStore.userInfo = {
        role: 'user',
        deviceId: loginForm.value.username
      }
      localStorage.setItem('deviceId', loginForm.value.username)
      localStorage.setItem('userRole', 'user')
      router.push('/user')
    }

    localStorage.setItem('token', res.token || 'temp_token')
    localStorage.setItem('isLogin', 'true')
    document.documentElement.style.overflow = 'auto'
    document.body.style.overflow = 'auto'

  } catch (error) {
    alert(error.message || '登录失败，请检查账号/密码或后端是否启动')
  } finally {
    isLoading.value = false
  }
}

onMounted(async () => {
  await nextTick()
  updateCarousel()
  startAutoPlay()
})
onUnmounted(() => {
  clearInterval(autoPlayTimer.value)
  document.documentElement.style.overflow = 'auto'
  document.body.style.overflow = 'auto'
})
</script>


<style scoped>
.root-container {
  width: 100vw !important;
  height: 100vh !important;
  overflow: hidden !important;
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  margin: 0 !important;
  padding: 0 !important;
  background: linear-gradient(135deg, #FFF9E8, #FFE8CC);
  transition: background 0.8s ease, opacity 0.8s ease;
}

.root-container.login-bg {
  background: #ffffff !important;
}

.carousel-container {
  width: 100%;
  height: 100%;
  perspective: 2500px;
  perspective-origin: center center;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.carousel-wrapper {
  position: absolute;
  top: 50% !important;
  left: 50% !important;
  transform: translate(-50%, -50%) !important;
  transform-style: preserve-3d;
  width: 900px !important;
  height: 600px !important;
  margin: 0 !important;
}

.carousel-item {
  position: absolute;
  top: 0 !important;
  left: 0 !important;
  width: 100% !important;
  height: 100% !important;
  backface-visibility: hidden;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 0 40px rgba(255, 160, 0, 0.3);
  transition: transform 0.8s cubic-bezier(0.25, 0.8, 0.25, 1),
  opacity 0.8s ease;
  transform-origin: center center;
}

.carousel-img {
  width: 100% !important;
  height: 100% !important;
  object-fit: cover !important;
  object-position: center !important;
  display: block !important;
}

.carousel-control {
  position: fixed !important;
  top: 50% !important;
  transform: translateY(-50%) !important;
  z-index: 10;
  width: 60px;
  height: 60px;
  border-radius: 50%;
  border: none;
  background: rgba(255, 255, 255, 0.85);
  color: #D35400;
  font-size: 20px;
  cursor: pointer;
  backdrop-filter: blur(8px);
  transition: all 0.3s ease;
}

.carousel-control.prev {
  left: 2vw !important;
}

.carousel-control.next {
  right: 2vw !important;
}

.carousel-control:hover {
  background: rgba(255, 255, 255, 0.95);
  box-shadow: 0 0 15px rgba(211, 84, 0, 0.5);
  transform: translateY(-50%) scale(1.1) !important;
}

.enter-btn {
  position: fixed !important;
  left: 50% !important;
  top: 75% !important;
  transform: translate(-50%, -50%) !important;
  z-index: 10;
  font-size: 32px;
  padding: 32px 90px;
  border-radius: 70px;
  border: none;
  background: linear-gradient(90deg, #D35400, #E67E22);
  color: white;
  font-weight: 700;
  cursor: pointer;
  box-shadow: 0 10px 40px rgba(211, 84, 0, 0.8);
  transition: all 0.4s cubic-bezier(0.39, 0.575, 0.565, 1);
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  letter-spacing: 3px;
  text-shadow: 0 1px 3px rgba(0,0,0,0.15);
  -webkit-font-smoothing: antialiased;
}

.enter-btn:hover {
  transform: translate(-50%, -50%) scale(1.1) !important;
  box-shadow: 0 15px 50px rgba(211, 84, 0, 1);
  background: linear-gradient(90deg, #c04a00, #d97418);
}

.enter-btn:active {
  transform: translate(-50%, -50%) scale(1.03) !important;
  box-shadow: 0 5px 25px rgba(211, 84, 0, 0.7);
}

.login-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #fdf2e9 0%, #fef7e5 50%, #fff8ed 100%) !important;
  background-image:
      radial-gradient(rgba(211, 84, 0, 0.05) 1px, transparent 1px),
      radial-gradient(rgba(211, 84, 0, 0.03) 1px, transparent 1px) !important;
  background-size: 50px 50px, 25px 25px !important;
  background-position: 0 0, 12px 12px !important;
  box-sizing: border-box;
  position: relative;
  overflow: hidden;
}

.login-bg-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1;
}

.bg-circle {
  position: absolute;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(211, 84, 0, 0.08), rgba(230, 126, 34, 0.05));
  backdrop-filter: blur(10px);
  animation: float 8s ease-in-out infinite;
}

.circle-1 {
  width: 400px;
  height: 400px;
  top: -150px;
  right: -150px;
  animation-delay: 0s;
}

.circle-2 {
  width: 300px;
  height: 300px;
  bottom: -100px;
  left: -100px;
  animation-delay: 2s;
}

.circle-3 {
  width: 200px;
  height: 200px;
  top: 40%;
  left: -80px;
  animation-delay: 4s;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0) rotate(0deg);
  }
  50% {
    transform: translateY(-20px) rotate(5deg);
  }
}

.login-card {
  width: 420px;
  padding: 25px 40px;
  background: rgba(255, 255, 255, 0.98);
  border-radius: 24px;
  box-shadow:
      0 10px 30px rgba(211, 84, 0, 0.08),
      0 4px 15px rgba(211, 84, 0, 0.05),
      inset 0 1px 0 rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.8);
  box-sizing: border-box;
  overflow: hidden;
  position: relative;
  z-index: 2;
  transform: perspective(1000px) translateY(0) rotateX(2deg);
  transition: all 0.5s ease;
}

.login-card:hover {
  transform: perspective(1000px) translateY(-5px) rotateX(0deg);
  box-shadow:
      0 15px 40px rgba(211, 84, 0, 0.12),
      0 6px 20px rgba(211, 84, 0, 0.08),
      inset 0 1px 0 rgba(255, 255, 255, 0.9);
}

.card-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 8px;
  background: linear-gradient(90deg, #D35400, #E67E22, #F39C12);
  border-radius: 24px 24px 0 0;
}

.login-title {
  text-align: center;
  margin-bottom: 20px;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  font-size: 28px;
  font-weight: 700;
  letter-spacing: 1px;
  background: linear-gradient(90deg, #D35400, #E67E22);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  position: relative;
}

.login-title::after {
  content: '';
  display: block;
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, #D35400, #E67E22);
  border-radius: 3px;
  margin: 10px auto 0;
  opacity: 0.7;
}

.form-wrapper {
  padding: 0 15px;
  position: relative;
}

.form-item {
  margin-bottom: 18px;
  box-sizing: border-box;
  position: relative;
}

.form-item label {
  display: block;
  margin-bottom: 8px;
  color: #D35400;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  font-weight: 500;
  font-size: 16px;
  position: relative;
  z-index: 2;
}

.input-container {
  position: relative;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(211, 84, 0, 0.06);
}

.form-input {
  width: 90%;
  padding: 18px 30px;
  border: 1px solid rgba(211, 84, 0, 0.12);
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.95);
  color: #333333;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  font-size: 17px;
  transition: all 0.3s ease;
  box-sizing: border-box;
  outline: none;
  height: 55px;
  position: relative;
  z-index: 2;
}

.form-input:focus {
  border-color: #E67E22;
  box-shadow:
      0 0 0 3px rgba(230, 126, 34, 0.1),
      0 4px 12px rgba(211, 84, 0, 0.1);
  background: #ffffff;
}

.form-input::placeholder {
  color: #886644;
  opacity: 0.7;
  font-size: 16px;
}

.form-input:disabled {
  background: rgba(255, 250, 240, 0.5);
  cursor: not-allowed;
}

.login-btn {
  width: 100%;
  padding: 16px;
  border: none;
  border-radius: 12px;
  background: linear-gradient(90deg, #D35400 0%, #E67E22 100%);
  color: white;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  font-size: 17px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow:
      0 6px 15px rgba(211, 84, 0, 0.2),
      inset 0 -2px 0 rgba(0, 0, 0, 0.1),
      inset 0 2px 0 rgba(255, 255, 255, 0.2);
  box-sizing: border-box;
  user-select: none;
  height: 58px;
  margin-top: 5px !important;
  position: relative;
  z-index: 2;
}

.login-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow:
      0 8px 20px rgba(211, 84, 0, 0.25),
      inset 0 -2px 0 rgba(0, 0, 0, 0.1),
      inset 0 2px 0 rgba(255, 255, 255, 0.2);
  background: linear-gradient(90deg, #c04a00 0%, #d97418 100%);
}

.login-btn:active:not(:disabled) {
  transform: translateY(0);
  box-shadow:
      0 4px 10px rgba(211, 84, 0, 0.2),
      inset 0 -1px 0 rgba(0, 0, 0, 0.1),
      inset 0 1px 0 rgba(255, 255, 255, 0.2);
}

.login-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
  box-shadow:
      0 2px 8px rgba(211, 84, 0, 0.1),
      inset 0 -1px 0 rgba(0, 0, 0, 0.05);
}

@media (max-width: 480px) {
  .carousel-wrapper {
    width: 90vw !important;
    height: 50vh !important;
  }
  .carousel-control {
    width: 45px;
    height: 45px;
    font-size: 16px;
  }
  .enter-btn {
    padding: 24px 60px;
    font-size: 26px;
    letter-spacing: 2px;
  }

  .login-card {
    width: 90%;
    padding: 20px 25px;
    transform: perspective(1000px) translateY(0) rotateX(1deg);
  }

  .login-card:hover {
    transform: perspective(1000px) translateY(-3px) rotateX(0deg);
  }

  .login-title {
    font-size: 24px;
    margin-bottom: 15px;
  }

  .form-wrapper {
    padding: 0 15px;
  }

  .form-input {
    padding: 16px 18px;
    font-size: 16px;
    height: 50px;
  }

  .login-btn {
    padding: 14px;
    font-size: 16px;
    height: 52px;
  }

  .form-item {
    margin-bottom: 15px;
  }

  .bg-circle {
    width: 200px !important;
    height: 200px !important;
  }

  .circle-1 {
    top: -80px;
    right: -80px;
  }

  .circle-2 {
    bottom: -60px;
    left: -60px;
  }

  .circle-3 {
    display: none;
  }
}

* {
  margin: 0 !important;
  padding: 0 !important;
  box-sizing: border-box !important;
}

html, body {
  width: 100vw !important;
  height: 100vh !important;
  overflow: hidden !important;
}
</style>