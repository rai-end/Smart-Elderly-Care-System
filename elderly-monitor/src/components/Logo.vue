<template>
  <div class="logo-card-wrapper">
    <div class="corner-tag">智护</div>

    <div class="logo-card">
      <div class="logo-decoration-ring ring-1"></div>
      <div class="logo-decoration-ring ring-2"></div>
      <div class="logo-decoration-ring ring-3"></div>

      <div class="logo-icon-wrapper">
        <div class="logo-icon-core">
          <div class="core-inner">
            <span class="icon-text">智护</span>
          </div>
          <div class="core-glow"></div>
        </div>
        <div class="floating-dot dot-1"></div>
        <div class="floating-dot dot-2"></div>
        <div class="floating-dot dot-3"></div>
      </div>

      <div class="logo-title">智能老人监测系统</div>
      <div class="logo-subtitle">用心守护 · 安心陪伴</div>

      <div class="button-wrapper">
        <button @click="goToAI" class="ai-button">
          🤖 AI 健康助手
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
const router = useRouter()

const goToAI = () => {
  router.push('/ai-chat')
}
</script>

<style scoped>
.logo-card-wrapper {
  position: relative;
  width: 100%;
  height: 100vh;
  margin: 0;
  padding: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #fed7aa, #fdba74);
}

.corner-tag {
  position: absolute;
  top: 20px;
  left: 20px;
  background: linear-gradient(90deg, #ea580c, #f97316);
  color: white;
  padding: 6px 14px;
  border-radius: 8px 8px 0 0;
  font-weight: 600;
  font-size: 16px;
  z-index: 10;
}

.logo-card {
  width: 100%;
  height: 100%;
  max-width: 100%;
  padding: 30px 20px;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(15px);
  border-radius: 0;
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  position: relative;
  overflow: visible;
}

.button-wrapper {
  margin-top: 18px;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.ai-button {
  width: auto;
  padding: 8px 20px;
  /* 暖色调按钮 */
  background: linear-gradient(90deg, #ea580c, #f97316);
  border: none;
  border-radius: 20px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  /* 暖色调阴影 */
  box-shadow: 0 4px 15px rgba(234, 88, 12, 0.4);
  z-index: 2;
}

.ai-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(234, 88, 12, 0.6);
}

.ai-button:active {
  transform: translateY(0);
}

.logo-decoration-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  pointer-events: none;
  z-index: 1;
}

.ring-1 {
  width: 280px;
  height: 280px;
  animation: rotateRing 20s linear infinite;
  /* 暖色调边框 */
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.ring-2 {
  width: 320px;
  height: 320px;
  animation: rotateRing 25s linear infinite reverse;
  /* 暖色调边框 */
  border: 1px dashed rgba(255, 255, 255, 0.25);
}

.ring-3 {
  width: 360px;
  height: 360px;
  animation: rotateRing 30s linear infinite;
  /* 暖色调边框 */
  border: 1px solid rgba(255, 255, 255, 0.2);
}

@keyframes rotateRing {
  from { transform: translate(-50%, -50%) rotate(0deg); }
  to { transform: translate(-50%, -50%) rotate(360deg); }
}

.logo-icon-wrapper {
  position: relative;
  margin-bottom: 12px;
  z-index: 2;
}

.logo-icon-core {
  width: 65px;
  height: 65px;
  border-radius: 50%;
  /* 暖色调渐变 */
  background: radial-gradient(circle at 30% 30%, rgba(255, 255, 255, 0.5), transparent 60%),
  linear-gradient(135deg, #ea580c, #f97316);
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  /* 暖色调阴影 */
  box-shadow: 0 10px 30px rgba(234, 88, 12, 0.5),
  inset 0 2px 0 rgba(255, 255, 255, 0.4);
  animation: corePulse 3s ease-in-out infinite;
}

@keyframes corePulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

.core-inner {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 2;
}

.icon-text {
  font-size: 16px;
  font-weight: 800;
  color: white;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.core-glow {
  position: absolute;
  top: -10px;
  left: -10px;
  right: -10px;
  bottom: -10px;
  border-radius: 50%;
  /* 暖色调光晕 */
  background: radial-gradient(circle, rgba(234, 88, 12, 0.4), transparent 70%);
  filter: blur(15px);
  z-index: 1;
  animation: glowPulse 3s ease-in-out infinite;
}

@keyframes glowPulse {
  0%, 100% { opacity: 0.6; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.1); }
}

.floating-dot {
  position: absolute;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #fff;
  /* 暖色调光点阴影 */
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.8), 0 0 20px rgba(234, 88, 12, 0.6);
  pointer-events: none;
}

.dot-1 { top: -5px; left: 50%; transform: translateX(-50%); animation: dotFloat1 2.5s ease-in-out infinite; }
.dot-2 { bottom: 10px; left: -8px; animation: dotFloat2 3s ease-in-out infinite; animation-delay: -1s; }
.dot-3 { bottom: 10px; right: -8px; animation: dotFloat3 2.8s ease-in-out infinite; animation-delay: -0.5s; }

@keyframes dotFloat1 { 0%,100% { transform: translateX(-50%) translateY(0); opacity: 1; } 50% { transform: translateX(-50%) translateY(-8px); opacity: 0.7; } }
@keyframes dotFloat2 { 0%,100% { transform: translateY(0); opacity: 1; } 50% { transform: translateY(-5px) translateX(3px); opacity: 0.6; } }
@keyframes dotFloat3 { 0%,100% { transform: translateY(0); opacity: 1; } 50% { transform: translateY(-5px) translateX(-3px); opacity: 0.6; } }

.logo-title {
  font-size: 20px;
  font-weight: 800;
  /* 暖色调文字 */
  color: #fff7ed;
  letter-spacing: 2px;
  margin-bottom: 6px;
  z-index: 2;
}

.logo-subtitle {
  font-size: 14px;
  /* 暖色调文字 */
  color: rgba(255, 247, 237, 0.8);
  letter-spacing: 1px;
  font-weight: 500;
  z-index: 2;
}
</style>