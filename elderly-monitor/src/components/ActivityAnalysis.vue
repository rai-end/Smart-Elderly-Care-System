<template>
  <div class="activity-analysis-card">
    <div class="card-header">
      <h3 class="card-title">活动量分析</h3>
      <div class="total-activity">
        今日总活动量：{{ totalActivity }} 步 (用户: {{ userId }})
      </div>
    </div>
    <div class="card-chart" ref="chartRef"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import * as echarts from 'echarts'
import { getActivityData } from '../api/index.js'

const props = defineProps({
  userId: {
    type: String,
    required: true,
    default: 'DEV001'
  }
})

const totalActivity = ref(0)
const chartRef = ref(null)
let chartInstance = null

const activityTimer = ref(null)

const isFetching = ref(false)

const startAutoRefresh = () => {
  if (activityTimer.value) {
    clearInterval(activityTimer.value)
    activityTimer.value = null
    console.log(`【Activity】旧定时器已清除`)
  }

  activityTimer.value = setInterval(() => {
    fetchData()
  }, 30000)

  console.log(`【Activity】新定时器已启动，严格30秒刷新一次`)
}

const fetchData = async () => {
  if (isFetching.value) {
    console.log(`【Activity】上一次请求还在进行中，跳过本次`)
    return
  }

  isFetching.value = true
  console.log(`【Activity】[${new Date().toLocaleTimeString()}] 开始获取用户 ${props.userId} 的数据`)

  try {
    const res = await getActivityData(props.userId)
    console.log(`【Activity】后端返回:`, res)

    totalActivity.value = res?.totalSteps || 2856

    if (chartInstance) {
      const data = res?.periodData || [850, 620, 1100, 286]
      chartInstance.setOption({
        series: [{ data: data }]
      })
    }
  } catch (e) {
    console.error(`【Activity】获取失败:`, e)
    totalActivity.value = 2856
  } finally {
    isFetching.value = false
  }
}

const initChart = () => {
  if (!chartRef.value) return
  chartInstance = echarts.init(chartRef.value)

  const option = {
    grid: { top: 10, left: 0, right: 0, bottom: 20, containLabel: true },
    xAxis: {
      type: 'category',
      data: ['早晨', '中午', '下午', '晚上'],
      axisLabel: { fontSize: 12, color: '#999' }
    },
    yAxis: {
      type: 'value',
      splitLine: { lineStyle: { color: '#f5f5f5' } }
    },
    series: [{
      data: [850, 620, 1100, 286],
      type: 'bar',
      barWidth: '40%',
      itemStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: '#FF8A65' },
          { offset: 1, color: '#FFB74D' }
        ])
      },
      label: { show: true, position: 'top', fontSize: 10, color: '#666' }
    }]
  }
  chartInstance.setOption(option)
}

const resize = () => chartInstance && chartInstance.resize()

watch(() => props.userId, (newId) => {
  console.log(`【Activity】监听到用户变化: ${newId}`)

  if (activityTimer.value) {
    clearInterval(activityTimer.value)
    activityTimer.value = null
  }

  fetchData()

  startAutoRefresh()
}, { immediate: false })

onMounted(() => {
  console.log(`【Activity】组件挂载，用户: ${props.userId}`)
  initChart()
  window.addEventListener('resize', resize)

  fetchData()

  startAutoRefresh()
})

onUnmounted(() => {
  console.log(`【Activity】组件销毁`)
  window.removeEventListener('resize', resize)

  if (activityTimer.value) {
    clearInterval(activityTimer.value)
    activityTimer.value = null
    console.log(`【Activity】定时器已彻底清除`)
  }

  if (chartInstance) {
    chartInstance.dispose()
    chartInstance = null
  }
})
</script>

<style scoped>
.activity-analysis-card {
  height: 100%;
  padding: 20px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(255, 140, 0, 0.1);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.card-header { margin-bottom: 10px; }
.card-title { margin-bottom: 5px; color: #E67E22; font-size: 16px; font-weight: 600; }
.total-activity { font-size: 18px; font-weight: 700; color: #333; }
.card-chart { flex: 1; width: 100%; }
</style>