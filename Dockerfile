FROM node:20

WORKDIR /usr/src/app
COPY . .

RUN apt-get update \
  && apt-get install \
  && apt-get install git \
  && npm install

EXPOSE 5173

CMD ["npm", "run", "dev"]
