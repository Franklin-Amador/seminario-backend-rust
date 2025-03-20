
mod config;
mod routes;
mod handlers;
mod models;

use actix_web::{web, App, HttpServer};
use dotenvy::dotenv;
// use sqlx::PgPool;
use std::env;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL no está definida en .env");
    let pool = config::connect_db(&database_url).await.expect("❌ Error conectando a PostgreSQL");

    println!("🚀 Servidor corriendo en http://127.0.0.1:8080");

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .configure(routes::config_routes)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}

