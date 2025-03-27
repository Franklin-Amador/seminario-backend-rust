use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Serialize, FromRow)]
#[sqlx(rename_all = "snake_case")]
pub struct Course {
    pub id: i32,
    pub fullname: String,
    pub category: i32,
}

#[derive(Deserialize)]
pub struct CreateCourseDto {
    pub category: i32,
    pub sortorder: i32,
    pub fullname: String,
    pub shortname: String,
    pub idnumber: Option<String>,
    pub summary: Option<String>,
    pub format: String,
    pub startdate: NaiveDateTime,
    pub enddate: Option<NaiveDateTime>,
    pub visible: bool,
}

#[derive(Deserialize)]
pub struct UpdateCourseDto {
    pub category: i32,
    pub sortorder: i32,
    pub fullname: String,
    pub shortname: String,
    pub idnumber: Option<String>,
    pub summary: Option<String>,
    pub format: String,
    pub startdate: NaiveDateTime,
    pub enddate: Option<NaiveDateTime>,
    pub visible: bool,
}
