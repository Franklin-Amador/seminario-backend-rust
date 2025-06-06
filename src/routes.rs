use crate::handlers::{
    assignment, categories, courses, enrollments, home, roles, sections, submissions, users,
};
use actix_web::web;

// para cada handler se ocupa un service por separado, no permite varios en una sola por tema de metodos http, ignoren el factory

pub fn config_routes(cfg: &mut web::ServiceConfig) {
    cfg.service(home::home) // 🔥 Nueva ruta raíz "/"
        .service(users::get_users)
        .service(users::get_user_by_id)
        .service(categories::get_categories)
        .service(courses::get_courses)
        .service(courses::create_course)
        .service(courses::get_curso_by_id)
        .service(courses::update_course)
        .service(roles::get_roles)
        .service(roles::create_rol)
        .service(roles::delete_rol)
        .service(assignment::get_assignments_prox)
        .service(assignment::get_assigments_by_curso)
        .service(assignment::get_assignment_by_id)
        .service(assignment::get_all_assignments)
        .service(assignment::get_assigments_by_seccion)
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
        .service(enrollments::get_enrollments_by_course)
        .service(enrollments::get_enrollments_by_user)
        .service(enrollments::create_enrollments)
        .service(enrollments::delete_enrollment)
        .service(enrollments::update_enrollment)
        .service(roles::get_rol);
}
