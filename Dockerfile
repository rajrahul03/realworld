# Stage 1: Build the application
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies using the legacy-peer-deps option
RUN npm install --legacy-peer-deps

# Copy all source files
COPY . .

# Build the application
RUN npm run build --verbose
RUN ls -la /app/dist/apps/demo
# Stage 2: Run the application
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy the build output from the previous stage
COPY --from=builder /app/dist/apps/demo /app

# Rename hashed files to their normal names


# Copy package.json and package-lock.json
COPY package*.json ./
RUN ls -la /app
# Install only production dependencies using the legacy-peer-deps option
RUN npm install --force --legacy-peer-deps --production --verbose

# Expose the application port (adjust this based on your application)
EXPOSE 3000

# Start the application
CMD ["node", "main.js"]
