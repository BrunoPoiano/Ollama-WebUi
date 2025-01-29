<template>
  <section class="chat-box">
    <ChatLog :content="conversation" />
    <div v-if="waitingResponse">Waiting response</div>
    <div class="ui-elements">
      <textarea
        rows="10"
        id="myTextarea"
        type="text"
        placeholder="Ask something!"
        v-model="prompt"
      />

      <button v-if="generating" class="send-button" @click="abort()">
        Abort
      </button>
      <button
        v-else
        class="send-button"
        @click="chat"
        :disabled="selectedModel == ''"
      >
        Send
      </button>
    </div>
  </section>
</template>
  
<script setup>
import { onMounted, ref, provide, onBeforeUnmount } from "vue";
import ollama from "ollama";
import ChatLog from "./components/ChatLog.vue";
import eventBus from "../../EventsBus";

const emit = defineEmits(["responseStatus"]);
const generating = ref(false);
const waitingResponse = ref(false);
const selectedModel = ref(localStorage.getItem("SELECTED_MODEL"));
const prompt = ref("write a joke");
const context = ref([]);
const conversation = ref([]);

const cleatChatLog = () => {
  prompt.value = "";
  context.value = [];
  conversation.value = [];
};

const chat = async () => {
  selectedModel.value = localStorage.getItem("SELECTED_MODEL");

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
  };

  prompt.value = "";

  try {
    waitingResponse.value = true;
    const response = await ollama.generate(params);
    waitingResponse.value = false;

    generating.value = true;

    for await (const part of response) {
      const index = conversation.value.length - 1;

      conversation.value[index].message =
        conversation.value[index].message + part.response;

      if (part.context) {
        emit("responseStatus", part);
        generating.value = false;
        context.value = part.context;
      }
    }
  } catch (error) {
    console.error(error);
  }
};

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
  eventBus.$on("cleanChat", cleatChatLog);
});

onBeforeUnmount(() => {
  eventBus.$off("cleanChat", cleatChatLog);
});
</script>
   
  
<style scoped>
.chat-box {
  --chat-box-gap: 50px;
  --ui-elements-gap: 20px;

  --min-height: calc(95vh - var(--chat-box-gap) - var(--ui-elements-gap));

  min-height: var(--min-height);
  display: grid;
  grid-template-rows: 1fr auto;
  place-items: baseline;
  gap: var(--chat-box-gap);
  width: 100%;

  .ui-elements {
    width: 100%;
    display: grid;
    gap: var(--ui-elements-gap);
    place-items: center;

    textarea {
      font-size: 0.9rem;
      max-height: 250px;
    }
  }

  .models-list {
    width: 100%;
    display: flex;
    justify-content: center;
    gap: 20px;
  }
}
</style>