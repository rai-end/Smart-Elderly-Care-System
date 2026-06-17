<template>
  <div class="heart-rate-card">
    <h3 class="card-title">心率监测</h3>
    <div class="current-data">
      <span class="value">{{ loading ? '加载中...' : heartRateData.current }}</span>
      <span class="unit">次/分钟</span>
    </div>
    <div class="normal-range">正常范围：{{ heartRateData.normalRange }}</div>
    <div class="trend-chart" ref="chartRef"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import * as echarts from 'echarts'
import { getHeartRateData } from '../api/index.js'

const props = defineProps({
  userId: { type: String, required: true, default: 'default-user' },
  userName: { type: String, required: true, default: '默认用户' }
})

const heartRateData = ref({ current: 75, normalRange: '60-100', trend: [] })
const loading = ref(false)
const chartRef = ref(null)
let chartInstance = null
let timer = null

const fetchHeartRateData = async () => {
  if (loading.value) return
  loading.value = true
  try {
    const res = await getHeartRateData(props.userId)
    heartRateData.value = { ...heartRateData.value, ...res }

    if (chartInstance) {
      const trendData = Array.isArray(res.trend) && res.trend.length > 0 ? res.trend : [70, 72, 75, 73, 76, 74]
      chartInstance.setOption({ series: [{ data: trendData }] })
    }
  } catch (error) {
    console.error(`获取${props.userId}心率数据失败：`, error)
  } finally {
    loading.value = false
  }
}


const initChart = () => {
  if (!chartRef.value) return
  chartInstance = echarts.init(chartRef.value)
  const option = {
    grid: { top: 5, left: 0, right: 0, bottom: 10, containLabel: true },
    xAxis: { type: 'category', data: ['1时', '2时', '3时', '4时', '5时', '6时'], axisLine: { show: false }, axisTick: { show: false }, axisLabel: { fontSize: 10 } },
    yAxis: { type: 'value', axisLine: { show: false }, axisTick: { show: false }, axisLabel: { show: false }, splitLine: { lineStyle: { color: '#f5f5f5' } } },
    series: [{ data: heartRateData.value.trend || [70, 72, 75, 73, 76, 74], type: 'line', smooth: true, itemStyle: { color: '#e74c3c' }, lineStyle: { width: 2 } }],
    tooltip: { trigger: 'item', formatter: '{b}：{c} 次/分钟' }
  }
  chartInstance.setOption(option)
}


const resizeChart = () => chartInstance && chartInstance.resize()


onMounted(() => {
  initChart()
  window.addEventListener('resize', resizeChart)
  fetchHeartRateData()
  timer = setInterval(fetchHeartRateData, 15000) // 每15秒刷新
})


watch(() => props.userId, () => {
  clearInterval(timer)
  fetchHeartRateData()
  timer = setInterval(fetchHeartRateData, 15000)
})

onUnmounted(() => {
  window.removeEventListener('resize', resizeChart)
  clearInterval(timer)
  chartInstance && chartInstance.dispose()
  chartInstance = null
})
</script>

<style scoped>
.heart-rate-card {
  height: 100%;
  padding: 15px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(231, 76, 60, 0.1);
  border: 1px solid rgba(231, 76, 60, 0.1);
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
}
.card-title { color: #e74c3c; font-size: 16px; font-weight: 600; margin-bottom: 10px; }
.current-data { font-size: 24px; font-weight: 700; color: #333; margin-bottom: 5px; }
.unit { font-size: 14px; color: #666; margin-left: 5px; }
.normal-range { font-size: 12px; color: #999; margin-bottom: 10px; }
.trend-chart { flex: 1; width: 100%; min-height: 0; }
</style>