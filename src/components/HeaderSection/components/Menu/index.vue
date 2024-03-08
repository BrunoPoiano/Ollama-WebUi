<template>
  <button @click="toggleMenu" data-icon :data-open="menuOpen">
    <i class="fa-solid fa-angle-right"></i>
  </button>
  <div class="menu-wrapper" :data-open="menuOpen">
    <div class="app-menu">
      <ModelsList v-if="menuOpen == true" />
      <AppLinks />
      <ResponseData />
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import ModelsList from "./components/ModelsList.vue";
import ResponseData from "./components/ResponseData.vue";
import AppLinks from "./components/AppLinks.vue";

const menuOpen = ref(false);

const toggleMenu = () => {
  menuOpen.value = !menuOpen.value;
};
</script>

<style scoped>
button {
  position: relative;
  --width: 2rem;
  background: none;
  font-size: 1.2rem;
  padding: 0px;
  width: var(--width);
  min-width: var(--width);
  aspect-ratio: 1;
  z-index: 9;

  & i {
    transition: all 500ms ease;
  }
}

button[data-open="false"] i {
  rotate: 180deg;
}

.menu-wrapper {
  --max-width: min(100%, 350px);

  position: absolute;
  top: 0;
  right: 0;
  width: var(--max-width);
  height: 100vh;
  padding: 1.3rem;

  display: flex;
  flex-direction: column;
  gap: 1.3rem;

  border-radius: var(--border-radius);
  background: var(--neutral-color-75);
}

.menu-wrapper[data-open="false"] {
  display: none;

  >.app-menu {
    display: none;
  }
}

.app-menu {
  gap: 1.3rem;
  display: grid;
  place-items: baseline;

  grid-template-rows: auto auto 1fr;

  margin-top: 2rem;
  height: 100%;
}
</style>