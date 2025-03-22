use actix_web::{post, get,put, delete, web, HttpResponse, Responder};
use sqlx::{Pool, Postgres};
use crate::models::assignment::{Assignment, AssignmentsProx, CreateAssignmentDto, UpdateAssignmentDto};
use log::{error, debug};
use sqlx::PgPool;
use crate::error::error::handle_db_error;

#[get("/assignmentsProx")]
async fn get_assignments_prox(pool: web::Data<Pool<sqlx::Postgres>>) -> impl Responder {
    let assingments: Result<Vec<AssignmentsProx>, sqlx::Error> = sqlx::query_as::<_, AssignmentsProx>("SELECT id, name, duedate::text FROM get_upcoming_assignments()")
        .fetch_all(pool.get_ref())
        .await;

    match assingments {
        Ok(data) => HttpResponse::Ok().json(data),
        Err(err) => handle_db_error(err),
    }
}

#[get("/cursoAssigments/{id}")]
async fn get_assigments_by_curso(pool: web::Data<Pool<sqlx::Postgres>>, path: web::Path<i32>) -> impl Responder {
    let id = path.into_inner();
    let assingments: Result<Option<AssignmentsProx>, sqlx::Error> = sqlx::query_as::<_, AssignmentsProx>("SELECT id, name, duedate FROM mdl_assign WHERE course = $1")
        .bind(id)
        .fetch_optional(pool.get_ref())
        .await;

    match assingments {
        Ok(Some(data)) => HttpResponse::Ok().json(data),
        Ok(None) => HttpResponse::NotFound().body("No se encontaron asignaciones pendientes"),
        Err(err) => handle_db_error(err),
    }
}

#[get("/assignments/{id}")]
pub async fn get_assignment_by_id(
    pool: web::Data<Pool<Postgres>>, 
    path: web::Path<i32>
) -> impl Responder {
    let id = path.into_inner();
    debug!("Obteniendo asignación con ID: {}", id);
    
    let assignment: Result<Option<Assignment>, sqlx::Error> = sqlx::query_as::<_, Assignment>(
        "SELECT * FROM mdl_assign WHERE id = $1"
    )
    .bind(id)
    .fetch_optional(pool.get_ref())
    .await;

    match assignment {
        Ok(Some(data)) => {
            debug!("Asignación encontrada con ID: {}", id);
            HttpResponse::Ok().json(data)
        },
        Ok(None) => {
            debug!("No se encontró asignación con ID: {}", id);
            HttpResponse::NotFound().json(serde_json::json!({
                "message": "Asignación no encontrada"
            }))
        },
        Err(err) => handle_db_error(err),
    }
}


#[post("/assignments")]
pub async fn create_assignment(
    pool: web::Data<PgPool>,
    payload: web::Json<CreateAssignmentDto>,
) -> impl Responder {
    debug!("Creando nueva asignación para el curso: {}", payload.course);

    let result = sqlx::query(
        "SELECT create_assignment($1, $2, $3, $4, $5, $6, $7)"
    )
    .bind(payload.course)
    .bind(&payload.name)
    .bind(&payload.intro)
    .bind(payload.section)
    .bind(&payload.duedate)
    .bind(&payload.allowsubmissionsfromdate)
    .bind(payload.grade)
    .execute(pool.get_ref())
    .await;

    match result {
        Ok(_) => {
            HttpResponse::Created().json(serde_json::json!({
                "message": "Asignación creada exitosamente",
                "course": payload.course,
                "name": payload.name
            }))
        },
        Err(err) => {
            error!("Error al crear asignación: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al crear la asignación",
                "message": err.to_string()
            }))
        },
    }
}

#[put("/assignments/{id}")]
pub async fn update_assignment(
    pool: web::Data<PgPool>,
    path: web::Path<i32>,
    payload: web::Json<UpdateAssignmentDto>,
) -> impl Responder {
    let id = path.into_inner();
    debug!("Actualizando asignación con ID: {}", id);

    let result = sqlx::query_as::<_, Assignment>(
        "SELECT * FROM update_assignment($1, $2, $3, $4, $5, $6, $7, $8, $9)"
    )
    .bind(id)
    .bind(payload.name.as_deref())
    .bind(payload.intro.as_deref())
    .bind(payload.section)
    .bind(payload.duedate.as_deref()) 
    .bind(payload.allowsubmissionsfromdate.as_deref()) 
    .bind(payload.grade)
    .bind(payload.alwaysshowdescription)
    .bind(payload.nosubmissions)
    .fetch_one(pool.get_ref())
    .await;

    match result {
        Ok(assignment) => {
            HttpResponse::Ok().json(assignment)
        },
        Err(sqlx::Error::RowNotFound) => {
            HttpResponse::NotFound().json(serde_json::json!({
                "message": "Asignación no encontrada"
            }))
        },
        Err(err) => {
            error!("Error al actualizar asignación: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al actualizar la asignación",
                "message": err.to_string()
            }))
        }
    }
}


#[delete("/assignments/{id}")]
pub async fn delete_assignment(
    pool: web::Data<PgPool>,
    path: web::Path<i32>,
) -> impl Responder {
    let id = path.into_inner();
    debug!("Eliminando asignación con ID: {}", id);

    // Verificamos si la asignación existe antes de intentar eliminarla
    let assignment_exists = sqlx::query("SELECT 1 FROM mdl_assign WHERE id = $1")
        .bind(id)
        .fetch_optional(pool.get_ref())
        .await;

    match assignment_exists {
        Ok(Some(_)) => {
            let result = sqlx::query("DELETE FROM mdl_assign WHERE id = $1")
                .bind(id)
                .execute(pool.get_ref())
                .await;

            match result {
                Ok(_) => {
                    HttpResponse::Ok().json(serde_json::json!({
                        "message": "Asignación eliminada exitosamente",
                        "id": id
                    }))
                },
                Err(err) => {
                    error!("Error al eliminar asignación: {}", err);
                    HttpResponse::InternalServerError().json(serde_json::json!({
                        "error": "Error al eliminar la asignación",
                        "message": err.to_string()
                    }))
                }
            }
        },
        Ok(None) => {
            HttpResponse::NotFound().json(serde_json::json!({
                "message": "Asignación no encontrada"
            }))
        },
        Err(err) => {
            error!("Error al verificar existencia de asignación: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al verificar existencia de asignación",
                "message": err.to_string()
            }))
        }
    }
}