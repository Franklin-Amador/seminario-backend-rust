use actix_web::web;
use crate::handlers::{assignment, categories, courses, home, roles, sections, submissions, users};

// para cada handler se ocupa un service por separado, no permite varios en una sola por tema de metodos http, ignoren el factory

pub fn config_routes(cfg: &mut web::ServiceConfig) {
    cfg.service(home::home) // 🔥 Nueva ruta raíz "/"
       .service(users::get_users)
       .service(users::get_user_by_id)
       .service(categories::get_categories)
       .service(courses::get_courses)
       .service(roles::get_roles)
       .service(assignment::get_assignments_prox)
       .service(assignment::get_assigments_by_curso)
       .service(assignment::get_assignment_by_id)
       .service(assignment::create_assignment)
       .service(assignment::update_assignment)
       .service(assignment::delete_assignment)
       .service(sections::get_secciones)
       .service(sections::get_course_sections)
       .service(sections::create_section)
       .service(sections::update_section)
       .service(submissions::get_submissions_by_assignment)
       .service(submissions::get_submissions_by_user)
       .service(submissions::create_submission)
       .service(submissions::delete_submission)
       .service(roles::get_rol);
}
