use actix_web::{get, web, HttpResponse, Responder};
use sqlx::Pool;
use crate::models::category::Category;

#[get("/categories")]
async fn get_categories(pool: web::Data<Pool<sqlx::Postgres>>) -> impl Responder {
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
