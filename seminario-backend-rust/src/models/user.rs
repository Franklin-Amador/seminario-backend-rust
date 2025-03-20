use serde::Serialize;
use sqlx::FromRow;

#[derive(Serialize, FromRow)]
#[sqlx(rename_all = "snake_case")]
pub struct User {
    pub id: i32,
    pub username: String,
}
