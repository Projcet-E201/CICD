# Builder
FROM node:18.13.9 as builder

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

# Runner
FROM nginx:stable-alpine as runner

# Copy nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy the nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]