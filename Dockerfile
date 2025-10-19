# Use the official NocoBase image with Oracle & LibreOffice
FROM nocobase/nocobase:latest-full

# Environment variables
ENV APP_KEY=your-secret-key \
    DB_DIALECT=postgres \
    TZ=UTC \
    PORT=80 \
    NODE_ENV=production \
    LOG_LEVEL=warn

# Add Apache server name fix (harmless)
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf || true

# Make sure NocoBase core files exist even if a volume mounts
CMD ["/bin/sh", "-c", "if [ ! -f /app/nocobase/package.json ]; then cp -r /usr/src/app/* /app/nocobase/; fi && yarn start"]

EXPOSE 80
