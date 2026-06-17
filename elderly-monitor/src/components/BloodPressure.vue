<template>
  <div class="bp-card">
    <h3 class="card-title">血压监测</h3>
    <div class="current-data" v-if="!loading">
      <span class="systolic">{{ bpData.systolic }}</span>/<span class="diastolic">{{ bpData.diastolic }}</span>
      <span class="unit">mmHg</span>
    </div>
    <div class="current-data" v-else>加载中...</div>
    <div class="normal-range">正常范围：{{ bpData.normalRange }}</div>
    <div class="status" :class="{ warning: bpData.systolic > 140 || bpData.diastolic > 90 }">
      {{ bpData.systolic > 140 || bpData.diastolic > 90 ? '偏高' : '正常' }}
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { getBloodPressureData } from '../api/index.js'


const props = defineProps({
  userId: { type: String, required: true, default: 'default-user' },
  userName: { type: String, required: true, default: '默认用户' }
})


const bpData = ref({ systolic: 125, diastolic: 80, normalRange: '收缩压90-140，舒张压60-90' })
const loading = ref(false)
let timer = null


const fetchBpData = async () => {
  if (loading.value) return
  loading.value = true
  try {
    const res = await getBloodPressureData(props.userId)
    bpData.value = { ...bpData.value, ...res }
  } catch (error) {
    console.error(`获取${props.userId}血压数据失败：`, error)
  } finally {
    loading.value = false
  }
}


onMounted(() => {
  fetchBpData()
  timer = setInterval(fetchBpData, 20000) // 每20秒刷新
})


watch(() => props.userId, () => {
  clearInterval(timer)
  fetchBpData()
  timer = setInterval(fetchBpData, 20000)
})

onUnmounted(() => {
  clearInterval(timer)
})
</script>

<style scoped>
.bp-card {
  height: 100%;
  padding: 15px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(52, 152, 219, 0.1);
  border: 1px solid rgba(52, 152, 219, 0.1);
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
}
.card-title { color: #3498db; font-size: 16px; font-weight: 600; margin-bottom: 10px; }
.current-data { font-size: 24px; font-weight: 700; color: #333; margin-bottom: 5px; }
.unit { font-size: 14px; color: #666; margin-left: 5px; }
.normal-range { font-size: 12px; color: #999; margin-bottom: 10px; }
.status { font-size: 14px; font-weight: 600; color: #27ae60; }
.status.warning { color: #e74c3c; }
</style>