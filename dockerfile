# Stage 1: Build the React application
FROM node:20-alpine as build-stage

WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./
RUN npm install --silent

# Copy the rest of the application code
COPY . .

# Build the React app for production
RUN npm run build

# Stage 2: Serve the build using nginx
FROM nginx:alpine

# Copy only the build output from the previous stage
COPY --from=build-stage /app/build /usr/share/nginx/html

# Expose port 80 to the outer world
EXPOSE 80

# Start nginx server to serve the built React app
CMD ["nginx", "-g", "daemon off;"]
