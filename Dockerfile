FROM nocobase/nocobase:latest-full

ENV APP_KEY=your-secret-key \
    DB_DIALECT=postgres \
    TZ=UTC \
    PORT=80 \
    NODE_ENV=production \
    LOG_LEVEL=warn

# Railway will inject DB_* automatically, no need to redeclare with ${}

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf || true

EXPOSE 80

CMD ["yarn", "start"]
