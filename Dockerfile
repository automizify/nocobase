FROM nocobase/nocobase:latest-full

# Set environment variables
ENV APP_KEY=your-secret-key
ENV DB_DIALECT=postgres
ENV DB_HOST=${DB_HOST}
ENV DB_PORT=${DB_PORT}
ENV DB_DATABASE=${DB_DATABASE}
ENV DB_USER=${DB_USER}
ENV DB_PASSWORD=${DB_PASSWORD}
ENV TZ=UTC

# (optional but recommended)
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf || true

# Railway requires you to expose a port
EXPOSE 8080

# ✅ Do NOT add your own CMD — use the one from base image
