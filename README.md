# Ollama WebUi
WebUi to interact with Local LLM ollama

Setup ollama as a docker container or global
ollama.com/blog/ollama-is-now-available-as-an-official-docker-image

## Steps to Build
`git clone https://github.com/BrunoPoiano/Ollama-WebUi.git`
</br>
`cd Ollama-WebUi`
</br>
`docker compose up -d`
</br>


App expets the port to be `11434` if you changed, change the link in the .env

## On the browser 
`http://localhost:5173/`

<img src="/public/app_image.png" alt="screenshot of the app" />

<video width="320" height="240" controls>
  <source src="/public/conversation.webm" type="video/webm">
  Your browser does not support the video tag.
 </video>