use actix_web::{post, get,put, delete, web, HttpResponse, Responder};
use sqlx::{Pool, Postgres};
use log::{error, debug};
use sqlx::PgPool;
use crate::models::sections::{CreateSectionDto, Sections, UpdateSectionDto};

fn handle_db_error(err: sqlx::Error) -> HttpResponse {
    error!("Error en la base de datos: {}", err);
    HttpResponse::InternalServerError().json(serde_json::json!({
        "error": "Error en la base de datos",
        "message": err.to_string()
    }))
}

#[get("/secciones")]
async fn get_secciones(pool: web::Data<Pool<sqlx::Postgres>>) -> impl Responder {
    let sections: Result<Vec<Sections>, sqlx::Error> = sqlx::query_as::<_, Sections>("SELECT id, name, course, section, summary, visible FROM get_sections()")
        .fetch_all(pool.get_ref())
        .await;

    match sections {
        Ok(data) => HttpResponse::Ok().json(data),
        Err(err) => handle_db_error(err),
    }
}

#[get("/secciones/course/{course_id}")]
async fn get_course_sections(
    pool: web::Data<Pool<Postgres>>,
    course_id: web::Path<i32>,
) -> impl Responder {
    let course_id = course_id.into_inner();

    let sections: Result<Vec<Sections>, sqlx::Error> = sqlx::query_as::<_, Sections>(
        "SELECT * FROM get_course_sections($1)"
    )
    .bind(course_id)
    .fetch_all(pool.get_ref())
    .await;

    match sections {
        Ok(data) => HttpResponse::Ok().json(data),
        Err(err) => handle_db_error(err),
    }
}


#[post("/secciones")]
pub async fn create_section(
    pool: web::Data<PgPool>,
    payload: web::Json<CreateSectionDto>,
) -> impl Responder {
    debug!("Creando nueva seccion para el curso: {}", payload.course);

    let result = sqlx::query(
        "SELECT create_section($1, $2, $3, $4, $5)"
    )
    .bind(payload.course)
    .bind(&payload.name)
    .bind(&payload.summary)
    .bind(&payload.sequence)
    .bind(&payload.visible) 
    .execute(pool.get_ref())
    .await;

    match result {
        Ok(_) => {
            HttpResponse::Created().json(serde_json::json!({
                "message": "Seccion creada exitosamente",
                "course": payload.course,
                "name": payload.name
            }))
        },
        Err(err) => {
            error!("Error al crear la seccion: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al crear la seccion",
                "message": err.to_string()
            }))
        },
    }
}

#[put("/seccion/{id}")]
pub async fn update_section(
    pool: web::Data<PgPool>,
    path: web::Path<i32>,
    payload: web::Json<UpdateSectionDto>,
) -> impl Responder {
    let id = path.into_inner();
    debug!("Actualizando seccion con ID: {}", id);

    let result: Result<Sections, sqlx::Error> = sqlx::query_as::<_, Sections>(
        "SELECT * FROM update_section($1, $2, $3, $4, $5)"
    )
    .bind(id)
    .bind(payload.name.as_deref())
    .bind(payload.summary.as_deref())
    .bind(payload.sequence.as_deref())
    .bind(payload.visible) 
    .fetch_one(pool.get_ref())
    .await;

    match result {
        Ok(section) => {
            HttpResponse::Ok().json(section)
        },
        Err(sqlx::Error::RowNotFound) => {
            HttpResponse::NotFound().json(serde_json::json!({
                "message": "Seccion no encontrada"
            }))
        },
        Err(err) => {
            error!("Error al actualizar seccion: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al actualizar la seccion",
                "message": err.to_string()
            }))
        }
    }
}


#[delete("/seccion/{id}")]
pub async fn delete_section(
    pool: web::Data<PgPool>,
    path: web::Path<i32>,
) -> impl Responder {
    let id = path.into_inner();
    debug!("Eliminando seccion con ID: {}", id);

    let assignment_exists = sqlx::query("SELECT 1 FROM mdl_course_sections WHERE id = $1")
        .bind(id)
        .fetch_optional(pool.get_ref())
        .await;

    match assignment_exists {
        Ok(Some(_)) => {
            let result = sqlx::query("DELETE FROM mdl_course_sections WHERE id = $1")
                .bind(id)
                .execute(pool.get_ref())
                .await;

            match result {
                Ok(_) => {
                    HttpResponse::Ok().json(serde_json::json!({
                        "message": "Seccion eliminada exitosamente",
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
                "message": "Seccion no encontrada"
            }))
        },
        Err(err) => {
            error!("Error al verificar existencia de la seccion: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al verificar existencia de seccion",
                "message": err.to_string()
            }))
        }
    }
}