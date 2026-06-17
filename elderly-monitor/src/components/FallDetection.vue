<template>
  <div class="fall-card">
    <h3 class="card-title">跌倒检测</h3>
    <div class="loading" v-if="loading">加载中...</div>
    <div v-else class="fall-content">

      <div class="camera-preview" v-if="isCameraOn">
        <video ref="videoRef" autoplay muted playsinline class="camera-video"></video>
        <div class="camera-overlay" v-if="fallData.fallScore > 70">
          <span class="overlay-text">⚠️ 检测到跌倒</span>
        </div>
      </div>

      <div class="fall-score" :class="{ danger: fallData.fallScore > 70 }">
        <span class="score-label">风险值</span>
        <span class="score-value">{{ fallData.fallScore }}</span>
      </div>

      <div class="status-row">
        <div class="fall-status" :class="{ danger: fallData.status !== '正常' }">
          {{ fallData.status }}
        </div>
        <div class="risk-level">
          <span class="risk-label">风险等级：</span>
          <span class="risk-value" :class="getRiskLevelClass(fallData.riskLevel)">
            {{ fallData.riskLevel }}
          </span>
        </div>
      </div>

      <div class="camera-control">
        <button
            @click="toggleCamera"
            class="camera-btn"
            :class="{ active: isCameraOn }"
        >
          {{ isCameraOn ? '📷 关闭摄像头' : '📷 开启摄像头' }}
        </button>
      </div>

      <div class="check-time-wrapper">
        <span class="check-time-icon">🕐</span>
        <span class="check-time">{{ fallData.lastCheckTime }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch, nextTick } from 'vue'
import { getFallDetectionData, getCameraFallDetection } from '../api/index.js'

const props = defineProps({
  userId: { type: String, required: true, default: 'default-user' },
  userName: { type: String, required: true, default: '默认用户' }
})

const fallData = ref({
  status: '正常',
  lastCheckTime: '',
  riskLevel: '低',
  fallScore: 0
})
const loading = ref(false)
let timer = null


const isCameraOn = ref(false)
const videoRef = ref(null)
let mediaStream = null
let canvas = null


const getRiskLevelClass = (level) => {
  if (level === '高') return 'risk-high'
  if (level === '中') return 'risk-medium'
  return 'risk-low'
}


const toggleCamera = async () => {
  if (isCameraOn.value) {

    stopCamera()
  } else {

    await startCamera()
  }
}


const startCamera = async () => {
  try {

    mediaStream = await navigator.mediaDevices.getUserMedia({
      video: { width: 320, height: 240, facingMode: 'user' }
    })


    if (videoRef.value) {
      videoRef.value.srcObject = mediaStream
    }


    canvas = document.createElement('canvas')
    canvas.width = 320
    canvas.height = 240

    isCameraOn.value = true
    console.log('摄像头已开启')
  } catch (error) {
    console.error('开启摄像头失败:', error)
    alert('无法访问摄像头，请检查权限设置')
  }
}


const stopCamera = () => {
  if (mediaStream) {
    mediaStream.getTracks().forEach(track => track.stop())
    mediaStream = null
  }
  if (videoRef.value) {
    videoRef.value.srcObject = null
  }
  canvas = null
  isCameraOn.value = false
  console.log('摄像头已关闭')
}


const captureFrame = () => {
  if (!canvas || !videoRef.value || !isCameraOn.value) return null

  const ctx = canvas.getContext('2d')
  ctx.drawImage(videoRef.value, 0, 0, canvas.width, canvas.height)
  return canvas.toDataURL('image/jpeg', 0.6) // 压缩为60%质量的JPEG
}

const fetchFallData = async () => {
  if (loading.value) return
  loading.value = true

  try {
    let res
    if (isCameraOn.value) {

      const imageBase64 = captureFrame()
      if (imageBase64) {
        res = await getCameraFallDetection(props.userId, imageBase64)
      } else {

        res = await getFallDetectionData(props.userId)
      }
    } else {

      res = await getFallDetectionData(props.userId)
    }

    fallData.value = { ...fallData.value, ...res }
  } catch (error) {
    console.error(`获取${props.userId}跌倒检测数据失败：`, error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchFallData()
  timer = setInterval(fetchFallData, 5000) // ✅ 改成 5 秒刷新一次
})

watch(() => props.userId, () => {
  clearInterval(timer)
  // 切换用户时自动关闭摄像头
  if (isCameraOn.value) {
    stopCamera()
  }
  fetchFallData()
  timer = setInterval(fetchFallData, 5000) // ✅ 改成 5 秒刷新一次
})

onUnmounted(() => {
  clearInterval(timer)
  if (isCameraOn.value) {
    stopCamera()
  }
})
</script>

<style scoped>
.fall-card {
  height: 100%;
  padding: 12px 15px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(230, 126, 34, 0.1);
  border: 1px solid rgba(230, 126, 34, 0.15);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
  box-sizing: border-box;
  overflow: hidden;
}

.card-title {
  color: #e67e22;
  font-size: 15px;
  font-weight: 700;
  margin: 0 0 8px 0;
  flex-shrink: 0;
}

.loading {
  font-size: 14px;
  color: #666;
  flex: 1;
  display: flex;
  align-items: center;
}

.fall-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  width: 100%;
  flex: 1;
  justify-content: center;
}

/* 🔥 摄像头预览样式 */
.camera-preview {
  position: relative;
  width: 100%;
  max-width: 200px;
  border-radius: 8px;
  overflow: hidden;
  border: 2px solid rgba(230, 126, 34, 0.3);
  margin-bottom: 4px;
}

.camera-video {
  width: 100%;
  height: auto;
  display: block;
  background: #000;
}

.camera-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(231, 76, 60, 0.3);
  display: flex;
  justify-content: center;
  align-items: center;
  animation: pulse 1s ease-in-out infinite;
}

.overlay-text {
  color: white;
  font-weight: 700;
  font-size: 14px;
  text-shadow: 0 0 5px rgba(0, 0, 0, 0.5);
}

@keyframes pulse {
  0%, 100% { opacity: 0.7; }
  50% { opacity: 1; }
}

.fall-score {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  font-weight: 700;
  color: #27ae60;
}

.score-label {
  font-size: 12px;
  color: #666;
  font-weight: 500;
}

.score-value {
  font-size: 28px;
  line-height: 1;
}

.fall-score.danger .score-value {
  color: #e74c3c;
  font-size: 32px;
  text-shadow: 0 0 10px rgba(231, 76, 60, 0.3);
}

.status-row {
  display: flex;
  align-items: center;
  gap: 15px;
  width: 100%;
  justify-content: center;
}

.fall-status {
  font-size: 18px;
  font-weight: 700;
  color: #27ae60;
}

.fall-status.danger {
  color: #e74c3c;
  font-size: 20px;
}

.risk-level {
  font-size: 13px;
  color: #666;
  display: flex;
  align-items: center;
  gap: 4px;
}

.risk-label {
  color: #999;
}

.risk-value {
  font-weight: 600;
  padding: 2px 8px;
  border-radius: 10px;
}

.risk-low {
  color: #27ae60;
  background: rgba(39, 174, 96, 0.1);
}

.risk-medium {
  color: #f39c12;
  background: rgba(243, 156, 18, 0.1);
}

.risk-high {
  color: #e74c3c;
  background: rgba(231, 76, 60, 0.1);
}

.camera-control {
  margin-top: 4px;
  flex-shrink: 0;
}

.camera-btn {
  padding: 4px 12px;
  background: linear-gradient(135deg, #ea580c, #f97316);
  border: none;
  border-radius: 16px;
  color: white;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(234, 88, 12, 0.3);
}

.camera-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(234, 88, 12, 0.4);
}

.camera-btn.active {
  background: linear-gradient(135deg, #e74c3c, #c0392b);
  box-shadow: 0 2px 8px rgba(231, 76, 60, 0.3);
}

.check-time-wrapper {
  display: flex;
  align-items: center;
  gap: 5px;
  margin-top: 4px;
  flex-shrink: 0;
}

.check-time-icon {
  font-size: 12px;
}

.check-time {
  font-size: 11px;
  color: #999;
  white-space: nowrap;
}
</style>