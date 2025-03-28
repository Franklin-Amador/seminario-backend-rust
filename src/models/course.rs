use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use validator::Validate;

#[derive(Serialize, FromRow)]
#[sqlx(rename_all = "snake_case")]
pub struct Course {
    pub id: i32,
    pub fullname: String,
    pub category: i32,
}

#[derive(Deserialize, Validate)]
pub struct CreateCourseDto {
    #[validate(range(min = 1, message = "El ID de la categoria debe ser positivo"))]
    pub category: i32,
    pub sortorder: i32,
    #[validate(length(min = 1, max = 200, message = "El nombre no puede estar vacío"))]
    pub fullname: String,
    #[validate(length(min = 1, max = 20, message = "El shortname no puede estar vacío"))]
    pub shortname: String,
    pub idnumber: Option<String>,
    pub summary: Option<String>,
    pub format: String,
    pub startdate: NaiveDateTime,
    pub enddate: Option<NaiveDateTime>,
    pub visible: bool,
}

#[derive(Deserialize, Validate)]
pub struct UpdateCourseDto {
    #[validate(range(min = 1, message = "El ID de la categoria debe ser positivo"))]
    pub category: i32,
    pub sortorder: i32,
    #[validate(length(min = 1, max = 200, message = "El nombre no puede estar vacío"))]
    pub fullname: String,
    #[validate(length(min = 1, max = 20, message = "El shortname no puede estar vacío"))]
    pub shortname: String,
    pub idnumber: Option<String>,
    pub summary: Option<String>,
    pub format: String,
    pub startdate: NaiveDateTime,
    pub enddate: Option<NaiveDateTime>,
    pub visible: bool,
}
