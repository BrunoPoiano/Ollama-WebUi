<template>
  <header>
    <div class="logo">
      <router-link to="/">
        <OllamaLogo class="ollama-icon" />
      </router-link>
      <h5>Ollama chat app</h5>
    </div>
    <div class="menu">
      <Menu />
    </div>
  </header>
</template>

<script setup>
import OllamaLogo from "../icons/OllamaLogo.vue";
import Menu from "./components/Menu/index.vue";
</script>


<style scoped>
header {
  z-index:99;
  position: sticky;
  top: 0;
  background: var(--neutral-color-70);

  padding: 1.3rem;
  width: 100%;
  display: flex;
  gap: 1.3rem;
  justify-content: space-between;

  >.logo {
    display: flex;
    gap: 0.9rem;
    place-items: center;
  }
}

.ollama-icon {
  height: 2rem;
  width: 2rem;
}
</style>
