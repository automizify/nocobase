# Use full NocoBase image (includes Oracle client & LibreOffice)
FROM nocobase/nocobase:latest-full

# Core environment variables
ENV APP_KEY=your-secret-key \
    DB_DIALECT=postgres \
    TZ=UTC \
    PORT=80 \
    NODE_ENV=production \
    LOG_LEVEL=warn

# Fix Apache warnings (optional)
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf || true

# If the /app/nocobase folder is empty (e.g. after volume mount), copy from default installed path
CMD ["/bin/sh", "-c", "if [ ! -f /app/nocobase/package.json ]; then cp -r /app/. /app/nocobase/; fi && yarn start"]

EXPOSE 80
