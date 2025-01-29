<template>
  <header>
    <div>
      <div class="logo">
        <OllamaLogo class="ollama-icon" @click="CleanChat" />
        <ModelsList />
      </div>
    </div>
    <Menu />
  </header>
</template>

<script setup>
import eventBus from "../../EventsBus";
import OllamaLogo from "../icons/OllamaLogo.vue";
import ModelsList from "./components/Menu/components/ModelsList.vue";
import Menu from "./components/Menu/index.vue";

const CleanChat = () => {
  eventBus.$emit("cleanChat", "");
};
</script>

<style scoped>
header {
  background: var(--neutral-color-70);

  position: sticky;
  top: 0;

  padding: 20px 20px;
  width: 100%;
  display: flex;
  gap: 20px;
  justify-content: space-between;

  div {
    display: grid;
    gap: 10px;
    .logo {
      width: fit-content;
      display: flex;
      gap: 10px;
      place-items: center;
    }
  }
}

.ollama-icon {
  cursor: pointer;
  height: 2rem;
  width: 2rem;

  transition: scale 200ms;

  &:hover {
    scale: 1.2;
  }
}
</style>
