<template>
  <div class="models-list">
    <div>
      <select
        v-model="selectedModel"
        @change="handleSelectedModel"
        aria-placeholder="Select a model"
      >
        <option v-for="model in models" :key="model.model" :value="model.model">
          {{ model.name }}
        </option>
      </select>
      <button @click="listModels" data-icon :data-loading="loading">
        <i class="fa fa-refresh" aria-hidden="true"></i>
      </button>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref, defineEmits } from "vue";
const ollama_end_point = import.meta.env.VITE_OLLAMA_END_POINT;
const emit = defineEmits(["selectedModelEmit"]);
const models = ref([]);
const selectedModel = ref(localStorage.getItem("SELECTED_MODEL"));
const loading = ref(false);

const listModels = async () => {
  loading.value = true;
  try {
    const response = await fetch(`${ollama_end_point}/tags`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      },
    });
    const modelsList = await response.json();
    models.value = modelsList.models;
    loading.value = false;
  } catch (error) {
    console.error("Error:", error);
  }
};

const handleSelectedModel = () => {
  localStorage.setItem("SELECTED_MODEL", selectedModel.value);
};

onMounted(() => {
  listModels();
});
</script>

<style>
.models-list {
  width: max-content;
  gap: 20px;

  display: grid;
  gap: 10px;

  > div {
    display: flex;
    justify-content: center;
    place-items: center;
    gap: 10px;
  }

  & button {
    --width: 2rem;
    font-size: 1.2rem;
    padding: 0px;
    width: var(--width);
    min-width: var(--width);
    aspect-ratio: 1;
  }

  & button[data-loading="false"] > i {
    animation: 500ms fadeOut ease-out forwards;
  }
}

@keyframes fadeOut {
  to {
    rotate: 180deg;
  }
}
</style>
