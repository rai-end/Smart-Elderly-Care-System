<template>
  <div class="temp-card">
    <h3 class="card-title">体温检测</h3>
    <div class="current-data" v-if="!loading">
      <span class="value">{{ tempData.temperature }}</span>
      <span class="unit">℃</span>
    </div>
    <div class="current-data" v-else>加载中...</div>
    <div class="normal-range">正常范围：{{ tempData.normalRange }}</div>
    <div class="status" :class="{ warning: tempData.status !== '正常' }">
      {{ tempData.status }}
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { getTemperatureData } from '../api/index.js'

const props = defineProps({
  userId: { type: String, required: true, default: 'default-user' },
  userName: { type: String, required: true, default: '默认用户' }
})


const tempData = ref({ temperature: 36.5, normalRange: '36.0-37.2', status: '正常' })
const loading = ref(false)
let timer = null

const fetchTempData = async () => {
  if (loading.value) return
  loading.value = true
  try {
    const res = await getTemperatureData(props.userId)
    tempData.value = { ...tempData.value, ...res }
    if (res.temperature && !res.status) {
      tempData.value.status = res.temperature > 37.2 ? '发热' : res.temperature < 36.0 ? '体温偏低' : '正常'
    }
  } catch (error) {
    console.error(`获取${props.userId}体温数据失败：`, error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchTempData()
  timer = setInterval(fetchTempData, 10000) // 每10秒刷新
})

watch(() => props.userId, () => {
  clearInterval(timer)
  fetchTempData()
  timer = setInterval(fetchTempData, 10000)
})

onUnmounted(() => {
  clearInterval(timer)
})
</script>

<style scoped>
.temp-card {
  height: 100%;
  padding: 15px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(142, 68, 173, 0.1);
  border: 1px solid rgba(142, 68, 173, 0.1);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  box-sizing: border-box;
}
.card-title { color: #8e44ad; font-size: 16px; font-weight: 600; margin-bottom: 15px; }
.current-data { font-size: 28px; font-weight: 700; color: #333; margin-bottom: 5px; }
.unit { font-size: 16px; color: #666; margin-left: 5px; }
.normal-range { font-size: 12px; color: #999; margin-bottom: 10px; }
.status { font-size: 16px; font-weight: 600; color: #27ae60; }
.status.warning { color: #e74c3c; }
</style>