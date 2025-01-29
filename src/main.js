import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router/index.js';

const app = createApp(App);

export const eventBus = app.config.globalProperties.$bus = {
  events: {}
};
app.use(router);
app.mount('#app');
