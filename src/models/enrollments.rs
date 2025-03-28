use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use validator::Validate;

#[derive(Serialize, Deserialize, FromRow)]
pub struct Enrollment {
    pub id: i32,
    pub enrolid: i32,
    pub userid: i32,
    pub courseid: i32,
    pub status: i32,
    pub timestart: Option<NaiveDateTime>,
    pub timeend: Option<NaiveDateTime>,
    pub timecreated: NaiveDateTime,
    pub timemodified: NaiveDateTime,
}

#[derive(Deserialize, Validate)]
pub struct CreateEnrollmentsDto {
    #[validate(range(min = 1, message = "El enrolid debe ser positivo"))]
    pub enrolid: i32,
    #[validate(range(min = 1, message = "El ID del usuario debe ser positivo"))]
    pub userid: i32,
    #[validate(range(min = 1, message = "El ID del curso debe ser positivo"))]
    pub courseid: i32,
    #[validate(range(
        min = 0,
        max = 1,
        message = "El status debe ser positivo entre 1 activo y 0 inactivo"
    ))]
    pub status: i32,
    pub timestart: Option<NaiveDateTime>,
    pub timeend: Option<NaiveDateTime>,
}

#[derive(Deserialize, Validate)]
pub struct UpdateEnrollmentsDto {
    // pub enrollment_id: i32,
    #[validate(range(min = 1, message = "El enrolid debe ser positivo"))]
    pub enrolid: i32,
    #[validate(range(
        min = 0,
        max = 1,
        message = "El status debe ser positivo entre 1 activo y 0 inactivo"
    ))]
    pub status: i32,
    pub timestart: Option<NaiveDateTime>,
    pub timeend: Option<NaiveDateTime>,
}
