<template>
  <button data-icon class="delete" @click="openModel()">
    <i class="fa-solid fa-trash"></i>
  </button>

  <Teleport to="body">
    <dialog :id="`deleteModel${content.name}`">
      <div class="dialog-wrapper">
        <button data-modal-close @click="closeModal"><i class="fa-solid fa-x"></i></button>

        <h5>This action can not be reverted</h5>

        <div class="modal-actions">
          <button @click="closeModal">
            Cancel
          </button>
          <button class="delete" @click="deleteModel">
            Delete
          </button>
        </div>
      </div>
    </dialog>
  </Teleport>
</template>

<script setup>

const ollama_end_point = import.meta.env.VITE_OLLAMA_END_POINT
const props = defineProps(["content"]);
const emits = defineEmits(['refreshContent'])

const closeModal = () => {
  const deleteModel = document.getElementById(`deleteModel${props.content.name}`);
  deleteModel.close();
};

const openModel = () => {
  const deleteModel = document.getElementById(`deleteModel${props.content.name}`)
  deleteModel.showModal()

}
const deleteModel = async () => {
  try {
    const response = await fetch(`${ollama_end_point}/delete`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        name: props.content.model
      })
    });
    emits('refreshContent')
    closeModal()
  } catch (error) {
    console.error('Error:', error);
  }
}
</script>

<style scoped>
.delete {
  background: var(--danger-color-70);
  color: var(--neutral-color-75);
}

.dialog-wrapper {
  display: grid;
  gap: 1.3rem;
}

.modal-actions {
  width: 100%;
  display: flex;
  gap: 0.9rem;
  justify-content: end;
}
</style>