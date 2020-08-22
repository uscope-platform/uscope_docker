FROM node:14.5

WORKDIR /client

COPY src ./src
COPY public ./public
COPY package.json .

RUN yarn install
CMD ["yarn", "run", "start" ]