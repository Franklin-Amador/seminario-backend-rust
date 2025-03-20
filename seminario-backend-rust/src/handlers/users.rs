use actix_web::{get, web, HttpResponse, Responder};
use sqlx::Pool;
use crate::models::user::User;

// paquetes como path y error van por default no se necesitan llamar
// para los let de la query se usa la funcion sqlx::query_as

#[get("/users")]
async fn get_users(pool: web::Data<Pool<sqlx::Postgres>>) -> impl Responder {
    let users = sqlx::query_as::<_, User>("SELECT id, username FROM get_all_users()")
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
async fn get_user_by_id(pool: web::Data<Pool<sqlx::Postgres>>, path: web::Path<i32>) -> impl Responder {
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
