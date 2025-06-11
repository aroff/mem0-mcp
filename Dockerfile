# Build image for deploying in Cogni+ Platform
FROM python:3.11-slim

WORKDIR /app

# Install curl and other necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to the PATH
ENV PATH="/root/.cargo/bin:/root/.local/bin:${PATH}"


# Copy source files
COPY . .

RUN uv venv && \
    uv pip install -e . && \
    uv pip install fastapi
# Use non-root user
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# USER appuser
#CMD ["uv", "run", "main.py", "-t", "sse"]

CMD ["uv", "run", "main.py"]
