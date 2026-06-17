<template>
  <div class="bo-card">
    <h3 class="card-title">血氧监测</h3>
    <div class="current-data" v-if="!loading">
      <span class="value">{{ boData.spO2 }}</span>
      <span class="unit">%</span>
    </div>
    <div class="current-data" v-else>加载中...</div>
    <div class="normal-range">正常范围：{{ boData.normalRange }}</div>
    <div class="trend-chart" ref="chartRef"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import * as echarts from 'echarts'
import { getBloodOxygenData } from '../api/index.js'


const props = defineProps({
  userId: { type: String, required: true, default: 'default-user' },
  userName: { type: String, required: true, default: '默认用户' }
})


const boData = ref({ spO2: 98, normalRange: '95-100', trend: [] })
const loading = ref(false)
const chartRef = ref(null)
let chartInstance = null
let timer = null


const fetchBoData = async () => {
  if (loading.value) return
  loading.value = true
  try {
    const res = await getBloodOxygenData(props.userId)
    boData.value = { ...boData.value, ...res }
    // 更新趋势图表
    if (chartInstance) {
      const trendData = Array.isArray(res.trend) && res.trend.length > 0 ? res.trend : [98, 97, 98, 99, 98, 97]
      chartInstance.setOption({ series: [{ data: trendData }] })
    }
  } catch (error) {
    console.error(`获取${props.userId}血氧数据失败：`, error)
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
    yAxis: { type: 'value', min: 90, max: 100, axisLine: { show: false }, axisTick: { show: false }, axisLabel: { show: false }, splitLine: { lineStyle: { color: '#f5f5f5' } } },
    series: [{ data: boData.value.trend || [98, 97, 98, 99, 98, 97], type: 'line', smooth: true, itemStyle: { color: '#2ecc71' }, lineStyle: { width: 2 } }],
    tooltip: { trigger: 'item', formatter: '{b}：{c} %' }
  }
  chartInstance.setOption(option)
}


const resizeChart = () => chartInstance && chartInstance.resize()


onMounted(() => {
  initChart()
  window.addEventListener('resize', resizeChart)
  fetchBoData()
  timer = setInterval(fetchBoData, 15000) // 每15秒刷新
})


watch(() => props.userId, () => {
  clearInterval(timer)
  fetchBoData()
  timer = setInterval(fetchBoData, 15000)
})

onUnmounted(() => {
  window.removeEventListener('resize', resizeChart)
  clearInterval(timer)
  chartInstance && chartInstance.dispose()
  chartInstance = null
})
</script>

<style scoped>
.bo-card {
  height: 100%;
  padding: 15px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(46, 204, 113, 0.1);
  border: 1px solid rgba(46, 204, 113, 0.1);
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
}
.card-title { color: #2ecc71; font-size: 16px; font-weight: 600; margin-bottom: 10px; }
.current-data { font-size: 24px; font-weight: 700; color: #333; margin-bottom: 5px; }
.unit { font-size: 14px; color: #666; margin-left: 5px; }
.normal-range { font-size: 12px; color: #999; margin-bottom: 10px; }
.trend-chart { flex: 1; width: 100%; min-height: 0; }
</style>