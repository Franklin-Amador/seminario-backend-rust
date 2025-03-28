use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use validator::Validate;

#[derive(Serialize, Deserialize, FromRow)]
pub struct AssignmentSubmission {
    pub id: i32,
    pub assignment: i32,
    pub userid: i32,
    pub timecreated: NaiveDateTime,
    pub timemodified: NaiveDateTime,
    pub status: String,
    pub groupid: i32,
    pub attemptnumber: i32,
    pub latest: bool,
}

#[derive(Deserialize, Validate)]
pub struct CreateSubmissionDto {
    #[validate(range(min = 1, message = "El ID de la asignacion debe ser positivo"))]
    pub assignment: i32,
    #[validate(range(min = 1, message = "El ID del usuario debe ser positivo"))]
    pub userid: i32,
    pub timecreated: NaiveDateTime,
    pub timemodified: NaiveDateTime,
    pub status: String,
    pub groupid: i32,
    pub attemptnumber: i32,
    pub latest: bool,
}
