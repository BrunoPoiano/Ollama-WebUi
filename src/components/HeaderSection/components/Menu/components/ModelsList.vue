<template>
  <div class="models-list">
    <label for="">Select a model</label>
    <div>
      <select v-model="selectedModel" @change="handleSelectedModel" aria-placeholder="Select a model">
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
import ollama from "ollama";
import { onMounted, ref, defineEmits } from "vue";

const emit = defineEmits(["selectedModelEmit"]);
const models = ref([]);
const selectedModel = ref(localStorage.getItem("SELECTED_MODEL"));
const loading = ref(false);

const listModels = async () => {
  loading.value = true;
  const modelsList = await ollama.list();
  models.value = modelsList.models;
  loading.value = false;
};

const handleSelectedModel = () => {
  localStorage.setItem("SELECTED_MODEL", selectedModel.value);

  window.dispatchEvent(new CustomEvent('SELECTED_MODEL_CHANGE', {
    detail: {
      storage: localStorage.getItem('SELECTED_MODEL')
    }
  }));
};

onMounted(() => {
  listModels();
});
</script>

<style>
.models-list {
  width: 100%;
  gap: 1.3rem;

  display: grid;
  gap: 0.9rem;

  >div {
    display: flex;
    justify-content: center;
    place-items: center;
    gap: 0.9rem;

  }

  & button {
    --width: 2rem;
    font-size: 1.2rem;
    padding: 0px;
    width: var(--width);
    min-width: var(--width);
    aspect-ratio: 1;
  }

  & button[data-loading="false"]>i {
    animation: 500ms fadeOut ease-out forwards;
  }
}

@keyframes fadeOut {
  to {
    rotate: 180deg;
  }
}
</style>