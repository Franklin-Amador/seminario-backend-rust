mod config;
mod handlers;
mod models;
mod routes;

use actix_web::{web, App, HttpServer};
use dotenvy::dotenv;
use std::env;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("🚀 Iniciando aplicación Seminario Backend Rust...");

    // Cargar variables de entorno
    dotenv().ok();
    println!("📋 Variables de entorno cargadas");

    // Obtener la URL de la base de datos
    let database_url = match env::var("DATABASE_URL") {
        Ok(url) => {
            println!("✅ DATABASE_URL encontrada: {}", url);
            url
        }
        Err(e) => {
            eprintln!("❌ ERROR: DATABASE_URL no está definida. Error: {}", e);
            return Err(std::io::Error::new(
                std::io::ErrorKind::Other,
                "DATABASE_URL no definida",
            ));
        }
    };

    // Conectar a la base de datos
    println!("🔄 Conectando a PostgreSQL...");
    let pool = match config::connect_db(&database_url).await {
        Ok(pool) => {
            println!("✅ Conexión a PostgreSQL establecida");
            pool
        }
        Err(e) => {
            eprintln!("❌ ERROR conectando a PostgreSQL: {}", e);
            return Err(std::io::Error::new(
                std::io::ErrorKind::Other,
                format!("Error de conexión a la base de datos: {}", e),
            ));
        }
    };

    // Verificar la conexión
    println!("🔄 Probando la conexión a la base de datos...");
    match sqlx::query("SELECT 1").execute(&pool).await {
        Ok(_) => println!("✅ Test de conexión exitoso"),
        Err(e) => {
            eprintln!("❌ Test de conexión fallido: {}", e);
            return Err(std::io::Error::new(
                std::io::ErrorKind::Other,
                format!("Error en test de conexión: {}", e),
            ));
        }
    }

    // Iniciar el servidor HTTP - NOTA: Es crítico usar 0.0.0.0 en lugar de 127.0.0.1
    println!("🚀 Iniciando servidor HTTP en 0.0.0.0:8080");

    HttpServer::new(move || {
        println!("🔄 Configurando rutas de la aplicación");
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .configure(routes::config_routes)
    })
    .bind("0.0.0.0:8080")? // ¡IMPORTANTE! Usar 0.0.0.0 para aceptar conexiones externas
    .run()
    .await
}
