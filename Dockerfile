# Stage 1: Build the Angular app
FROM node:20.12.2 AS build
WORKDIR /app
# Copy only package.json and package-lock.json to leverage caching
COPY package*.json ./
RUN npm install
# Copy the rest of the application files
COPY . .
# Build the Angular app

RUN npm run build

FROM nginx:latest

# COPY nginx-selfsigned.crt /etc/nginx/ssl/nginx-selfsigned.crt
# COPY nginx-selfsigned.key /etc/nginx/ssl/nginx-selfsigned.key



COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist/browser /usr/share/nginx/html/aman

# COPY ./index.html /etc/nginx/html/index.html

WORKDIR /app
RUN chown -R 1001:1001 /app && chmod -R 755 /app && \
        chown -R 1001:1001 /var/cache/nginx && \
        chown -R 1001:1001 /var/log/nginx && \
        chown -R 1001:1001 /etc/nginx/conf.d
RUN touch /var/run/nginx.pid && \
        chown -R 1001:1001 /var/run/nginx.pid
USER 1001

CMD ["nginx", "-g", "daemon off;"]