# Use the official Deno image
FROM denoland/deno:2.5.6

# Set working directory
WORKDIR /app

# Copy config & lock files first
COPY deno.json deno.lock ./

# Copy the project
COPY . .

# IMPORTANT: Fix permissions so the 'deno' user can access cache directories
RUN mkdir -p /home/deno/.deno && \
    chown -R deno:deno /home/deno && \
    chown -R deno:deno /app

# Switch to the non-root Deno user
USER deno

# Cache dependencies
RUN deno cache main.ts

# Expose port
EXPOSE 8080

# Final command (single-line JSON array)
CMD ["deno", "run", "--allow-net", "--allow-read=./demo-workspace,./web,.env,/home/deno/.zypher,/home/deno/.deno", "--allow-write=./demo-workspace,/home/deno/.zypher,/home/deno/.deno", "--allow-env", "main.ts"]
