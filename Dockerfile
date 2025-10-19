# Use the official full image (includes clients + LibreOffice)
FROM nocobase/nocobase:latest-full

# Set environment variables — Railway will inject values dynamically
ENV APP_KEY=your-secret-key
ENV DB_DIALECT=postgres
ENV DB_HOST=${DB_HOST}
ENV DB_PORT=${DB_PORT}
ENV DB_DATABASE=${DB_DATABASE}
ENV DB_USER=${DB_USER}
ENV DB_PASSWORD=${DB_PASSWORD}
ENV TZ=UTC

# Expose Railway’s default port
EXPOSE 8080

# Start NocoBase server
CMD ["pm2-runtime", "start", "--node-args=-r dotenv/config", "packages/app/server/lib/index.js", "--", "start"]
