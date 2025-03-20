use actix_web::web;
use crate::handlers::{home, users, categories};

pub fn config_routes(cfg: &mut web::ServiceConfig) {
    cfg.service(home::home) // 🔥 Nueva ruta raíz "/"
       .service(users::get_users)
       .service(users::get_user_by_id)
       .service(categories::get_categories);
}
