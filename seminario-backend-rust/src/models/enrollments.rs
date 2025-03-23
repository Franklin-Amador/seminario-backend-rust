use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use chrono::NaiveDateTime;

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


#[derive(Deserialize)]
pub struct CreateEnrollmentsDto {
    pub enrolid: i32,
    pub userid: i32,
    pub courseid: i32,
    pub status: i32,
    pub timestart: Option<NaiveDateTime>,
    pub timeend: Option<NaiveDateTime>,
}

#[derive(Deserialize)]
pub struct UpdateEnrollmentsDto {
    // pub enrollment_id: i32,
    pub enrolid: i32,
    pub status: i32,
    pub timestart: Option<NaiveDateTime>,
    pub timeend: Option<NaiveDateTime>,
}