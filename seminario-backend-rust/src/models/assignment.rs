// use chrono::NaiveDateTime;
// models/assignment.rs
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Serialize, FromRow)]
#[sqlx(rename_all = "snake_case")]
pub struct AssignmentsProx {
    pub id: i32,
    pub duedate: String,
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
    pub duedate: Option<String>,
    pub allowsubmissionsfromdate: Option<String>,
    pub grade: Option<i32>,
    pub timemodified: String,
    pub requiresubmissionstatement: bool,
    pub completionsubmit: bool,
    pub cutoffdate: Option<String>,
    pub gradingduedate: Option<String>,
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
    pub duedate: Option<String>,
    pub allowsubmissionsfromdate: Option<String>,
    pub grade: Option<i32>,
}

#[derive(Deserialize)]
pub struct UpdateAssignmentDto {
    pub name: Option<String>,
    pub intro: Option<String>,
    pub section: Option<i32>,
    pub duedate: Option<String>, // Fecha como texto
    pub allowsubmissionsfromdate: Option<String>, // Fecha como texto
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

// fn deserialize_optional_datetime<'de, D>(deserializer: D) -> Result<Option<NaiveDateTime>, D::Error>
// where
//     D: Deserializer<'de>,
// {
//     let s: Option<String> = Option::deserialize(deserializer)?;
//     match s {
//         Some(dt_str) => NaiveDateTime::parse_from_str(&dt_str, "%Y-%m-%dT%H:%M:%S")
//             .map(Some)
//             .map_err(serde::de::Error::custom),
//         None => Ok(None),
//     }
// }

// // Funciones para valores por defecto
// fn default_teamsubmissiongroupingid() -> i32 {
//     0
// }

// fn default_attemptreopenmethod() -> String {
//     "none".to_string()
// }

// fn default_maxattempts() -> i32 {
//     -1
// }