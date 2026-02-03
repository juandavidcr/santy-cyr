#!/bin/bash
# Script para poblar la base de datos MySQL en producción (Dokploy)
# Uso: ./populate-db.sh <mysql-container-name>

MYSQL_CONTAINER=${1:-"mysql-ciencia-religion-db"}
DB_NAME="ciencia_religion_db"
DB_USER="user_admin"
DB_PASS="secret"

echo "📦 Poblando base de datos MySQL en producción..."

# Copiar archivos SQL al contenedor MySQL
echo "1️⃣ Copiando init.sql al contenedor..."
docker cp init.sql $MYSQL_CONTAINER:/tmp/init.sql

echo "2️⃣ Copiando init_data.sql al contenedor..."
docker cp init_data.sql $MYSQL_CONTAINER:/tmp/init_data.sql

# Ejecutar los scripts
echo "3️⃣ Ejecutando init.sql (esquema)..."
docker exec -i $MYSQL_CONTAINER mysql -u$DB_USER -p$DB_PASS $DB_NAME < init.sql

echo "4️⃣ Ejecutando init_data.sql (datos)..."
docker exec -i $MYSQL_CONTAINER mysql -u$DB_USER -p$DB_PASS $DB_NAME < init_data.sql

echo "✅ Base de datos poblada correctamente"
echo "📊 Verificando datos..."
docker exec $MYSQL_CONTAINER mysql -u$DB_USER -p$DB_PASS $DB_NAME -e "SELECT COUNT(*) as total_chapters FROM chapters; SELECT COUNT(*) as total_paragraphs FROM paragraphs;"
