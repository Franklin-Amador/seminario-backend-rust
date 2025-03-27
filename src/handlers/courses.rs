use crate::error::error::handle_db_error;
use crate::models::course::{Course, CreateCourseDto, UpdateCourseDto};
use actix_web::{get, post, put, web, HttpResponse, Responder};
use log::{debug, error};
use sqlx::PgPool;

// paquetes como path y error van por default no se necesitan llamar
// para los let de la query se usa la funcion sqlx::query_as

#[get("/courses")]
async fn get_courses(pool: web::Data<PgPool>) -> impl Responder {
    let courses = sqlx::query_as::<_, Course>("SELECT * FROM get_all_courses()")
        .fetch_all(pool.get_ref())
        .await;

    match courses {
        Ok(data) => HttpResponse::Ok().json(data), // Retorna los cursos en formato JSON
        Err(err) => handle_db_error(err),
    }
}

#[post("/course")]
pub async fn create_course(
    pool: web::Data<PgPool>,
    payload: web::Json<CreateCourseDto>,
) -> impl Responder {
    debug!("Creando nuevo curso para el curso: {}", payload.fullname);

    let result = sqlx::query("SELECT create_course($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)")
        .bind(payload.category)
        .bind(&payload.sortorder)
        .bind(payload.fullname.clone())
        .bind(&payload.shortname)
        .bind(&payload.idnumber)
        .bind(&payload.summary)
        .bind(&payload.format)
        .bind(payload.startdate)
        .bind(payload.enddate)
        .bind(payload.visible)
        .execute(pool.get_ref())
        .await;

    match result {
        Ok(_) => HttpResponse::Created().json(serde_json::json!({
            "message": "Asignación creada exitosamente",
            "name": payload.fullname
        })),
        Err(err) => {
            error!("Error al crear curso: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al crear al crear el curso",
                "message": err.to_string()
            }))
        }
    }
}

#[put("/course/{id}")]
pub async fn update_course(
    pool: web::Data<PgPool>,
    path: web::Path<i32>,
    payload: web::Json<UpdateCourseDto>,
) -> impl Responder {
    let id = path.into_inner();
    debug!("Actualizando asignación con ID: {}", id);

    let result: Result<_, sqlx::Error> = sqlx::query_as::<_, Course>(
        "SELECT * FROM update_course($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
    )
    .bind(id)
    .bind(payload.category)
    .bind(payload.sortorder)
    .bind(payload.fullname.clone())
    .bind(payload.shortname.clone())
    .bind(payload.idnumber.clone())
    .bind(payload.summary.clone())
    .bind(payload.format.clone())
    .bind(payload.startdate)
    .bind(payload.enddate)
    .bind(payload.visible)
    .fetch_one(pool.get_ref())
    .await;

    match result {
        Ok(assignment) => HttpResponse::Ok().json(assignment),
        Err(sqlx::Error::RowNotFound) => HttpResponse::NotFound().json(serde_json::json!({
            "message": "Asignación no encontrada"
        })),
        Err(err) => {
            error!("Error al actualizar asignación: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al actualizar la asignación",
                "message": err.to_string()
            }))
        }
    }
}
