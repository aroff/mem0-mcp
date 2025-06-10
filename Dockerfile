# Builder stage
FROM node:lts-alpine AS builder
WORKDIR /app

# Copy the entire node/mem0 directory to maintain project structure
COPY node/mem0 ./

# Debug - check file structure
RUN ls -la

# Install dependencies 
RUN npm install

# Show package.json scripts to understand the build process
RUN cat package.json | grep -A 10 scripts

# Build with more verbose output
RUN npm run build

# Debug - check output location
RUN find /app -name "*.js" | sort

# Runtime stage
FROM node:lts-alpine
WORKDIR /app

# Copy everything from builder stage for now
COPY --from=builder /app ./

# Debug in runtime image
RUN ls -la dist || echo "dist directory not found" && \
    find /app -name "*.js" | grep -v "node_modules" | sort

# Use non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Start with explicit node command for better error messages
CMD ["sh", "-c", "ls -la && find /app -name \"*.js\" | grep -v \"node_modules\" && node dist/index.js"]
