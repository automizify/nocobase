set -e

echo "COMMIT_HASH: $(cat /app/commit_hash.txt)"

export NOCOBASE_RUNNING_IN_DOCKER=true

if [ -f /opt/libreoffice24.8.zip ] && [ ! -d /opt/libreoffice24.8 ]; then
  echo "Unzipping /opt/libreoffice24.8.zip..."
  unzip /opt/libreoffice24.8.zip -d /opt/
fi

if [ -f /opt/instantclient_19_25.zip ] && [ ! -d /opt/instantclient_19_25 ]; then
  echo "Unzipping /opt/instantclient_19_25.zip..."
  unzip /opt/instantclient_19_25.zip -d /opt/
  echo "/opt/instantclient_19_25" > /etc/ld.so.conf.d/oracle-instantclient.conf
  ldconfig
fi

if [ ! -d "/app/nocobase" ]; then
  mkdir nocobase
fi

# ======================================================
# 🗄️ DEMO DATABASE IMPORT SECTION (added)
# ======================================================
echo "Checking database connectivity..."

DB_CONN=""
if [ -n "$DATABASE_URL" ]; then
  DB_CONN="$DATABASE_URL"
else
  DB_CONN="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_DATABASE"
fi

if [ -n "$DB_CONN" ]; then
  echo "Connecting to database using: $DB_CONN"
  for i in {1..10}; do
    if psql "$DB_CONN" -c '\q' 2>/dev/null; then
      echo "✅ Database is reachable."
      break
    fi
    echo "Attempt $i/10: Database not ready yet, retrying in 5s..."
    sleep 5
  done

  echo "🗄️ Attempting to import demo data from crm_demo.sql..."
  psql "$DB_CONN" -f /app/crm_demo.sql || echo "⚠️ Import failed or data already exists, continuing..."
else
  echo "❌ No valid DB connection details found. Skipping import."
fi
# ======================================================

if [ ! -f "/app/nocobase/package.json" ]; then
  echo 'copying...'
  tar -zxf /app/nocobase.tar.gz --absolute-names -C /app/nocobase
  touch /app/nocobase/node_modules/@nocobase/app/dist/client/index.html
fi

cd /app/nocobase && yarn nocobase create-nginx-conf
cd /app/nocobase && yarn nocobase generate-instance-id
rm -rf /etc/nginx/sites-enabled/nocobase.conf
ln -s /app/nocobase/storage/nocobase.conf /etc/nginx/sites-enabled/nocobase.conf

nginx
echo 'nginx started';

# run scripts in storage/scripts
if [ -d "/app/nocobase/storage/scripts" ]; then
  for f in /app/nocobase/storage/scripts/*.sh; do
    echo "Running $f"
    sh "$f"
  done
fi

cd /app/nocobase && yarn start --quickstart

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- node "$@"
fi

exec "$@"
