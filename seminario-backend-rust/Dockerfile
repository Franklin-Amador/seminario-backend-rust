FROM rust:bullseye AS builder

# Actualizar Rust a la última versión estable
RUN rustup update stable

# Creamos el directorio de trabajo
WORKDIR /app

# Copiamos todo el código fuente primero
COPY . .

# Compilamos el proyecto en modo release
RUN cargo build --release

# Verificar que el binario existe y es ejecutable
RUN ls -la /app/target/release/
RUN chmod +x /app/target/release/seminario-backend-rust

# Usamos una imagen más ligera para ejecutar
FROM debian:bullseye

# Instalamos las dependencias necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    postgresql-client \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Definimos el directorio de trabajo
WORKDIR /app

# Copiamos el binario compilado
COPY --from=builder /app/target/release/seminario-backend-rust .

# Aseguramos que el binario tenga permisos de ejecución
RUN chmod +x /app/seminario-backend-rust

# Creamos un script de inicio simple pero efectivo
RUN echo '#!/bin/bash\n\
    echo "🔍 Verificando conexión a PostgreSQL..."\n\
    nc -z db 5432 || { echo "❌ No se puede conectar a PostgreSQL"; exit 1; }\n\
    echo "✅ Conexión a PostgreSQL verificada"\n\
    echo "DATABASE_URL=$DATABASE_URL"\n\
    echo "🚀 Iniciando aplicación..."\n\
    exec /app/seminario-backend-rust\n\
    ' > /app/start.sh && chmod +x /app/start.sh

# Exponemos el puerto
EXPOSE 8080

# Comando para ejecutar la aplicación
CMD ["/app/start.sh"]