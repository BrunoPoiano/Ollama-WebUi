<template>
  <button @click="openModal">Pull model</button>

  <Teleport to="body">
    <dialog id="pullModel">
      <div class="dialog-wrapper">
        <button data-modal-close @click="closeModal">
          <i class="fa-solid fa-x"></i>
        </button>
        <h5>Pull Model</h5>
        <div class="search">
          <input type="text" v-model="model" placeholder="Model name" />
          <button @click="pullModel">Pull</button>
        </div>

        <div class="loading" v-if="loading">
          <span> downloading </span>
        </div>
        <div class="status">
          <p v-for="(resp, index) in pullResponse" :key="index">
            {{ resp.status }}
          </p>
        </div>
      </div>
    </dialog>
  </Teleport>
</template>

<script setup>
import { ref } from "vue";

const emits = defineEmits(["refreshContent"]);
const model = ref("");
const loading = ref(false);
const pullResponse = ref([]);

const openModal = () => {
  const pullModel = document.getElementById("pullModel");
  pullModel.showModal();
};

const closeModal = () => {
  const pullModel = document.getElementById("pullModel");
  pullModel.close();
};

const pullModel = async () => {
  const params = {
    model: model.value.trim(),
    stream: true,
  };

  try {
    loading.value = true;
    const response = await ollama.pull(params);

    for await (const part of response) {
      const index =
        pullResponse.value.length > 0 ? pullResponse.value.length - 1 : 0;

      if (index === 0) {
        pullResponse.value.push(part);
      }

      if (index > 0 && pullResponse.value[index].status !== part.status) {
        pullResponse.value.push(part);
      }
    }
    emits("refreshContent");
    loading.value = false;
  } catch (error) {
    console.error(error);
    ollama.abort();
    loading.value = false;
  }
};
</script>

<style scoped>
.dialog-wrapper {
  display: grid;
  gap: 20px;

  & .search {
    display: flex;
    gap: 20px;
  }

  & .loading {
    display: grid;
    place-items: center;
  }
}
</style>
