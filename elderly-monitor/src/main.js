import { createApp } from 'vue';
import { createPinia } from 'pinia';
import router from './router';
import App from './App.vue';
import './style.css';

const app = createApp(App);
app.use(createPinia()); // 注册Pinia
app.use(router); // 注册路由
app.mount('#app');