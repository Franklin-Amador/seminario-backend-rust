#!/bin/bash

set -e

echo "Iniciando proceso de inicialización de la base de datos..."

# Función para ejecutar scripts SQL
execute_script() {
    local script="$1"
    echo "Ejecutando script: $(basename "$script")"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$script"
}

# Verificar si es necesario ejecutar los scripts
if [ -f /var/lib/postgresql/data/PG_VERSION ]; then
    echo "La base de datos ya existe, verificando procedimientos almacenados..."
    
    # Verificar si los procedimientos existen
    if ! psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT 1 FROM pg_proc WHERE proname = 'get_sections'" | grep -q 1; then
        echo "Procedimientos almacenados no encontrados, ejecutando scripts..."
        for script in /docker-entrypoint-initdb.d/*.sql; do
            execute_script "$script"
        done
    else
        echo "La base de datos ya está completamente inicializada"
    fi
else
    echo "Inicializando nueva base de datos..."
    for script in /docker-entrypoint-initdb.d/*.sql; do
        execute_script "$script"
    done
fi

echo "Inicialización completada"