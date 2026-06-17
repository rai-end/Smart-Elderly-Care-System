<template>
  <div class="ai-chat-page">
    <div class="chat-header">
      <button class="back-btn" @click="$router.back()">← 返回</button>
      <h2>🤖 智能健康助手</h2>
      <span>老人护理·跌倒急救·健康咨询</span>
    </div>

    <div class="chat-container" ref="chatContainer">
      <div class="message ai-message" v-if="messageList.length === 0">
        <div class="avatar">🤖</div>
        <div class="content">你好！我是专业老人健康看护助手，你可以问我老人护理、跌倒急救、健康饮食等问题~</div>
      </div>

      <div class="message" :class="item.role === 'user' ? 'user-message' : 'ai-message'" v-for="(item, index) in messageList" :key="index">
        <div class="avatar">{{ item.role === 'user' ? '👤' : '🤖' }}</div>
        <div class="content">{{ item.content }}</div>
      </div>

      <div class="loading-tip" v-if="loading">
        <div class="dot"></div>
        <div class="dot"></div>
        <div class="dot"></div>
      </div>
    </div>

    <div class="chat-input-box">
      <input
          v-model="question"
          type="text"
          placeholder="请输入你的问题（如：老人跌倒了怎么办？）"
          @keyup.enter="sendMessage"
          :disabled="loading"
      />
      <button @click="sendMessage" :disabled="loading || !question.trim()">发送</button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import axios from 'axios'

axios.defaults.baseURL = 'http://localhost:8080'

const question = ref('')
const messageList = ref([])
const loading = ref(false)
const chatContainer = ref(null)

const sendMessage = async () => {
  if (!question.value.trim() || loading.value) return
  const userQuestion = question.value.trim()

  messageList.value.push({
    role: 'user',
    content: userQuestion
  })
  question.value = ''
  loading.value = true
  scrollToBottom()

  try {
    const res = await axios.post('/api/chat', null, {
      params: { question: userQuestion }
    })

    messageList.value.push({
      role: 'ai',
      content: res.data
    })
  } catch (err) {
    messageList.value.push({
      role: 'ai',
      content: 'AI服务异常，请稍后再试'
    })
    console.error(err)
  } finally {
    loading.value = false
    scrollToBottom()
  }
}

const scrollToBottom = () => {
  nextTick(() => {
    if (chatContainer.value) {
      chatContainer.value.scrollTop = chatContainer.value.scrollHeight
    }
  })
}

onMounted(() => {
  scrollToBottom()
})
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.ai-chat-page {
  width: 100vw;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 0;
  background:
      radial-gradient(ellipse at 20% 20%, rgba(234, 88, 12, 0.1) 0%, transparent 50%),
      radial-gradient(ellipse at 80% 80%, rgba(249, 115, 22, 0.08) 0%, transparent 50%),
      linear-gradient(135deg, #fffbeb 0%, #fef3c7 25%, #fed7aa 100%);
  background-size: 100% 100%, 100% 100%, 400% 400%;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.chat-header {
  padding: 15px 20px;
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
  text-align: center;
  color: #444;
  flex-shrink: 0;
}
.back-btn {
  position: absolute;
  left: 20px;
  background: rgba(234, 88, 12, 0.15);
  border: none;
  color: #c2410c;
  padding: 6px 12px;
  border-radius: 20px;
  cursor: pointer;
}
.chat-header h2 {
  margin: 0;
  font-size: 18px;
}
.chat-header span {
  font-size: 12px;
  color: #78716c;
}

.chat-container {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 15px;
}
.chat-container::-webkit-scrollbar {
  width: 4px;
}
.chat-container::-webkit-scrollbar-thumb {
  background: rgba(234, 88, 12, 0.25);
  border-radius: 2px;
}

.message {
  display: flex;
  gap: 10px;
  max-width: 75%;
}
.avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: rgba(234, 88, 12, 0.15);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.content {
  padding: 10px 14px;
  border-radius: 12px;
  line-height: 1.5;
  font-size: 14px;
  word-break: break-all;
}

.ai-message {
  align-self: flex-start;
}
.ai-message .content {
  background: rgba(255, 255, 255, 0.7);
  color: #444;
  border: 1px solid rgba(0, 0, 0, 0.05);
}

.user-message {
  align-self: flex-end;
  flex-direction: row-reverse;
}
.user-message .content {
  background: linear-gradient(90deg, #ea580c, #f97316);
  color: #fff;
}

.loading-tip {
  display: flex;
  gap: 5px;
  padding: 10px;
  align-self: center;
}
.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #ea580c;
  animation: bounce 1s infinite;
}
.dot:nth-child(2) { animation-delay: 0.2s; }
.dot:nth-child(3) { animation-delay: 0.4s; }
@keyframes bounce {
  0%,100% { transform: translateY(0); }
  50% { transform: translateY(-8px); }
}

.chat-input-box {
  display: flex;
  gap: 10px;
  padding: 15px 20px;
  background: rgba(255, 255, 255, 0.6);
  border-top: 1px solid rgba(0, 0, 0, 0.05);
  flex-shrink: 0;
}
.chat-input-box input {
  flex: 1;
  padding: 12px 15px;
  border-radius: 24px;
  border: 1px solid rgba(0, 0, 0, 0.06);
  background: rgba(255, 255, 255, 0.8);
  color: #444;
  outline: none;
}
.chat-input-box input::placeholder {
  color: #a8a29e;
}
.chat-input-box button {
  padding: 0 20px;
  border-radius: 24px;
  background: linear-gradient(90deg, #ea580c, #f97316);
  border: none;
  color: #fff;
  cursor: pointer;
}
.chat-input-box button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>