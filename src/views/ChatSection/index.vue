<template>
  <section class="chat-box">
    <ChatLog :content="conversation" />
    <div v-if="waitingResponse">Waiting response <i class="fa-solid fa-spinner fa-spin"></i></div>
    <div class="ui-elements">

      <input type="file" accept="image/*" v-if="selectedModel.split(':')[0] == 'llava'" @change="addImage">
      <textarea rows="10" id="myTextarea" type="text" v-model="prompt" />
      <div class="buttons">
        <button v-if="generating" @click="abort()">
          Abort
        </button>
        <button v-else @click="chat" :disabled="selectedModel == ''">
          Send
        </button>

        <button class="clear" @click="clearContext">
          Clear Dialog
        </button>
      </div>
    </div>
  </section>
</template>

<script setup>
import { onMounted, ref, provide } from "vue";
import ollama from "ollama";
import ChatLog from "./components/ChatLog.vue";

const emit = defineEmits(["responseStatus"]);
const generating = ref(false);
const waitingResponse = ref(false);
const selectedModel = ref(localStorage.getItem('SELECTED_MODEL'));
const prompt = ref("write a joke");
const context = ref([]);
const image = ref();
const conversation = ref([]);

const addImage = (event) => {
  const file = event.target.files[0];
  const reader = new FileReader();

  reader.onloadend = () => {
    image.value = reader.result.split(',')[1]
  }

  reader.readAsDataURL(file);
  clearContext()
}


const chat = async () => {

  const form = [
    {
      role: "You",
      message: prompt.value,
    },
    {
      role: `Ollama (${selectedModel.value})`,
      message: "",
    },
  ];

  conversation.value.push(...form);

  const params = {
    model: selectedModel.value,
    prompt: prompt.value,
    stream: true,
    context: context.value,
    images: [image.value]
  };

  prompt.value = "";

  try {
    generating.value = true;
    waitingResponse.value = true;
    const response = await ollama.generate(params);
    waitingResponse.value = false;

    for await (const part of response) {
      const index = conversation.value.length - 1;

      conversation.value[index].message =
        conversation.value[index].message + part.response;

      if (part.context) {
        emit('responseStatus', part)
        generating.value = false;
        context.value = part.context;
      }
    }
  } catch (error) {
    console.error(error);
  }
};

const clearContext = () => {
  context.value = []
  conversation.value = []
}

const abort = () => {
  ollama.abort();
  generating.value = false;
};

onMounted(() => {
  const textarea = document.getElementById("myTextarea");

  textarea.addEventListener("input", function () {
    this.style.height = "auto";
    this.style.height = this.scrollHeight + "px";
  });

  window.addEventListener('SELECTED_MODEL_CHANGE', () => {
    selectedModel.value = localStorage.getItem('SELECTED_MODEL')
    clearContext()
  });

});

</script>


<style scoped>
.chat-box {
  --chat-box-gap: 2.5em;
  --ui-elements-gap: 1.5em;

  --min-height: calc(95vh - var(--chat-box-gap) - var(--ui-elements-gap));

  min-height: var(--min-height);
  display: grid;
  grid-template-rows: 1fr auto;
  place-items: baseline;
  gap: var(--chat-box-gap);
  width: 100%;

  & .ui-elements {
    width: 100%;
    display: grid;
    gap: var(--ui-elements-gap);
    place-items: center;

    & .buttons {
      width: 100%;
      display: flex;
      justify-content: center;
      gap: 1.3rem;
      position: relative;

      .clear {
        position: absolute;
        right: 0;
      }
    }
  }
}
</style>