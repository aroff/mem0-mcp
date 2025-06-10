# Builder stage
FROM node:lts-alpine AS builder
WORKDIR /app

# Install dependencies and build
COPY package.json pnpm-lock.yaml tsconfig.json tsup.config.ts ./
COPY src ./src
RUN npm install --ignore-scripts && npm run build

# Runtime stage
FROM node:lts-alpine
WORKDIR /app

# Copy built artifacts and production dependencies
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

# Use non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Default command
CMD ["node", "dist/index.js"]
