# Frontend Dockerfile
FROM node:20-alpine as base

# Set working directory
WORKDIR /app

# Copy package files
COPY frontend/package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY frontend/ .

# Development stage
FROM base as development
EXPOSE 5173
CMD ["npm", "run", "dev"]

# Build stage
FROM base as build
RUN npm run build

# Production stage
FROM nginx:alpine as production
COPY --from=build /app/dist /usr/share/nginx/html
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
