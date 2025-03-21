# Usamos Rust como imagen base
FROM rust:latest AS builder

# Actualizar Rust a la última versión estable
# RUN rustup update stable

# Actualizar Rust y Cargo dentro del contenedor
RUN rustup update stable

# Creamos el directorio de trabajo
WORKDIR /app

# Copiamos el archivo Cargo.toml y Cargo.lock primero para aprovechar caché de Docker
COPY Cargo.toml Cargo.lock ./

# Creamos un workspace temporal para descargar dependencias sin compilar el código aún
RUN mkdir src && echo "fn main() {}" > src/main.rs && cargo build --release

# Ahora copiamos el código fuente
COPY . .

# Compilamos el proyecto en modo release
RUN cargo build --release

# Usamos una imagen más ligera para ejecutar la app (distroless)
FROM debian:bullseye

# Definimos el directorio de trabajo
WORKDIR /app

# Copiamos el binario compilado desde la imagen anterior
COPY --from=builder /app/target/release/seminario-backend-rust .

# Exponemos el puerto que usa Actix-Web
EXPOSE 8080

# Comando para ejecutar la app
CMD ["./seminario-backend-rust"]

