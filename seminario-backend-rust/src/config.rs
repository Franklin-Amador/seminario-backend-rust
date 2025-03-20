use sqlx::{PgPool, postgres::PgPoolOptions};

// conexion a la base de datos

pub async fn connect_db(database_url: &str) -> Result<PgPool, sqlx::Error> {
    PgPoolOptions::new()
        .max_connections(5)
        .connect(database_url)
        .await
}
