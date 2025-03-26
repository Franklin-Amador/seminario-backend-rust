use sqlx::{postgres::PgPoolOptions, PgPool};

// conexion a la base de datos

pub async fn connect_db(database_url: &str) -> Result<PgPool, sqlx::Error> {
    PgPoolOptions::new()
        .max_connections(5)
        .connect(database_url)
        .await
}
