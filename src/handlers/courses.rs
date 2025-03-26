use actix_web::{get, web, HttpResponse, Responder};
use sqlx::PgPool;
use crate::models::course::Course;
use crate::error::error::handle_db_error;

// paquetes como path y error van por default no se necesitan llamar
// para los let de la query se usa la funcion sqlx::query_as

#[get("/courses")]
async fn get_courses(pool: web::Data<PgPool>) -> impl Responder {
    let courses = sqlx::query_as::<_, Course>("SELECT * FROM get_all_courses()")
        .fetch_all(pool.get_ref())
        .await;

    match courses {
        Ok(data) => HttpResponse::Ok().json(data), // Retorna los cursos en formato JSON
        Err(err) => handle_db_error(err),
    }
}
