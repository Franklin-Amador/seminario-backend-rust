// use chrono::NaiveDateTime;
// models/assignment.rs
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Serialize, FromRow)]
#[sqlx(rename_all = "snake_case")]
pub struct Sections {
    pub id: i32,
    pub course: i32,
    pub section: i32,
    pub name: String,
    pub summary: Option<String>,
    pub visible: Option<bool>
}

#[derive(Deserialize)]
pub struct CreateSectionDto {
    pub course: i32,
    pub name: String,
    pub summary: Option<String>,
    pub sequence: Option<String>,
    pub visible: Option<bool>
}

#[derive(Deserialize)]
pub struct UpdateSectionDto {
    // pub course: Option<i32>,
    // pub section: Option<i32>,
    pub name: Option<String>,
    pub summary: Option<String>,
    pub sequence: Option<String>,
    pub visible: Option<bool>,
}
