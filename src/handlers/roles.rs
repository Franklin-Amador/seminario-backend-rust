use crate::error::error::handle_db_error;
use crate::models::rol::{CreateRolDto, Rol};
use actix_web::{delete, get, post, web, HttpResponse, Responder};
use log::{debug, error};
use sqlx::{PgPool, Pool};

// paquetes como path y error van por default no se necesitan llamar
// para los let de la query se usa la funcion sqlx::query_as

#[get("/roles")]
async fn get_roles(pool: web::Data<Pool<sqlx::Postgres>>) -> impl Responder {
    let roles = sqlx::query_as::<_, Rol>("SELECT id, name, description FROM get_all_roles()")
        .fetch_all(pool.get_ref())
        .await;

    match roles {
        Ok(data) => HttpResponse::Ok().json(data),
        Err(err) => handle_db_error(err),
    }
}

#[get("/rol/{id}")]
async fn get_rol(pool: web::Data<Pool<sqlx::Postgres>>, path: web::Path<i32>) -> impl Responder {
    let id: i32 = path.into_inner();
    let rol = sqlx::query_as::<_, Rol>("SELECT id, name, description FROM get_role_by_id($1)")
        .bind(id)
        .fetch_optional(pool.get_ref())
        .await;

    match rol {
        Ok(Some(data)) => HttpResponse::Ok().json(data),
        Ok(None) => HttpResponse::NotFound().body("Rol no encontrado"),
        Err(err) => handle_db_error(err),
    }
}

#[post("/rol")]
pub async fn create_rol(
    pool: web::Data<PgPool>,
    payload: web::Json<CreateRolDto>,
) -> impl Responder {
    debug!("Creando un nuevo rol: {}", payload.name);

    let result = sqlx::query("SELECT create_role($1, $2, $3, $4, $5)")
        .bind(payload.name.clone())
        .bind(&payload.shortname)
        .bind(&payload.description)
        .bind(payload.sortorder)
        .bind(&payload.archetype)
        .execute(pool.get_ref())
        .await;

    match result {
        Ok(_) => HttpResponse::Created().json(serde_json::json!({
            "message": "rol creado corectamente",
            "name": payload.name
        })),
        Err(err) => {
            error!("Error al crear el rol: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al crear un rol de usuario",
                "message": err.to_string()
            }))
        }
    }
}

#[delete("/rol/{id}")]
pub async fn delete_rol(pool: web::Data<PgPool>, path: web::Path<i32>) -> impl Responder {
    let id = path.into_inner();
    debug!("Eliminando rol con ID: {}", id);

    // Verificamos si la asignación existe antes de intentar eliminarla
    let assignment_exists = sqlx::query("SELECT 1 FROM mdl_role WHERE id = $1")
        .bind(id)
        .fetch_optional(pool.get_ref())
        .await;

    match assignment_exists {
        Ok(Some(_)) => {
            let result = sqlx::query("DELETE FROM mdl_role WHERE id = $1")
                .bind(id)
                .execute(pool.get_ref())
                .await;

            match result {
                Ok(_) => HttpResponse::Ok().json(serde_json::json!({
                    "message": "Rol eliminado exitosamente",
                    "id": id
                })),
                Err(err) => {
                    error!("Error al eliminar rol: {}", err);
                    HttpResponse::InternalServerError().json(serde_json::json!({
                        "error": "Error al eliminar el rol",
                        "message": err.to_string()
                    }))
                }
            }
        }
        Ok(None) => HttpResponse::NotFound().json(serde_json::json!({
            "message": "Rol no encontrada"
        })),
        Err(err) => {
            error!("Error al verificar existencia del rol: {}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Error al verificar existencia de este rol",
                "message": err.to_string()
            }))
        }
    }
}
