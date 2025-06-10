# Build image for deploying in Cogni+ Platform
FROM python:3.11-slim

WORKDIR /app

# Install uv and add it to PATH
RUN curl -sSf https://astral.sh/uv/install.sh | sh && \
    echo 'export PATH="/root/.cargo/bin:$PATH"' >> ~/.bashrc && \
    . ~/.bashrc
    
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
