# Build image for deploying in Cogni+ Platform
FROM python:3.11-slim

WORKDIR /app

# Install curl for downloading uv
RUN apt-get update && apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -sSf https://astral.sh/uv/install.sh | sh

# Add uv to the PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Copy source files
COPY . .

RUN uv venv
RUN source .venv/bin/activate
RUN uv pip install -e .

# Use non-root user
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# USER appuser

CMD ["uv", "run", "main.py", "-t", "sse"]
