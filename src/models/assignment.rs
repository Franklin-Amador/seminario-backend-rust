use chrono::NaiveDateTime;
// use chrono::NaiveDateTime;
// models/assignment.rs
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Serialize, FromRow)]
#[sqlx(rename_all = "snake_case")]
pub struct AssignmentsProx {
    pub id: i32,
    pub duedate: Option<NaiveDateTime>,
    pub name: String,
}

#[derive(Serialize, Deserialize, FromRow)]
pub struct Assignment {
    pub id: i32,
    pub course: i32,
    pub name: String,
    pub intro: String,
    pub introformat: i32,
    pub section: i32,
    pub alwaysshowdescription: bool,
    pub nosubmissions: bool,
    pub submissiondrafts: bool,
    pub sendnotifications: bool,
    pub sendlatenotifications: bool,
    pub duedate: Option<NaiveDateTime>,
    pub allowsubmissionsfromdate: Option<NaiveDateTime>,
    pub grade: Option<i32>,
    pub timemodified: NaiveDateTime,
    pub requiresubmissionstatement: bool,
    pub completionsubmit: bool,
    pub cutoffdate: Option<NaiveDateTime>,
    pub gradingduedate: Option<NaiveDateTime>,
    pub teamsubmission: bool,
    pub requireallteammemberssubmit: bool,
    pub teamsubmissiongroupingid: i32,
    pub blindmarking: bool,
    pub revealidentities: bool,
    pub attemptreopenmethod: String,
    pub maxattempts: i32,
    pub markingworkflow: bool,
    pub markingallocation: bool,
}

#[derive(Deserialize)]
pub struct CreateAssignmentDto {
    pub course: i32,
    pub name: String,
    pub intro: String,
    pub section: i32,
    pub duedate: Option<NaiveDateTime>,
    pub allowsubmissionsfromdate: Option<NaiveDateTime>,
    pub grade: Option<i32>,
}

// #[derive(Debug, Deserialize)]
// pub struct CreateAssignmentDto {
//     pub course: i32,
//     #[validate(length(min = 1, message = "El nombre no puede estar vacío"))]
//     pub name: String,
//     pub intro: String,
//     #[validate(range(min = 1, message = "El section debe ser positivo"))]
//     pub section: i32,
//     pub duedate: Option<NaiveDateTime>,
//     pub allowsubmissionsfromdate: Option<NaiveDateTime>,
//     #[validate(range(min = 0, max = 100, message = "El grade debe estar entre 0 y 100"))]
//     pub grade: Option<i32>,
// }

#[derive(Deserialize)]
pub struct UpdateAssignmentDto {
    pub name: Option<String>,
    pub intro: Option<String>,
    pub section: Option<i32>,
    pub duedate: Option<NaiveDateTime>, 
    pub allowsubmissionsfromdate: Option<NaiveDateTime>, 
    pub grade: Option<i32>,
    pub alwaysshowdescription: Option<bool>,
    pub nosubmissions: Option<bool>,
    // pub submissiondrafts: Option<bool>,
    // pub sendnotifications: Option<bool>,
    // pub sendlatenotifications: Option<bool>,
    // pub cutoffdate: Option<String>,
    // pub gradingduedate: Option<String>,
    // pub teamsubmission: Option<bool>,
    // pub requireallteammemberssubmit: Option<bool>,
    // pub teamsubmissiongroupingid: Option<i32>,
    // pub blindmarking: Option<bool>,
    // pub revealidentities: Option<bool>,
    // pub attemptreopenmethod: Option<String>,
    // pub maxattempts: Option<i32>,
    // pub markingworkflow: Option<bool>,
    // pub markingallocation: Option<bool>,
}
