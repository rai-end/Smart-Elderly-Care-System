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

      <button class="enter-btn animate__animated animate__pulse animate__infinite" @click="showLogin = true">
        前往体验
      </button>
    </div>

    <div class="login-container" v-if="showLogin">
      <div class="login-bg-decoration">
        <div class="bg-circle circle-1 animate__animated animate__bounceIn"></div>
        <div class="bg-circle circle-2 animate__animated animate__bounceIn animate__delay-1s"></div>
        <div class="bg-circle circle-3 animate__animated animate__bounceIn animate__delay-2s"></div>
      </div>

      <div class="login-card animate__animated animate__fadeInUp animate__fast">
        <div class="card-decoration"></div>
        <div class="login-title">智能老人监测系统</div>
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
              class="login-btn animate__animated animate__heartBeat animate__delay-1s"
              @click="handleLogin"
              :disabled="isLoading || !loginForm.username || !loginForm.password"
          >
            <span v-if="!isLoading">登录</span>
            <span v-if="isLoading">
              <span class="loading-spinner"></span>
              登录中...
            </span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import 'animate.css'
import { ref, onMounted, onUnmounted, nextTick, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/userStore.js'

const showLogin = ref(false)
document.documentElement.style.overflow = 'hidden'
document.body.style.overflow = 'hidden'

const router = useRouter()
const userStore = useUserStore()

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
    console.log('[登录页] ========== 开始登录 ==========')
    console.log('[登录页] 登录参数：', loginForm.value)

    userStore.logout()
    await nextTick()

    const success = await userStore.loginAction(loginForm.value)

    if (success) {
      console.log('[登录页] 登录成功，准备跳转')

      document.documentElement.style.overflow = 'auto'
      document.body.style.overflow = 'auto'

      if (userStore.isAdmin || loginForm.value.username === 'admin') {
        console.log('[登录页] 管理员登录，跳转到/admin')
        router.push('/admin')
      } else {
        const deviceId = userStore.userInfo?.deviceId || loginForm.value.username
        console.log('[登录页] 普通用户登录，跳转到/user/' + deviceId)
        console.log('[登录页] ========== 登录完成 ==========')

        await nextTick()
        await new Promise(resolve => setTimeout(resolve, 100))

        router.push(`/user/${deviceId}`)
      }
    } else {
      throw new Error('设备ID或密码错误')
    }
  } catch (error) {
    console.error('[登录页] 登录失败：', error)
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
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.root-container {
  width: 100vw !important;
  height: 100vh !important;
  overflow: hidden !important;
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  margin: 0 !important;
  padding: 0 !important;
  background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 25%, #fed7aa 50%, #fffbeb 100%);
  background-size: 400% 400%;
  animation: gradientBG 20s ease infinite;
  transition: background 0.8s ease, opacity 0.8s ease;
}

@keyframes gradientBG {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.root-container.login-bg {
  background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 50%, #fed7aa 100%) !important;
  background-size: 100% 100% !important;
  animation: none !important;
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
  z-index: 2;
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
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3), 0 0 100px rgba(234, 88, 12, 0.15);
  transition: transform 0.8s cubic-bezier(0.25, 0.8, 0.25, 1), opacity 0.8s ease;
  transform-origin: center center;
  border: 2px solid rgba(255, 255, 255, 0.3);
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
  width: 70px;
  height: 70px;
  border-radius: 50%;
  border: 2px solid rgba(234, 88, 12, 0.2);
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.6), rgba(255, 255, 255, 0.4));
  color: #ea580c;
  font-size: 24px;
  cursor: pointer;
  backdrop-filter: blur(15px);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15), inset 0 1px 0 rgba(255, 255, 255, 0.7);
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.carousel-control.prev {
  left: 3vw !important;
}

.carousel-control.next {
  right: 3vw !important;
}

.carousel-control:hover {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.5));
  box-shadow: 0 15px 50px rgba(234, 88, 12, 0.25), inset 0 1px 0 rgba(255, 255, 255, 0.8);
  transform: translateY(-50%) scale(1.15) !important;
}

.enter-btn {
  position: fixed !important;
  left: 50% !important;
  top: 75% !important;
  transform: translate(-50%, -50%) !important;
  z-index: 10;
  font-size: 36px;
  padding: 35px 100px;
  border-radius: 80px;
  border: 2px solid rgba(234, 88, 12, 0.2);
  background: linear-gradient(90deg, #ea580c 0%, #f97316 50%, #fb923c 100%);
  background-size: 200% 200%;
  color: white;
  font-weight: 800;
  cursor: pointer;
  box-shadow: 0 15px 50px rgba(234, 88, 12, 0.4);
  transition: all 0.4s cubic-bezier(0.39, 0.575, 0.565, 1);
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  letter-spacing: 4px;
  text-shadow: 0 2px 8px rgba(0,0,0,0.1);
  animation: gradientShift 3s ease infinite;
}

@keyframes gradientShift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.enter-btn:hover {
  transform: translate(-50%, -50%) scale(1.12) !important;
  box-shadow: 0 20px 60px rgba(234, 88, 12, 0.5), 0 0 0 15px rgba(234, 88, 12, 0.1);
  background-position: 100% 50%;
}

.enter-btn:active {
  transform: translate(-50%, -50%) scale(1.05) !important;
  box-shadow: 0 10px 35px rgba(234, 88, 12, 0.4);
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
  z-index: 2;
}

.login-bg-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 1;
}

.bg-circle {
  position: absolute;
  border-radius: 50%;
  background: linear-gradient(135deg, #ea580c, #f97316);
  opacity: 0.1;
  filter: blur(50px);
}

.circle-1 {
  width: 500px;
  height: 500px;
  top: -150px;
  left: -150px;
}

.circle-2 {
  width: 400px;
  height: 400px;
  bottom: -100px;
  right: -100px;
  background: linear-gradient(135deg, #f97316, #ea580c);
}

.circle-3 {
  width: 350px;
  height: 350px;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background: linear-gradient(135deg, #fb923c, #fdba74);
}

.login-card {
  width: 450px;
  padding: 40px 45px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.98), rgba(255, 255, 255, 0.9));
  border-radius: 30px;
  box-shadow:
      0 30px 80px rgba(234, 88, 12, 0.15),
      0 15px 40px rgba(234, 88, 12, 0.1),
      inset 0 2px 0 rgba(255, 255, 255, 0.95),
      0 0 0 1px rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(30px);
  border: 1px solid rgba(255, 255, 255, 0.9);
  box-sizing: border-box;
  overflow: hidden;
  position: relative;
  z-index: 2;
}

.card-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 6px;
  background: linear-gradient(90deg, #ea580c, #f97316, #fb923c, #f97316, #ea580c);
  background-size: 200% 100%;
  animation: cardDecor 3s linear infinite;
}

@keyframes cardDecor {
  0% { background-position: 0% 50%; }
  100% { background-position: 200% 50%; }
}

.login-title {
  text-align: center;
  margin-bottom: 30px;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  font-size: 30px;
  font-weight: 800;
  letter-spacing: 2px;
  background: linear-gradient(90deg, #ea580c, #f97316, #fb923c);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-size: 200% 100%;
  animation: titleGradient 4s ease infinite;
}

@keyframes titleGradient {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

.form-wrapper {
  padding: 0 10px;
}

.form-item {
  margin-bottom: 22px;
}

.form-item label {
  display: block;
  margin-bottom: 10px;
  color: #c2410c;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  font-weight: 600;
  font-size: 16px;
}

.form-input {
  width: 100%;
  padding: 20px 35px;
  border: 2px solid rgba(234, 88, 12, 0.15);
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.98);
  color: #444;
  font-size: 17px;
  height: 60px;
  box-sizing: border-box;
  transition: all 0.3s ease;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  outline: none;
}

.form-input:focus {
  border-color: #ea580c;
  box-shadow: 0 0 0 4px rgba(234, 88, 12, 0.1), 0 8px 25px rgba(234, 88, 12, 0.08);
  background: #fff;
}

.login-btn {
  width: 100%;
  padding: 18px;
  border: none;
  border-radius: 16px;
  background: linear-gradient(90deg, #ea580c 0%, #f97316 50%, #fb923c 100%);
  background-size: 200% 100%;
  color: white;
  font-size: 18px;
  font-weight: 700;
  height: 62px;
  cursor: pointer;
  box-shadow: 0 10px 30px rgba(234, 88, 12, 0.3);
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  letter-spacing: 2px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.login-btn:hover:not(:disabled) {
  transform: translateY(-3px);
  background-position: 100% 50%;
  box-shadow: 0 15px 40px rgba(234, 88, 12, 0.4);
}

.login-btn:active:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 8px 25px rgba(234, 88, 12, 0.3);
}

.login-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  box-shadow: 0 5px 15px rgba(234, 88, 12, 0.2);
}

.loading-spinner {
  display: inline-block;
  width: 20px;
  height: 20px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>