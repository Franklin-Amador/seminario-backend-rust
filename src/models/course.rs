use serde::Serialize;
use sqlx::FromRow;

#[derive(Serialize, FromRow)]
#[sqlx(rename_all = "snake_case")]
pub struct Course {
    pub id: i32,
    pub fullname: String,
    pub category: i32,
}
