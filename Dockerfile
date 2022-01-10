FROM node:16.13.1 As development

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma/

RUN yarn install --only=development

COPY . .

RUN yarn build

FROM node:16.13.1 as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

COPY package*.json ./

RUN yarn install --only=production

COPY . .

COPY --from=development /app/node_modules ./node_modules
COPY --from=development /app/package*.json ./
COPY --from=development /app/dist ./dist
# 👇 copy prisma directory
COPY --from=development /app/prisma ./prisma

EXPOSE 5000

CMD [ "yarn", "start:migrate:prod" ]