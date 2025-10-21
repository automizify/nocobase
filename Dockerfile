# ---------- Stage 1: Builder ----------
FROM node:20-bookworm-slim as builder

ARG CNA_VERSION
WORKDIR /app

RUN cd /app \
  && yarn config set network-timeout 600000 -g \
  && npx -y create-nocobase-app@${CNA_VERSION} my-nocobase-app --skip-dev-dependencies -a -e APP_ENV=production \
  && cd /app/my-nocobase-app \
  && yarn install --production \
  && rm -rf yarn.lock \
  && find node_modules -type f -name "yarn.lock" -delete \
  && find node_modules -type f -name "bower.json" -delete \
  && find node_modules -type f -name "composer.json" -delete

RUN cd /app && tar -zcf ./nocobase.tar.gz -C /app/my-nocobase-app .

# ---------- Stage 2: Runtime ----------
FROM node:20-bookworm-slim

# Install PostgreSQL client + nginx + unzip
RUN apt-get update && apt-get install -y nginx libaio1 postgresql-client unzip && apt-get clean

WORKDIR /app/nocobase

# Copy built NocoBase bundle
COPY --from=builder /app/nocobase.tar.gz /app/nocobase.tar.gz

# Copy SQL demo file
COPY crm_demo.sql /app/crm_demo.sql

# Copy your entrypoint script
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

EXPOSE 80

CMD ["bash", "/app/docker-entrypoint.sh"]
