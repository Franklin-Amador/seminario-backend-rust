use actix_web::HttpResponse;
use log::error;

pub fn handle_db_error(err: sqlx::Error) -> HttpResponse {
    error!("Error en la base de datos: {}", err);
    HttpResponse::InternalServerError().json(serde_json::json!({
        "error": "Error en la base de datos",
        "message": err.to_string()
    }))
}
