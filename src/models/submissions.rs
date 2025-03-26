use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use chrono::NaiveDateTime;

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

#[derive(Deserialize)]
pub struct CreateSubmissionDto {
    pub assignment: i32,
    pub userid: i32,
    pub timecreated: NaiveDateTime,
    pub timemodified: NaiveDateTime,
    pub status: String,
    pub groupid: i32,
    pub attemptnumber: i32,
    pub latest: bool,
}