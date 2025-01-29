<template>
  <div class="menu" id="menu">
    <button @click="toggleMenu" data-icon :data-open="menuOpen">
      <i class="fa-solid fa-angle-right"></i>
    </button>
    <div class="menu-wrapper" :data-open="menuOpen">
      <div class="app-menu">
        <AppLinks />
        <ResponseData />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import ModelsList from "./components/ModelsList.vue";
import ResponseData from "./components/ResponseData.vue";
import AppLinks from "./components/AppLinks.vue";

const menuOpen = ref(false);

const toggleMenu = () => {
  menuOpen.value = !menuOpen.value;
};

function handleClickOutside(event) {
  const menu = document.getElementById("menu");
  if (!menu.contains(event.target)) {
    if (menuOpen.value) {
      toggleMenu();
    }
  }
}

onMounted(() => {
  document.addEventListener("mousedown", handleClickOutside);
});

onUnmounted(() => {
  document.addEventListener("mousedown", handleClickOutside);
});
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
  padding: 20px;

  display: flex;
  flex-direction: column;
  gap: 20px;

  border-radius: var(--border-radius);
  background: var(--neutral-color-75);
  transition: display 500ms;
}

.menu-wrapper[data-open="false"] {
  display: none;

  > .app-menu {
    display: none;
  }
}

.app-menu {
  gap: 20px;
  display: grid;
  place-items: baseline;

  grid-template-rows: auto  1fr;

  margin-top: 2rem;
  height: 100%;
}
</style>
