# Use full version (includes LibreOffice, Oracle clients, etc.)
FROM nocobase/nocobase:latest-full

# Set up environment variables
ENV APP_KEY=your-secret-key
ENV DB_DIALECT=postgres
ENV DB_HOST=${DB_HOST}
ENV DB_PORT=${DB_PORT}
ENV DB_DATABASE=${DB_DATABASE}
ENV DB_USER=${DB_USER}
ENV DB_PASSWORD=${DB_PASSWORD}
ENV TZ=UTC
ENV PORT=80

# Clean Apache warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf || true

# Tell Railway this container listens on port 80
EXPOSE 80
