FROM node:16-alpine AS builder
ENV NODE_ENV production
WORKDIR /app
COPY package.json .
RUN yarn install --production
COPY . .
RUN yarn run build

FROM nginx:1.24.0-alpine as production
ENV NODE_ENV production
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8899
CMD ["nginx", "-g", "daemon off;"]