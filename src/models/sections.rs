// use chrono::NaiveDateTime;
// models/assignment.rs
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use validator::Validate;

#[derive(Serialize, FromRow)]
#[sqlx(rename_all = "snake_case")]
pub struct Sections {
    pub id: i32,
    pub course: i32,
    pub section: i32,
    pub name: String,
    pub summary: Option<String>,
    pub visible: Option<bool>,
}

#[derive(Deserialize, Validate)]
pub struct CreateSectionDto {
    #[validate(range(min = 1, message = "El ID del curso debe ser positivo"))]
    pub course: i32,
    #[validate(length(min = 1, message = "El nombre no puede estar vacío"))]
    pub name: String,
    pub summary: Option<String>,
    pub sequence: Option<String>,
    pub visible: Option<bool>,
}

#[derive(Deserialize, Validate)]
pub struct UpdateSectionDto {
    // pub course: Option<i32>,
    // pub section: Option<i32>,
    #[validate(length(min = 1, message = "El nombre no puede estar vacío"))]
    pub name: Option<String>,
    pub summary: Option<String>,
    pub sequence: Option<String>,
    pub visible: Option<bool>,
}
