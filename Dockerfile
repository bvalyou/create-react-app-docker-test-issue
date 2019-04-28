# build: docker build -t bvalyou/digital-table-ui:latest .
# deploy: docker run --name digital-table-ui -d -p 8000:80 bvalyou/digital-table-ui:latest

#
# ---- Base Node ----
FROM node:lts-alpine AS base

WORKDIR /app

COPY package*.json ./

#
# ---- Dependencies ----
FROM base AS dependencies

RUN npm ci

#
# ---- Test ----
FROM dependencies AS test

COPY . .

RUN npm test

#
# ---- Build ----
FROM test AS build

RUN npm run build

#
# ---- Finalize ----
FROM nginx:stable

COPY --from=build /app/build /var/www/public
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
