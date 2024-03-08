<template>
  <section>
    <div class="messages" v-for="(chat, index) in content" :key="index">
      <h5 :data-user="chat.role == 'user'">
        {{ chat.role }}
      </h5>
      <p style="white-space: pre-wrap">{{ chat.message }}</p>
    </div>
  </section>
</template>

<script setup>
import { watch } from "vue";

const props = defineProps(["content"]);

watch(props.content, async () => {});
</script>

<style scoped>
section {
  width: 100%;
  display: grid;
  place-items: baseline;
  gap: 0.9rem;
}

.messages{
  & p {
    margin-left: 1.3rem;
  }
  & [data-user="true"]{
    margin-bottom: 1rem;
  } 
}
</style>