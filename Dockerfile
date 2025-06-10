# Build image for deploying in Cogni+ Platform
FROM python:3.11-slim

WORKDIR /app

# Copy source files
COPY . .

RUN uv venv
RUN source .venv/bin/activate
RUN uv pip install -e .

# Use non-root user
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# USER appuser

CMD ["uv", "run", "main.py", "-t", "sse"]
