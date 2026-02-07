# Use official Node.js runtime as base image
FROM node:18-alpine
# Create and set working directory
WORKDIR /app
# Copy package files
COPY package*.json ./
# Install dependencies
RUN npm install --production
# Copy application files
COPY . .
# Create necessary directories
RUN mkdir -p public/css public/js views/partials
# Expose port
EXPOSE 3000
# Start the application
CMD ["npm", "start"]
