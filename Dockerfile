FROM node:20

WORKDIR /usr/src/app
COPY . .

RUN apt-get update && apt-get install \
  && npm install && npm run build

EXPOSE 5173

CMD ["npx", "serve", "dist", "-l", "5173"]
