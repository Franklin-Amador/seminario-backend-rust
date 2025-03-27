use actix_web::{delete, get, post, web, HttpResponse, Responder};
use log::{debug, error};
use sqlx::{PgPool, Pool, Postgres};

use crate::{
    error::error::handle_db_error,
    models::submissions::{AssignmentSubmission, CreateSubmissionDto},
};

#[get("/submission/asignaciones/{id}")]
pub async fn get_submissions_by_assignment(
    pool: web::Data<Pool<Postgres>>,
    path: web::Path<i32>,
) -> impl Responder {
    let id = path.into_inner();
    debug!("Obteniendo submissions para la asignación con ID: {}", id);

    let submissions: Result<Vec<AssignmentSubmission>, sqlx::Error> =
        sqlx::query_as::<_, AssignmentSubmission>(
            "SELECT * FROM get_submissions_by_assignment($1)",
        )
        .bind(id)
        .fetch_all(pool.get_ref())
        .await;

    match submissions {
        Ok(data) => {
            debug!("Submissions encontradas para la asignación con ID: {}", id);
            HttpResponse::Ok().json(data)
        }
        Err(err) => handle_db_error(err),
    }
}

#[get("/submission/user/{id}")]
pub async fn get_submissions_by_user(
    pool: web::Data<Pool<Postgres>>,
    path: web::Path<i32>,
) -> impl Responder {
    let id = path.into_inner();
    debug!("Obteniendo submissions para el usuario con ID: {}", id);

    let submissions: Result<Vec<AssignmentSubmission>, sqlx::Error> =
        sqlx::query_as::<_, AssignmentSubmission>("SELECT * FROM get_submissions_by_user($1)")
            .bind(id)
            .fetch_all(pool.get_ref())
            .await;

    match submissions {
        Ok(data) => {
            debug!("Submissions encontradas para el usuario con ID: {}", id);
            HttpResponse::Ok().json(data)
        }
        Err(err) => handle_db_error(err),
    }
}

#[post("/submission/assignments")]
pub async fn create_submission(
    pool: web::Data<PgPool>,
    payload: web::Json<CreateSubmissionDto>,
) -> impl Responder {
    debug!("Subir una asignacion: {}", payload.assignment);

    let result = sqlx::query("SELECT create_submission($1, $2, $3, $4, $5, $6, $7, $8)")
        .bind(payload.assignment)
        .bind(payload.userid)
        .bind(&payload.timecreated)
        .bind(payload.timemodified)
        .bind(&payload.status)
        .bind(&payload.groupid)
        .bind(payload.attemptnumber)
        .bind(payload.latest)
        .execute(pool.get_ref())
        .await;

    match result {
        Ok(_) => HttpResponse::Created().json(serde_json::json!({
            "message": "Asignación subida exitosamente",
            "course": payload.assignment,
            "name": payload.userid
        })),
        Err(err) => {
            error!("Error al subir asignacion: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al crear al agregar asignacion",
                "message": err.to_string()
            }))
        }
    }
}

#[delete("/submission/{id}")]
pub async fn delete_submission(pool: web::Data<PgPool>, path: web::Path<i32>) -> impl Responder {
    let id = path.into_inner();
    debug!("Eliminando submission con ID: {}", id);

    let submission_exists = sqlx::query("SELECT 1 FROM mdl_assign_submission WHERE id = $1")
        .bind(id)
        .fetch_optional(pool.get_ref())
        .await;

    match submission_exists {
        Ok(Some(_)) => {
            let result = sqlx::query("DELETE FROM mdl_assign_submission WHERE id = $1")
                .bind(id)
                .execute(pool.get_ref())
                .await;

            match result {
                Ok(_) => HttpResponse::Ok().json(serde_json::json!({
                    "message": "Asignación eliminada exitosamente",
                    "id": id
                })),
                Err(err) => {
                    error!("Error al eliminar asignación: {}", err);
                    HttpResponse::InternalServerError().json(serde_json::json!({
                        "error": "Error al eliminar la asignación",
                        "message": err.to_string()
                    }))
                }
            }
        }
        Ok(None) => HttpResponse::NotFound().json(serde_json::json!({
            "message": "Asignación no encontrada"
        })),
        Err(err) => {
            error!("Error al verificar existencia de asignación: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al verificar existencia de asignación",
                "message": err.to_string()
            }))
        }
    }
}
