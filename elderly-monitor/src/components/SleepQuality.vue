<template>
  <div class="sleep-card">
    <h3 class="card-title">睡眠质量</h3>
    <div class="loading" v-if="loading">加载中...</div>
    <div class="sleep-data" v-else>
      <div class="total-sleep">
        总睡眠时长：<span>{{ sleepData.totalSleep }}</span> 小时
      </div>
      <div class="sleep-breakdown">
        <div class="deep-sleep">
          深度睡眠：<span>{{ sleepData.deepSleep }}</span> 小时
        </div>
        <div class="shallow-sleep">
          浅度睡眠：<span>{{ sleepData.shallowSleep }}</span> 小时
        </div>
      </div>
      <div class="quality">睡眠质量：<span>{{ sleepData.quality }}</span></div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { getSleepQualityData } from '../api/index.js'

const props = defineProps({
  userId: { type: String, required: true, default: 'default-user' },
  userName: { type: String, required: true, default: '默认用户' }
})

const sleepData = ref({ totalSleep: 7.5, deepSleep: 2.5, shallowSleep: 5, quality: '良好' })
const loading = ref(false)
let timer = null

const fetchSleepData = async () => {
  if (loading.value) return
  loading.value = true
  try {
    const res = await getSleepQualityData(props.userId)
    sleepData.value = { ...sleepData.value, ...res }
  } catch (error) {
    console.error(`获取${props.userId}睡眠数据失败：`, error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchSleepData()
  timer = setInterval(fetchSleepData, 30000) // 每30秒刷新
})

watch(() => props.userId, () => {
  clearInterval(timer)
  fetchSleepData()
  timer = setInterval(fetchSleepData, 30000)
})

onUnmounted(() => {
  clearInterval(timer)
})
</script>

<style scoped>
.sleep-card {
  height: 100%;
  padding: 15px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(155, 89, 182, 0.1);
  border: 1px solid rgba(155, 89, 182, 0.1);
  display: flex;
  flex-direction: column;
  justify-content: center;
  box-sizing: border-box;
}
.card-title { color: #9b59b6; font-size: 16px; font-weight: 600; margin-bottom: 15px; text-align: center; }
.loading { text-align: center; font-size: 16px; color: #666; }
.sleep-data { text-align: center; }
.total-sleep { font-size: 18px; font-weight: 700; color: #333; margin-bottom: 10px; }
.total-sleep span { color: #9b59b6; }
.sleep-breakdown { display: flex; justify-content: space-around; margin-bottom: 10px; }
.deep-sleep, .shallow-sleep { font-size: 14px; color: #666; }
.deep-sleep span, .shallow-sleep span { color: #333; font-weight: 600; }
.quality { font-size: 14px; font-weight: 600; color: #27ae60; }
</style>