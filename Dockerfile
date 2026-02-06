FROM node:20-alpine

WORKDIR /app

# Install git (required by index.js)
RUN apk add --no-cache git curl

# Copy package files
COPY package*.json ./
COPY pnpm-lock.yaml bun.lockb* ./

# Install dependencies
RUN npm install --production

# Copy application files
COPY . .

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Start the application
CMD ["npm", "start"]
