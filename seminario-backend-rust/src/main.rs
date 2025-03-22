mod config;
mod handlers;
mod models;
mod routes;
mod error;

use actix_web::{web, App, HttpServer};
use dotenvy::dotenv;
use std::env;
use actix_web_prom::PrometheusMetricsBuilder;
use tracing::info;
use tracing_subscriber;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("🚀 Iniciando aplicación Seminario Backend Rust...");

    // Inicializar tracing para logs estructurados
    tracing_subscriber::fmt().init();
    info!("📋 Tracing y logs inicializados");

    // Cargar variables de entorno
    dotenv().ok();
    info!("📋 Variables de entorno cargadas");

    // Obtener la URL de la base de datos
    let database_url = match env::var("DATABASE_URL") {
        Ok(url) => {
            info!("✅ DATABASE_URL encontrada: {}", url);
            url
        }
        Err(e) => {
            tracing::error!("❌ ERROR: DATABASE_URL no está definida. Error: {}", e);
            return Err(std::io::Error::new(
                std::io::ErrorKind::Other,
                "DATABASE_URL no definida",
            ));
        }
    };

    // Conectar a la base de datos
    info!("🔄 Conectando a PostgreSQL...");
    let pool = match config::connect_db(&database_url).await {
        Ok(pool) => {
            info!("✅ Conexión a PostgreSQL establecida");
            pool
        }
        Err(e) => {
            tracing::error!("❌ ERROR conectando a PostgreSQL: {}", e);
            return Err(std::io::Error::new(
                std::io::ErrorKind::Other,
                format!("Error de conexión a la base de datos: {}", e),
            ));
        }
    };

    // Verificar la conexión
    info!("🔄 Probando la conexión a la base de datos...");
    match sqlx::query("SELECT 1").execute(&pool).await {
        Ok(_) => info!("✅ Test de conexión exitoso"),
        Err(e) => {
            tracing::error!("❌ Test de conexión fallido: {}", e);
            return Err(std::io::Error::new(
                std::io::ErrorKind::Other,
                format!("Error en test de conexión: {}", e),
            ));
        }
    };

    // Inicializar middleware de métricas Prometheus
    let prometheus = PrometheusMetricsBuilder::new("api")
        .endpoint("/metrics") // Ruta donde se exponen las métricas
        .build()
        .unwrap();

    // Iniciar el servidor HTTP
    info!("🚀 Iniciando servidor HTTP en 127.0.0.1:8080");

    HttpServer::new(move || {
        info!("🔄 Configurando rutas de la aplicación");
        App::new()
            .wrap(prometheus.clone()) // Middleware de métricas
            .app_data(web::Data::new(pool.clone()))
            .configure(routes::config_routes)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}
