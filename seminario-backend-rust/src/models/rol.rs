use serde::Serialize;
use sqlx::FromRow;

#[derive(Serialize, FromRow)]
#[sqlx(rename_all = "snake_case")]
pub struct Rol {
    pub id: i32,
    pub name: String,
    pub description: String,
}
