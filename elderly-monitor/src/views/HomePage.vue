<template>
  <div class="home-container" @mousemove="handleMouseMove">

    <div v-if="isAlerting" class="alert-banner animate__animated animate__shakeX">
      🚨 警报：检测到老人跌倒！请立即查看！
    </div>

    <div class="top-status-bar">
      <div class="logo-text">智能老人监测系统</div>
      <div class="user-info">
        欢迎您：{{ userInfo.userName }} | 设备ID：{{ userInfo.deviceId }}
      </div>
    </div>

    <div class="mouse-light" :style="mouseLightStyle"></div>
    <div class="bg-decoration-layer">
      <div class="floating-shape shape-1"></div>
      <div class="floating-shape shape-2"></div>
      <div class="floating-shape shape-3"></div>
    </div>

    <main class="home-main animate__animated animate__fadeInUp animate__delay-1s">
      <div class="grid-column left-col">
        <div class="component-card">
          <HeartRate :userId="validDeviceId" />
        </div>
        <div class="component-card">
          <BloodPressure :userId="validDeviceId" />
        </div>
        <div class="component-card">
          <BloodOxygen :userId="validDeviceId" />
        </div>
      </div>

      <div class="grid-column center-col">
        <div class="component-card logo-card">
          <Logo :userInfo="userInfo" :userId="validDeviceId" />
        </div>
        <div class="component-card activity-card">
          <ActivityAnalysis :userId="validDeviceId" />
        </div>
      </div>

      <div class="grid-column right-col">
        <div class="component-card">
          <SleepQuality :userId="validDeviceId" />
        </div>
        <div class="component-card">
          <FallDetection :userId="validDeviceId" />
        </div>
        <div class="component-card">
          <TemperatureDetection :userId="validDeviceId" />
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import 'animate.css'
import { watch, ref, onMounted, onUnmounted, reactive } from 'vue'
import { useRoute } from 'vue-router'
import { useUserStore } from '../stores/userStore.js'
import { getLogoUserData, getFallDetectionData } from '../api/index.js'
import HeartRate from '../components/HeartRate.vue'
import BloodPressure from '../components/BloodPressure.vue'
import BloodOxygen from '../components/BloodOxygen.vue'
import Logo from '../components/Logo.vue'
import ActivityAnalysis from '../components/ActivityAnalysis.vue'
import SleepQuality from '../components/SleepQuality.vue'
import FallDetection from '../components/FallDetection.vue'
import TemperatureDetection from '../components/TemperatureDetection.vue'

const route = useRoute()
const userStore = useUserStore()

const validDeviceId = ref('DEV001')
const userInfo = ref({
  userName: '加载中...',
  deviceId: 'DEV001'
})
let refreshTimer = null

const isAlerting = ref(false)
let audio = null

const mouseLightStyle = reactive({
  left: '0px',
  top: '0px'
})
const handleMouseMove = (e) => {
  mouseLightStyle.left = e.clientX - 200 + 'px'
  mouseLightStyle.top = e.clientY - 200 + 'px'
}

const initAlertAudio = () => {
  audio = new Audio('https://assets.mixkit.co/active_storage/sfx/2868/2868-preview.mp3')
  audio.loop = true
}

const checkFallStatus = async () => {
  try {
    const data = await getFallDetectionData(validDeviceId.value)
    if (data.fallScore > 70 && !isAlerting.value) {
      triggerAlert()
    } else if (data.fallScore <= 70 && isAlerting.value) {
      stopAlert()
    }
  } catch (e) {
    console.error('检查跌倒状态失败:', e)
  }
}

const triggerAlert = () => {
  isAlerting.value = true
  if (audio) {
    audio.play().catch(e => console.error('播放警报声音失败:', e))
  }
  alert('⚠️ 检测到老人跌倒！请立即查看！')
}

const stopAlert = () => {
  isAlerting.value = false
  if (audio) {
    audio.pause()
    audio.currentTime = 0
  }
}

const init = () => {
  const userId = route.params.userId || 'DEV001'
  let newDeviceId = userId
  if (!newDeviceId.startsWith('DEV')) {
    newDeviceId = 'DEV001'
  }
  validDeviceId.value = newDeviceId.toUpperCase()
  fetchUserInfo(validDeviceId.value)
}

const fetchUserInfo = async (deviceId) => {
  try {
    const res = await getLogoUserData(deviceId)
    if (res && res.userName) {
      userInfo.value = { ...res, deviceId: deviceId }
    } else {
      userInfo.value = { userName: '未知用户', deviceId: deviceId }
    }
  } catch (e) {
    console.error('【首页】请求失败:', e)
    userInfo.value = { userName: '未知用户', deviceId: deviceId }
  }
}

const startAutoRefresh = () => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
  }
  refreshTimer = setInterval(() => {
    fetchUserInfo(validDeviceId.value)
    checkFallStatus()
  }, 5000)
}

watch(() => route.params.userId, () => {
  init()
}, { immediate: true })

onMounted(() => {
  initAlertAudio()
  init()
  startAutoRefresh()
})

onUnmounted(() => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
  }
  stopAlert()
})
</script>

<style scoped>
.alert-banner {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  background: #ef4444;
  color: white;
  text-align: center;
  padding: 12px;
  font-weight: bold;
  font-size: 18px;
  z-index: 9999;
}

.top-status-bar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 60px;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(15px);
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 25px;
  z-index: 999;
  color: #444;
  font-size: 15px;
}
.logo-text {
  font-weight: bold;
  font-size: 17px;
  color: #ea580c;
}
.user-info {
  color: #666;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

/* 暖色调背景 */
.home-container {
  width: 100vw;
  height: 100vh;
  background:
      radial-gradient(ellipse at 20% 20%, rgba(234, 88, 12, 0.08) 0%, transparent 50%),
      radial-gradient(ellipse at 80% 80%, rgba(249, 115, 22, 0.06) 0%, transparent 50%),
      linear-gradient(135deg, #fffbeb 0%, #fef3c7 30%, #fed7aa 100%);
  background-size: 100% 100%, 100% 100%, 400% 400%;
  animation: gradientBG 20s ease infinite;
  position: fixed;
  top: 0;
  left: 0;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  overflow: hidden;
}

@keyframes gradientBG {
  0% { background-position: 0% 0%, 100% 100%, 0% 50%; }
  33% { background-position: 50% 50%, 50% 50%, 100% 50%; }
  66% { background-position: 100% 100%, 0% 0%, 50% 50%; }
  100% { background-position: 0% 0%, 100% 100%, 0% 50%; }
}

.mouse-light {
  position: fixed;
  width: 400px;
  height: 400px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(234, 88, 12, 0.1) 0%, rgba(249, 115, 22, 0.05) 30%, transparent 70%);
  pointer-events: none;
  z-index: 1;
  transition: left 0.1s ease-out, top 0.1s ease-out;
  filter: blur(20px);
}

.bg-decoration-layer {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1;
  overflow: hidden;
}

.floating-shape {
  position: absolute;
  border-radius: 50%;
  opacity: 0.1;
  filter: blur(40px);
  animation: float 18s ease-in-out infinite;
}

.shape-1 {
  width: 350px;
  height: 350px;
  top: 15%;
  left: 10%;
  background: linear-gradient(135deg, #fed7aa, #fdba74);
  animation-delay: 0s;
}

.shape-2 {
  width: 280px;
  height: 280px;
  top: 65%;
  right: 12%;
  background: linear-gradient(135deg, #fecaca, #fee2e2);
  animation-delay: -6s;
  animation-direction: reverse;
}

.shape-3 {
  width: 220px;
  height: 220px;
  bottom: 25%;
  left: 25%;
  background: linear-gradient(135deg, #fde68a, #fef3c7);
  animation-delay: -12s;
}

@keyframes float {
  0%, 100% { transform: translate(0, 0) rotate(0deg) scale(1); }
  25% { transform: translate(25px, -25px) rotate(90deg) scale(1.08); }
  50% { transform: translate(0, -40px) rotate(180deg) scale(1); }
  75% { transform: translate(-25px, -25px) rotate(270deg) scale(0.92); }
}

.home-main {
  width: 100%;
  height: 100vh;
  padding-top: 70px;
  display: flex;
  gap: 10px;
  padding: 10px;
  padding-top: 70px;
  position: relative;
  z-index: 5;
}

.grid-column {
  flex: 1;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

/* 暖色调卡片 */
.component-card {
  flex: 1;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(25px);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.7);
  box-shadow:
      0 8px 30px rgba(0, 0, 0, 0.04),
      0 4px 12px rgba(0, 0, 0, 0.02),
      inset 0 1px 0 rgba(255, 255, 255, 0.9);
  overflow: hidden;
  position: relative;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  display: flex;
  flex-direction: column;
}

.component-card:hover {
  transform: translateY(-3px) scale(1.01);
  box-shadow:
      0 15px 40px rgba(234, 88, 12, 0.12),
      0 6px 20px rgba(234, 88, 12, 0.06);
  border-color: rgba(234, 88, 12, 0.2);
}

.logo-card {
  flex: 0.7;
  padding: 0;
}

.activity-card {
  flex: 1.3;
}

.card-header {
  padding: 8px 14px;
  display: flex;
  align-items: center;
  gap: 10px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  background: rgba(255, 255, 255, 0.5);
  flex-shrink: 0;
}

.card-icon {
  font-size: 18px;
}

.card-title {
  font-size: 15px;
  font-weight: 700;
  color: #444;
  letter-spacing: 0.5px;
}

.component-card > *:not(.card-header) {
  flex: 1;
  width: 100%;
  height: 100%;
  overflow: hidden;
  min-height: 0;
}

.logo-card > * {
  width: 100%;
  height: 100%;
  overflow: hidden;
}
</style>