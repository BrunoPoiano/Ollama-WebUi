
<template>
  <header>
    <div class="logo">
      <OllamaLogo class="ollama-icon" />
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
  position: sticky;
  top: 0;
  background: var(--neutral-color-70);
  
  padding: 20px 20px;
  width: 100%;
  display: flex;
  gap: 20px;
  justify-content: space-between;

  > .logo {
    display: flex;
    gap: 10px;
    place-items: center;
  }
}

.ollama-icon {
  height: 2rem;
  width: 2rem;
}
</style>
