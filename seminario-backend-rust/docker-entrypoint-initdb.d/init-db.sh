#!/bin/bash
set -e

echo "🚀 Iniciando configuración automatizada de la base de datos..."

# Leer el contenido de los archivos SQL
MIGRATION_SQL="$(cat /scripts-source/migration.sql)"
STORED_PROCEDURES_SQL="$(cat /scripts-source/stored_procedures.sql)"
FIX_PROCEDURES_SQL="$(cat /scripts-source/fix_stored_procedures.sql)"
INDEXES_SQL="$(cat /scripts-source/indexes.sql)"
INIT_DATA_SQL="$(cat /scripts-source/init.sql)"

# Ejecutar scripts SQL en orden usando psql
echo "1️⃣ Creando tablas (migration.sql)..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<EOSQL
$MIGRATION_SQL
EOSQL

echo "2️⃣ Creando procedimientos almacenados (stored_procedures.sql)..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<EOSQL
$STORED_PROCEDURES_SQL
EOSQL

echo "3️⃣ Aplicando correcciones a procedimientos (fix_stored_procedures.sql)..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<EOSQL
$FIX_PROCEDURES_SQL
EOSQL

echo "4️⃣ Creando índices (indexes.sql)..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<EOSQL
$INDEXES_SQL
EOSQL

echo "5️⃣ Cargando datos iniciales (init.sql)..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<EOSQL
$INIT_DATA_SQL
EOSQL

# Verificación final
echo "🔍 Verificando que los procedimientos se crearon correctamente..."
USERS_PROC_COUNT=$(psql -t --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "SELECT COUNT(*) FROM pg_proc WHERE proname = 'get_all_users';")
if [ "$USERS_PROC_COUNT" -ge 1 ]; then
    echo "✅ Procedimiento get_all_users() encontrado."
else
    echo "❌ ERROR: Procedimiento get_all_users() no encontrado."
    exit 1
fi

echo "✅ ¡Base de datos inicializada correctamente!"