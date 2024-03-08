<template>
  <div class="new-model">
    <PullModel  @refreshContent="refresh++" />
    <CreateModel @refreshContent="refresh++" />
  </div>
  <ModelsTable :key="refresh" />
</template>

<script>
import CreateModel from './components/CreateModel.vue';
import ModelsTable from './components/ModelsTable/index.vue';
import PullModel from './components/PullModel/index.vue';

export default {
  data() {
    return {
      refresh: 0
    }
  },
  components: { CreateModel, ModelsTable,PullModel }
}
</script>

<style scoped>
.new-model {
  width: 100%;
  display: flex;
  justify-content: flex-end;
  gap: 1.3rem;
}
</style>