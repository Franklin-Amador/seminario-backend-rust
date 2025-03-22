use actix_web::{get, web, HttpResponse, Responder};
use sqlx::Pool;
use crate::models::rol::Rol;
use crate::error::error::handle_db_error;

// paquetes como path y error van por default no se necesitan llamar
// para los let de la query se usa la funcion sqlx::query_as

#[get("/roles")]
async fn get_roles(pool: web::Data<Pool<sqlx::Postgres>>) -> impl Responder {
    let roles = sqlx::query_as::<_, Rol>("SELECT id, name, description FROM get_all_roles()")
        .fetch_all(pool.get_ref())
        .await;

    match roles {
        Ok(data) => HttpResponse::Ok().json(data),
        Err(err) => handle_db_error(err),
    }
}

#[get("/roles/{id}")]
async fn get_rol(pool: web::Data<Pool<sqlx::Postgres>>, path: web::Path<i32>) -> impl Responder {
    let id: i32 = path.into_inner();
    let rol = sqlx::query_as::<_, Rol>("SELECT id, name, description FROM get_role_by_id($1)")
        .bind(id) 
        .fetch_optional(pool.get_ref()) 
        .await;

    match rol {
        Ok(Some(data)) => HttpResponse::Ok().json(data),  
        Ok(None) => HttpResponse::NotFound().body("Rol no encontrado"),  
        Err(err) => handle_db_error(err),
    }
}
