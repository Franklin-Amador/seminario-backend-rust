mod config;
mod error;
mod handlers;
mod models;
mod routes;

use actix_web::{web, App, HttpServer};
use actix_web_prom::PrometheusMetricsBuilder;
use dotenvy::dotenv;
use sqlx::{Executor, PgPool};
use std::env;
use std::fs;
use std::path::Path;
use tracing::info;

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

    //ejecutar los scripts
    info!("🔄 Ejecutando scripts SQL iniciales...");
    execute_sql_scripts(&pool).await.map_err(|e| {
        tracing::error!("❌ Error ejecutando scripts SQL: {}", e);
        std::io::Error::new(
            std::io::ErrorKind::Other,
            format!("Error ejecutando scripts SQL: {}", e),
        )
    })?;
    info!("✅ Scripts SQL ejecutados correctamente");

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
    .bind("0.0.0.0:8080")? // esto cambienlo manual, para el despliegue es necesario :v
    .run()
    .await
}

async fn execute_sql_scripts(pool: &PgPool) -> Result<(), sqlx::Error> {
    let scripts = [
        "docker-entrypoint-initdb.d/01-migration.sql",
        "docker-entrypoint-initdb.d/02-stored_procedures.sql",
        "docker-entrypoint-initdb.d/03-fix_stored_procedures.sql",
        "docker-entrypoint-initdb.d/04-indexes.sql",
        "docker-entrypoint-initdb.d/05-init.sql",
    ];

    let is_dev = env::var("APP_ENV").unwrap_or_default() == "development";

    if is_dev {
        info!("🧹 Modo desarrollo: limpiando base de datos...");
        clean_database(pool).await?;
    } else {
        let db_initialized: bool = sqlx::query_scalar(
            "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' LIMIT 1)"
        )
        .fetch_one(pool)
        .await?;

        if db_initialized {
            info!("✅ La base de datos ya está inicializada, omitiendo scripts");
            return Ok(());
        }
    }

    for script_path in scripts.iter() {
        info!("📜 Ejecutando script: {}", script_path);

        if !Path::new(script_path).exists() {
            tracing::warn!("⚠️ Script no encontrado: {}", script_path);
            continue;
        }

        let content = fs::read_to_string(script_path)?;

        let mut transaction = pool.begin().await?;

        if let Err(e) = transaction.execute(content.as_str()).await {
            // Ignorar errores de "ya existe" en modo desarrollo
            if is_dev && e.to_string().contains("already exists") {
                info!("⚠️ Ignorando error (modo desarrollo): {}", e);
                continue;
            }
            return Err(e);
        }

        transaction.commit().await?;
    }

    Ok(())
}

async fn clean_database(pool: &PgPool) -> Result<(), sqlx::Error> {
    sqlx::query("SET session_replication_role = 'replica'")
        .execute(pool)
        .await?;

    let tables: Vec<String> =
        sqlx::query_scalar("SELECT tablename FROM pg_tables WHERE schemaname = 'public'")
            .fetch_all(pool)
            .await?;

    for table in tables {
        let query = format!("DROP TABLE IF EXISTS {} CASCADE", table);
        sqlx::query(&query).execute(pool).await?;
    }

    let functions: Vec<String> = sqlx::query_scalar(
        "SELECT routine_name FROM information_schema.routines 
         WHERE routine_schema = 'public' AND routine_type = 'FUNCTION'",
    )
    .fetch_all(pool)
    .await?;

    for function in functions {
        let query = format!("DROP FUNCTION IF EXISTS {} CASCADE", function);
        sqlx::query(&query).execute(pool).await?;
    }

    sqlx::query("SET session_replication_role = 'origin'")
        .execute(pool)
        .await?;

    Ok(())
}
