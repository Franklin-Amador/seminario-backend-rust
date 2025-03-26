use actix_web::{get, HttpResponse, Responder};

#[get("/")]
async fn home() -> impl Responder {
    HttpResponse::Ok().body("🚀 Servidor corriendo con Actix y PostgreSQL!")
}
