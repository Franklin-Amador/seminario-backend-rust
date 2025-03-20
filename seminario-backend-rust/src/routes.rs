use actix_web::web;
use crate::handlers::{home, users, categories, courses, roles};

// para cada handler se ocupa un service por separado, no permite varios en una sola por tema de metodos http, ignoren el factory

pub fn config_routes(cfg: &mut web::ServiceConfig) {
    cfg.service(home::home) // 🔥 Nueva ruta raíz "/"
       .service(users::get_users)
       .service(users::get_user_by_id)
       .service(categories::get_categories)
       .service(courses::get_courses)
       .service(roles::get_roles)
       .service(roles::get_rol);
}
