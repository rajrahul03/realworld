# Stage 1: Build the application
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies using the legacy-peer-deps option
RUN npm install --legacy-peer-deps

# Ensure the correct TypeScript version
RUN npm install typescript@4.9.3 --save-dev

# Copy all source files
COPY . .

# Build the specific project
RUN npx nx build conduit-demo --verbose

# List the build output directory to verify its contents
RUN ls -la /app/dist/apps/conduit/demo

# Stage 2: Run the application
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy the build output from the previous stage
COPY --from=builder /app/dist/apps/conduit/demo .

# Expose the application port (default for nginx)
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
