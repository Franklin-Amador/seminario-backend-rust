use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use validator::Validate;

#[derive(Serialize, FromRow)]
#[sqlx(rename_all = "snake_case")]
pub struct Rol {
    pub id: i32,
    pub name: String,
    // pub shortname: String,
    pub description: String,
    // pub sortorder: i32,
    // pub archetype: String,
}

#[derive(Deserialize, Validate)]
pub struct CreateRolDto {
    #[validate(length(min = 1, max = 100, message = "El nombre no puede estar vacío"))]
    pub name: String,
    #[validate(length(min = 1, max = 20, message = "El shortname no puede estar vacío"))]
    pub shortname: String,
    #[validate(length(min = 1, max = 300, message = "la descripcion no puede estar vacía"))]
    pub description: String,
    pub sortorder: i32,
    pub archetype: String,
}
