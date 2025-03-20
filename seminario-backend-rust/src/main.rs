use actix_web::{get, web::{self}, App, HttpResponse, HttpServer, Responder};
use sqlx::PgPool;
use serde::Serialize;
use sqlx::{Pool, Postgres};
use dotenvy::dotenv;
use std::env;

#[get("/")]
async fn index() -> impl Responder {
    "¡Servidor corriendo con Actix y PostgreSQL!"
}

#[derive(Serialize, sqlx::FromRow)]
#[sqlx(rename_all = "snake_case")]
struct User {
    id: i32,
    username: String,
}

#[derive(Serialize, sqlx::FromRow)]
#[sqlx(rename_all = "snake_case")]
struct Category {
    id: i32,
    name: String,
}

#[get("/users")]
async fn get_users(pool: web::Data<Pool<Postgres>>) -> impl Responder {
    let users = sqlx::query_as::<_, User>("SELECT id, username FROM mdl_user")
        .fetch_all(pool.get_ref())
        .await;

    match users {
        Ok(data) => HttpResponse::Ok().json(data),
        Err(err) => {
            eprintln!("❌ Error consultando usuarios: {}", err);
            HttpResponse::InternalServerError().body("Error en la base de datos")
        }
    }
}

#[get("/users/{id}")]
async fn get_user_by_id(pool: web::Data<Pool<Postgres>>, path: web::Path<i32>) -> impl Responder {
    let id = path.into_inner();
    let user = sqlx::query_as::<_, User>("SELECT id, username FROM mdl_user WHERE id = $1")
        .bind(id)
        .fetch_optional(pool.get_ref())
        .await;

    match user {
        Ok(Some(data)) => HttpResponse::Ok().json(data),
        Ok(None) => HttpResponse::NotFound().body("Usuario no encontrado"),
        Err(err) => {
            eprintln!("❌ Error consultando usuario: {}", err);
            HttpResponse::InternalServerError().body("Error en la base de datos")
        }
    }
}

#[get("/categories")]
async fn get_categories(pool: web::Data<Pool<Postgres>>) -> impl Responder {
    let categories = sqlx::query_as::<_, Category>("SELECT id, name FROM mdl_course_categories")
        .fetch_all(pool.get_ref())
        .await;

    match categories {
        Ok(data) => HttpResponse::Ok().json(data),
        Err(err) => {
            eprintln!("❌ Error consultando categorías: {}", err);
            HttpResponse::InternalServerError().body("Error en la base de datos")
        }
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // Cargar .env
    dotenv().ok();

    // Obtener la URL de la base de datos
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL no está definida en .env");

    // Crear el pool de conexiones
    let pool = PgPool::connect(&database_url)
        .await
        .expect("No se pudo conectar a PostgreSQL");

    println!("🚀 Servidor corriendo en http://127.0.0.1:8080");

    // Iniciar el servidor
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone())) // Inyectar el pool de conexiones
            .service(index)
            .service(get_users)
            .service(get_user_by_id)
            .service(get_categories)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}

