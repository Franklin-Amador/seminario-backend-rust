use serde::{Deserialize, Serialize};
use sqlx::FromRow;

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

#[derive(Deserialize)]
pub struct CreateRolDto {
    pub name: String,
    pub shortname: String,
    pub description: String,
    pub sortorder: i32,
    pub archetype: String,
}
