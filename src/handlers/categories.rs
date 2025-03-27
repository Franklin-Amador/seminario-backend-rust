use crate::error::error::handle_db_error;
use crate::models::category::Category;
use actix_web::{get, web, HttpResponse, Responder};
use sqlx::Pool;

// paquetes como path y error van por default no se necesitan llamar
// para los let de la query se usa la funcion sqlx::query_as

#[get("/categories")]
async fn get_categories(pool: web::Data<Pool<sqlx::Postgres>>) -> impl Responder {
    let categories = sqlx::query_as::<_, Category>("SELECT id, name FROM get_all_categories()")
        .fetch_all(pool.get_ref())
        .await;

    match categories {
        Ok(data) => HttpResponse::Ok().json(data),
        Err(err) => handle_db_error(err),
    }
}
