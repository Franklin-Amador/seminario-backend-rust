use actix_web::{delete, get, post, put, web, HttpResponse, Responder};
use log::{error, debug};
use sqlx::{PgPool, Pool, Postgres};

use crate::{error::error::handle_db_error, models::enrollments::{CreateEnrollmentsDto, Enrollment, UpdateEnrollmentsDto}};

#[get("/enrollments/course/{id}")]
pub async fn get_enrollments_by_course(
    pool: web::Data<Pool<Postgres>>, 
    path: web::Path<i32>
) -> impl Responder {
    let id = path.into_inner();
    debug!("Obteniendo enrollments para el curso con ID: {}", id);
    
    let submissions: Result<Vec<Enrollment>, sqlx::Error> = sqlx::query_as::<_, Enrollment>(
        "SELECT * FROM get_enrollments_by_course($1)"
    )
    .bind(id)
    .fetch_all(pool.get_ref())
    .await;

    match submissions {
        Ok(data) => {
            debug!("Enrollments encontradas para el curso con ID: {}", id);
            HttpResponse::Ok().json(data)
        },
        Err(err) => handle_db_error(err),
    }
}


#[get("/enrollments/user/{id}")]
pub async fn get_enrollments_by_user(
    pool: web::Data<Pool<Postgres>>, 
    path: web::Path<i32>
) -> impl Responder {
    let id = path.into_inner();
    debug!("Obteniendo enrollments para el usuario con ID: {}", id);
    
    let submissions: Result<Vec<Enrollment>, sqlx::Error> = sqlx::query_as::<_, Enrollment>(
        "SELECT * FROM get_enrollments_by_user($1)"
    )
    .bind(id)
    .fetch_all(pool.get_ref())
    .await;

    match submissions {
        Ok(data) => {
            debug!("Enrollments encontradas para el usuario con ID: {}", id);
            HttpResponse::Ok().json(data)
        },
        Err(err) => handle_db_error(err),
    }
}


#[post("/enrollments")]
pub async fn create_enrollments(
    pool: web::Data<PgPool>,
    payload: web::Json<CreateEnrollmentsDto>,
) -> impl Responder {
    debug!("Subir un enrollment para el usuario: {}", payload.userid);

    let result = sqlx::query(
        "SELECT create_enrollment($1, $2, $3, $4, $5, $6)"
    )
    .bind(payload.enrolid)
    .bind(payload.userid)
    .bind(payload.courseid)
    .bind(payload.status)
    .bind(&payload.timestart)
    .bind(&payload.timeend)
    .execute(pool.get_ref())
    .await;

    match result {
        Ok(_) => {
            HttpResponse::Created().json(serde_json::json!({
                "message": "Enrollment creado exitosamente",
                "course": payload.courseid,
                "name": payload.userid
            }))
        },
        Err(err) => {
            error!("Error al crear enrollment: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al crear al agregar el enrollment",
                "message": err.to_string()
            }))
        },
    }
}

#[delete("/enrollments/{id}")]
pub async fn delete_enrollment(
    pool: web::Data<PgPool>,
    path: web::Path<i32>,
) -> impl Responder {
    let id = path.into_inner();
    debug!("Eliminando enrollment con ID: {}", id);

    let submission_exists = sqlx::query("SELECT 1 FROM mdl_user_enrolments WHERE id = $1")
        .bind(id)
        .fetch_optional(pool.get_ref())
        .await;

    match submission_exists {
        Ok(Some(_)) => {
            let result = sqlx::query("DELETE FROM mdl_user_enrolments WHERE id = $1")
                .bind(id)
                .execute(pool.get_ref())
                .await;

            match result {
                Ok(_) => {
                    HttpResponse::Ok().json(serde_json::json!({
                        "message": "Enrollment eliminado exitosamente",
                        "id": id
                    }))
                },
                Err(err) => {
                    error!("Error al eliminar enrollment: {}", err);
                    HttpResponse::InternalServerError().json(serde_json::json!({
                        "error": "Error al eliminar el enrollment",
                        "message": err.to_string()
                    }))
                }
            }
        },
        Ok(None) => {
            HttpResponse::NotFound().json(serde_json::json!({
                "message": "Enrollment no encontrado"
            }))
        },
        Err(err) => {
            error!("Error al verificar existencia del enrollment: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al verificar existencia del enrollment",
                "message": err.to_string()
            }))
        }
    }
}


#[put("/enrollments/{id}")]
pub async fn update_enrollment(
    pool: web::Data<PgPool>,
    path: web::Path<i32>,
    payload: web::Json<UpdateEnrollmentsDto>,
) -> impl Responder {
    let id = path.into_inner();
    debug!("Actualizando seccion con ID: {}", id);

    let result: Result<Enrollment, sqlx::Error> = sqlx::query_as::<_, Enrollment>(
        "SELECT * FROM update_enrollment($1, $2, $3, $4, $5)"
    )
    .bind(id)
    // .bind(payload.enrollment_id)
    .bind(payload.enrolid)
    .bind(payload.status)
    .bind(payload.timestart)
    .bind(payload.timeend) 
    .fetch_one(pool.get_ref())
    .await;

    match result {
        Ok(section) => {
            HttpResponse::Ok().json(section)
        },
        Err(sqlx::Error::RowNotFound) => {
            HttpResponse::NotFound().json(serde_json::json!({
                "message": "Enrollment no encontrado"
            }))
        },
        Err(err) => {
            error!("Error al actualizar enrollment: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al actualizar el enrollment",
                "message": err.to_string()
            }))
        }
    }
}