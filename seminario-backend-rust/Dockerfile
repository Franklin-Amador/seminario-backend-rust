FROM rust:bullseye AS builder

# Actualizar Rust a la última versión estable
RUN rustup update stable

# Creamos el directorio de trabajo
WORKDIR /app

# Copiamos todo el código fuente primero
COPY . .

# Compilamos el proyecto en modo release
RUN cargo build --release

# Usamos una imagen más ligera para ejecutar
FROM debian:bullseye

# Instalamos las dependencias necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    postgresql-client \
    netcat \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiamos el binario compilado
COPY --from=builder /app/target/release/seminario-backend-rust .

# Script de espera mejorado
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "🔍 Esperando a PostgreSQL..."\n\
until PGPASSWORD=$DB_PASSWORD psql -h "db" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1" > /dev/null 2>&1; do\n\
  echo "⏳ PostgreSQL no está disponible aún - esperando..."\n\
  sleep 1\n\
done\n\
\n\
echo "✅ PostgreSQL está listo"\n\
\n\
# Ejecutar migraciones si es necesario\n\
if [ "$APP_ENV" = "development" ]; then\n\
  echo "🧹 Modo desarrollo: verificando estado de la base de datos..."\n\
  PGPASSWORD=$DB_PASSWORD psql -h "db" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1" || exit 1\n\
fi\n\
\n\
echo "🚀 Iniciando aplicación..."\n\
exec /app/seminario-backend-rust\n\
' > /app/start.sh && chmod +x /app/start.sh

EXPOSE 8080

CMD ["/app/start.sh"]