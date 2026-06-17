<template>
  <div class="admin-page">
    <div class="bg-layer"></div>

    <header class="page-header">
      <div class="header-left">
        <span class="header-icon">👨‍💼</span>
        <h1 class="header-title">管理员后台 - 老人健康监测系统</h1>
      </div>
      <button class="logout-btn" @click="goBackLogin">
        ← 返回登录页
      </button>
    </header>

    <main class="main-container">
      <aside class="user-list-panel">
        <div class="panel-title">
          <span>用户列表</span>
          <span class="user-count">{{ userList.length }} 人</span>
        </div>

        <div v-if="loading" class="loading-box">
          <div class="loading-spinner"></div>
          <span>加载用户列表中...</span>
        </div>

        <div v-else class="user-list-scroll">
          <div
              v-for="user in userList"
              :key="user.deviceId"
              class="user-item"
              :class="{
              'active': selectedDeviceId === user.deviceId,
              'alert': isUserFallAlert(user.deviceId)
            }"
              @click="selectUser(user)"
          >
            <div class="user-avatar" :class="{ 'alert-avatar': isUserFallAlert(user.deviceId) }">
              {{ user.userName ? user.userName.substring(0,1) : '?' }}
              <span v-if="isUserFallAlert(user.deviceId)" class="alert-badge">🚨</span>
            </div>

            <div class="user-info">
              <div class="user-name">
                {{ user.userName || '未知用户' }}
                <span v-if="isUserFallAlert(user.deviceId)" class="alert-tag">跌倒警报</span>
              </div>
              <div class="user-device">设备ID：{{ user.deviceId }}</div>
              <div v-if="isUserFallAlert(user.deviceId)" class="fall-score">
                风险值：{{ getUserFallScore(user.deviceId) }}
              </div>
            </div>

            <span class="arrow-icon" v-if="selectedDeviceId === user.deviceId">→</span>
          </div>
        </div>
      </aside>

      <section class="data-detail-panel">
        <div v-if="!selectedDeviceId" class="empty-state">
          <div class="empty-icon">👆</div>
          <div class="empty-text">请在左侧选择一个用户</div>
          <div class="empty-desc">查看该用户的实时健康监测数据</div>
        </div>

        <div v-else class="data-content">
          <div class="data-header">
            <div class="current-user-info">
              <span class="user-label">当前查看：</span>
              <span class="user-name">{{ selectedUser?.userName || '未知用户' }}（{{ selectedDeviceId }}）</span>
            </div>
            <div class="refresh-status">
              <span class="refresh-dot active"></span>
              数据实时更新中
            </div>
          </div>

          <div class="health-grid">
            <div class="grid-column">
              <div class="health-card">
                <HeartRate :key="refreshKey" :userId="selectedDeviceId" />
              </div>
              <div class="health-card">
                <BloodPressure :key="refreshKey" :userId="selectedDeviceId" />
              </div>
              <div class="health-card">
                <BloodOxygen :key="refreshKey" :userId="selectedDeviceId" />
              </div>
            </div>

            <div class="grid-column">
              <div class="health-card logo-card">
                <Logo :key="refreshKey" :userInfo="selectedUserInfo" :userId="selectedDeviceId" />
              </div>
              <div class="health-card activity-card">
                <ActivityAnalysis :key="refreshKey" :userId="selectedDeviceId" />
              </div>
            </div>

            <div class="grid-column">
              <div class="health-card">
                <SleepQuality :key="refreshKey" :userId="selectedDeviceId" />
              </div>
              <div class="health-card">
                <FallDetection :key="refreshKey" :userId="selectedDeviceId" />
              </div>
              <div class="health-card">
                <TemperatureDetection :key="refreshKey" :userId="selectedDeviceId" />
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { getAdminUserList, getAllUsersHealthData, getLogoUserData } from '../api/index.js'
import HeartRate from '../components/HeartRate.vue'
import BloodPressure from '../components/BloodPressure.vue'
import BloodOxygen from '../components/BloodOxygen.vue'
import Logo from '../components/Logo.vue'
import ActivityAnalysis from '../components/ActivityAnalysis.vue'
import SleepQuality from '../components/SleepQuality.vue'
import FallDetection from '../components/FallDetection.vue'
import TemperatureDetection from '../components/TemperatureDetection.vue'

const router = useRouter()

const loading = ref(true)
const userList = ref([])
const allHealthData = ref([])
const selectedDeviceId = ref('')
const selectedUser = ref(null)
const selectedUserInfo = ref({ userName: '未知用户', deviceId: '' })
const refreshKey = ref(0)

let refreshTimer = null
let alertAudio = null

const isUserFallAlert = (deviceId) => {
  const healthData = allHealthData.value.find(item => item.deviceId === deviceId)
  return healthData && healthData.fallScore > 70
}

const getUserFallScore = (deviceId) => {
  const healthData = allHealthData.value.find(item => item.deviceId === deviceId)
  return healthData ? healthData.fallScore : 0
}

const selectUser = async (user) => {
  selectedDeviceId.value = user.deviceId
  selectedUser.value = user

  try {
    const res = await getLogoUserData(user.deviceId)
    selectedUserInfo.value = { ...res, deviceId: user.deviceId }
  } catch (err) {
    selectedUserInfo.value = {
      userName: user.userName || '未知用户',
      deviceId: user.deviceId
    }
  }

  refreshKey.value++
}

const goBackLogin = () => {
  router.push('/login')
}

const fetchUserList = async () => {
  try {
    loading.value = true
    const res = await getAdminUserList()

    if (Array.isArray(res)) {
      userList.value = res
    } else if (res && Array.isArray(res.data)) {
      userList.value = res.data
    } else if (res && Array.isArray(res.list)) {
      userList.value = res.list
    } else {
      userList.value = [
        { deviceId: 'DEV001', userName: '张三', age: 65, gender: '男' },
        { deviceId: 'DEV002', userName: '李四', age: 68, gender: '女' },
        { deviceId: 'DEV003', userName: '王五', age: 70, gender: '男' }
      ]
    }
  } catch (err) {
    console.error('获取用户列表失败：', err)
    userList.value = [
      { deviceId: 'DEV001', userName: '张三', age: 65, gender: '男' },
      { deviceId: 'DEV002', userName: '李四', age: 68, gender: '女' },
      { deviceId: 'DEV003', userName: '王五', age: 70, gender: '男' }
    ]
  } finally {
    loading.value = false
  }
}

const refreshAllHealthData = async () => {
  try {
    const res = await getAllUsersHealthData()
    allHealthData.value = Array.isArray(res) ? res : (res.data || [])

    const hasAlertUser = allHealthData.value.some(item => item.fallScore > 70)
    if (hasAlertUser && alertAudio && alertAudio.paused) {
      alertAudio.play().catch(err => console.warn('警报音频播放失败：', err))
    } else if (!hasAlertUser && alertAudio && !alertAudio.paused) {
      alertAudio.pause()
      alertAudio.currentTime = 0
    }

    if (selectedDeviceId.value) {
      refreshKey.value++
    }
  } catch (err) {
    console.error('刷新健康数据失败：', err)
  }
}

const initAlertAudio = () => {
  try {
    alertAudio = new Audio('https://cdn.pixabay.com/download/audio/2022/03/15/audio_99614039f0.mp3?filename=emergency-alarm-112191.mp3')
    alertAudio.loop = true
    alertAudio.volume = 0.6
  } catch (err) {
    console.warn('音频初始化失败，将使用无声模式：', err)
  }
}

onMounted(() => {
  initAlertAudio()
  fetchUserList()
  refreshTimer = setInterval(refreshAllHealthData, 5000)
})

onUnmounted(() => {
  if (refreshTimer) clearInterval(refreshTimer)
  if (alertAudio) {
    alertAudio.pause()
    alertAudio.currentTime = 0
  }
})
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

/* 🔥 暖色调背景 */
.admin-page {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);
  display: flex;
  flex-direction: column;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  position: fixed;
  top: 0;
  left: 0;
}

.bg-layer {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background:
      radial-gradient(ellipse at 20% 20%, rgba(234, 88, 12, 0.1) 0%, transparent 50%),
      radial-gradient(ellipse at 80% 80%, rgba(249, 115, 22, 0.08) 0%, transparent 50%);
  pointer-events: none;
  z-index: 0;
}

.page-header {
  width: 100%;
  height: 60px;
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 30px;
  position: relative;
  z-index: 10;
  flex-shrink: 0;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-icon {
  font-size: 28px;
}

.header-title {
  font-size: 20px;
  font-weight: 700;
  color: #444;
  letter-spacing: 1px;
}

.logout-btn {
  padding: 8px 20px;
  background: linear-gradient(90deg, #ea580c, #f97316);
  border: none;
  border-radius: 20px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.logout-btn:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 15px rgba(234, 88, 12, 0.3);
}

.main-container {
  flex: 1;
  display: flex;
  gap: 15px;
  padding: 15px 30px;
  position: relative;
  z-index: 5;
  min-height: 0;
  overflow: hidden;
}

.user-list-panel {
  width: 280px;
  flex-shrink: 0;
  background: rgba(255, 255, 255, 0.5);
  backdrop-filter: blur(20px);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.7);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.panel-title {
  padding: 15px 20px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 16px;
  font-weight: 700;
  color: #444;
  flex-shrink: 0;
}

.user-count {
  font-size: 12px;
  font-weight: 500;
  color: #78716c;
  background: rgba(234, 88, 12, 0.1);
  padding: 3px 10px;
  border-radius: 12px;
}

.loading-box {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 15px;
  color: #78716c;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(234, 88, 12, 0.15);
  border-top-color: #ea580c;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.user-list-scroll {
  flex: 1;
  overflow-y: auto;
  padding: 10px 15px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.user-list-scroll::-webkit-scrollbar {
  width: 4px;
}

.user-list-scroll::-webkit-scrollbar-thumb {
  background: rgba(234, 88, 12, 0.2);
  border-radius: 2px;
}

.user-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 15px;
  background: rgba(255, 255, 255, 0.4);
  border-radius: 8px;
  border: 1px solid rgba(0, 0, 0, 0.04);
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
}

.user-item:hover {
  background: rgba(255, 255, 255, 0.6);
  transform: translateX(3px);
}

.user-item.active {
  background: rgba(234, 88, 12, 0.12);
  border-color: rgba(234, 88, 12, 0.25);
}

.user-item.alert {
  background: rgba(239, 68, 68, 0.12);
  border-color: rgba(239, 68, 68, 0.3);
  animation: alertPulse 2s ease-in-out infinite;
}

@keyframes alertPulse {
  0%, 100% { box-shadow: 0 0 8px rgba(239, 68, 68, 0.15); }
  50% { box-shadow: 0 0 20px rgba(239, 68, 68, 0.3); }
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ea580c, #f97316);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 18px;
  font-weight: 700;
  flex-shrink: 0;
  position: relative;
}

.user-avatar.alert-avatar {
  background: linear-gradient(135deg, #ef4444, #f97316);
}

.alert-badge {
  position: absolute;
  top: -5px;
  right: -5px;
  font-size: 14px;
}

.user-info {
  flex: 1;
  min-width: 0;
}

.user-name {
  font-size: 14px;
  font-weight: 600;
  color: #444;
  margin-bottom: 4px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.alert-tag {
  font-size: 10px;
  background: #ef4444;
  color: #fff;
  padding: 2px 6px;
  border-radius: 8px;
  font-weight: 600;
}

.user-device {
  font-size: 12px;
  color: #78716c;
}

.fall-score {
  font-size: 11px;
  color: #ef4444;
  font-weight: 600;
  margin-top: 2px;
}

.arrow-icon {
  font-size: 16px;
  color: #ea580c;
  font-weight: 700;
}

.data-detail-panel {
  flex: 1;
  background: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(20px);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.7);
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.empty-state {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 15px;
  color: #a8a29e;
}

.empty-icon {
  font-size: 60px;
  opacity: 0.3;
}

.empty-text {
  font-size: 20px;
  font-weight: 600;
  color: #78716c;
}

.empty-desc {
  font-size: 14px;
  color: #a8a29e;
}

.data-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.data-header {
  padding: 12px 20px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-shrink: 0;
}

.current-user-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.user-label {
  font-size: 14px;
  color: #78716c;
}

.user-name {
  font-size: 16px;
  font-weight: 700;
  color: #444;
}

.refresh-status {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: #78716c;
}

.refresh-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #a8a29e;
}

.refresh-dot.active {
  background: #22c55e;
  box-shadow: 0 0 8px #22c55e;
  animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.2); opacity: 0.7; }
}

.health-grid {
  flex: 1;
  display: flex;
  gap: 10px;
  padding: 15px;
  overflow: hidden;
  min-height: 0;
}

.grid-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 10px;
  min-width: 0;
}

.health-card {
  flex: 1;
  background: rgba(255, 255, 255, 0.5);
  backdrop-filter: blur(15px);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.7);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.health-card .card-title {
  padding: 8px 12px;
  font-size: 14px;
  font-weight: 600;
  color: #444;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  flex-shrink: 0;
}

.logo-card {
  flex: 0.7;
}

.activity-card {
  flex: 1.3;
}

.health-card > *:not(.card-title) {
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