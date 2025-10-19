FROM nocobase/nocobase:latest-full

ENV APP_KEY=your-secret-key \
    DB_DIALECT=postgres \
    TZ=UTC \
    PORT=80 \
    NODE_ENV=production \
    LOG_LEVEL=warn

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf || true

CMD ["yarn", "start"]

EXPOSE 80
