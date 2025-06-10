FROM node:lts-alpine AS builder
WORKDIR /app

# Copy from the nested directory structure
COPY node/mem0/package.json node/mem0/pnpm-lock.yaml node/mem0/tsconfig.json node/mem0/tsup.config.ts ./
COPY node/mem0/src ./src
#RUN npm install --ignore-scripts && npm run build

RUN npm install --ignore-scripts
RUN npx tsup src/index.ts --format cjs --clean --no-dts


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
