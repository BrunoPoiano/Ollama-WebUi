<template>
  <button @click="openModal">Create new model</button>

  <Teleport to="body">
    <dialog id="createModelModal">
      <div class="form">
        <button data-modal-close @click="closeModal">
          <i class="fa-solid fa-x"></i>
        </button>
        <h5>Create Model</h5>
        <div>
          <label for="">Model name</label>
          <input type="text" placeholder="Ex: Mario" v-model="form.name" />
        </div>
        <div>
          <label for="">Base model</label>
          <select
            v-model="form.model"
            @change="handleSelectedModel"
            placeholder="Base model"
          >
            <option
              v-for="model in models"
              :key="model.model"
              :value="model.model"
            >
              {{ model.name }}
            </option>
          </select>
        </div>
        <div>
          <label for="">Personality</label>
          <textarea
            placeholder="Ex: You are mario from Super Mario Bros."
            id=""
            cols="30"
            rows="10"
            v-model="form.personality"
          />
        </div>

        <button @click="createModel" :disabled="disableCreateButton">
          Create Model
        </button>
      </div>
    </dialog>
  </Teleport>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";

const form = ref({});
const models = ref([]);
const ollama_end_point = import.meta.env.VITE_OLLAMA_END_POINT;
const controller = new AbortController();
const emits = defineEmits(["refreshContent"]);

const openModal = () => {
  form.value = {};
  listModels();
  const createModelModal = document.getElementById("createModelModal");
  createModelModal.showModal();
};

const closeModal = () => {
  const createModelModal = document.getElementById("createModelModal");
  createModelModal.close();
};

const createModel = async () => {
  const model = {
    name: form.value.name,
    modelfile: `FROM ${form.value.model}\nSYSTEM ${form.value.personality}`,
  };

  try {
    const response = await fetch(`${ollama_end_point}/create`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(model),
      signal: controller.signal,
    });

    form.value = {};
    emits("refreshContent");
    closeModal();
  } catch (error) {
    controller.abort();
    console.error("Error:", error);
  }
};

const listModels = async () => {
  try {
    const response = await fetch(`${ollama_end_point}/list`, {
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

const disableCreateButton = computed(() => {
  if (!form.value.name) {
    return true;
  }
  if (!form.value.model) {
    return true;
  }
  if (!form.value.personality) {
    return true;
  }

  return false;
});
</script>

<style scoped>
.form {
  display: grid;
  gap: 10px;

  > div {
    display: grid;
    gap: 5px;
  }

  & select {
    max-width: 100%;
  }
}
</style>
