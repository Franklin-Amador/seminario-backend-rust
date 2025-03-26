-- Archivo: stored_procedures.sql
-- Descripción: Procedimientos almacenados optimizados con nombres usando guiones bajos

-- Procedimiento completo de login que devuelve tanto el usuario como sus roles en una sola llamada
CREATE OR REPLACE FUNCTION user_login(p_username TEXT, p_password TEXT)
RETURNS TABLE (
    user_id INTEGER,
    username TEXT,
    firstname TEXT,
    lastname TEXT,
    email TEXT,
    is_valid BOOLEAN,
    role_id INTEGER,
    role_name TEXT,
    role_shortname TEXT
) AS $$
DECLARE
    v_user_record RECORD;
    v_password_valid BOOLEAN := FALSE;
BEGIN
    -- Obtener información del usuario
    SELECT id, username, password, firstname, lastname, email
    INTO v_user_record
    FROM mdl_user
    WHERE username = p_username
    AND deleted = FALSE;
    
    -- Verificar si se encontró el usuario
    IF v_user_record.id IS NOT NULL THEN
        -- Validar la contraseña usando una función auxiliar (implementada más abajo)
        SELECT validate_password(p_password, v_user_record.password) INTO v_password_valid;
        
        -- Devolver usuario y roles solo si la contraseña es válida
        IF v_password_valid THEN
            RETURN QUERY
            SELECT 
                v_user_record.id,
                v_user_record.username,
                v_user_record.firstname,
                v_user_record.lastname,
                v_user_record.email,
                TRUE,
                r.id,
                r.name,
                r.shortname
            FROM mdl_role_assignments ra
            JOIN mdl_role r ON ra.roleid = r.id
            WHERE ra.userid = v_user_record.id;
            
            -- Si el usuario no tiene roles, devolver al menos la información del usuario
            IF NOT FOUND THEN
                RETURN QUERY
                SELECT 
                    v_user_record.id,
                    v_user_record.username,
                    v_user_record.firstname,
                    v_user_record.lastname,
                    v_user_record.email,
                    TRUE,
                    NULL::INTEGER,
                    NULL::TEXT,
                    NULL::TEXT;
            END IF;
        ELSE
            -- Contraseña inválida
            RETURN QUERY
            SELECT 
                NULL::INTEGER,
                NULL::TEXT,
                NULL::TEXT,
                NULL::TEXT,
                NULL::TEXT,
                FALSE,
                NULL::INTEGER,
                NULL::TEXT,
                NULL::TEXT;
        END IF;
    ELSE
        -- Usuario no encontrado
        RETURN QUERY
        SELECT 
            NULL::INTEGER,
            NULL::TEXT,
            NULL::TEXT,
            NULL::TEXT,
            NULL::TEXT,
            FALSE,
            NULL::INTEGER,
            NULL::TEXT,
            NULL::TEXT;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Función auxiliar para validar contraseñas (simulando bcrypt en Postgres)
-- Nota: Esta función es un placeholder - el hash real se hará en Python con bcrypt
CREATE OR REPLACE FUNCTION validate_password(plain_password TEXT, hashed_password TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- Esta función es un placeholder
    -- La validación real se hará en Python con la biblioteca bcrypt
    -- Aquí solo hacemos un retorno directo porque el control real se hace en la aplicación
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Actualizar contraseña SIN manejo de transacciones (corregido)
CREATE OR REPLACE FUNCTION update_user_password(p_email TEXT, p_password TEXT)
RETURNS TABLE (
    success BOOLEAN,
    user_id INTEGER,
    message TEXT
) AS $$
DECLARE
    v_user_id INTEGER;
BEGIN
    -- Buscar usuario por email
    SELECT id INTO v_user_id
    FROM mdl_user
    WHERE email = p_email
    AND deleted = FALSE;
    
    -- Si el usuario existe, actualizar contraseña
    IF v_user_id IS NOT NULL THEN
        UPDATE mdl_user
        SET password = p_password,
            timemodified = NOW()
        WHERE id = v_user_id;
        
        RETURN QUERY
        SELECT 
            TRUE,
            v_user_id,
            'Contraseña actualizada exitosamente'::TEXT;
    ELSE
        RETURN QUERY
        SELECT 
            FALSE,
            NULL::INTEGER,
            'Usuario no encontrado'::TEXT;
    END IF;
EXCEPTION WHEN OTHERS THEN
    RETURN QUERY
    SELECT 
        FALSE,
        NULL::INTEGER,
        'Error al actualizar la contraseña: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Restablecer todas las contraseñas (sin manejo interno de transacciones)
CREATE OR REPLACE FUNCTION reset_all_passwords(p_password TEXT)
RETURNS TABLE (
    success BOOLEAN,
    count INTEGER,
    message TEXT
) AS $$
DECLARE
    v_count INTEGER := 0;
BEGIN
    -- Actualizar todas las contraseñas
    UPDATE mdl_user
    SET password = p_password,
        timemodified = NOW()
    WHERE deleted = FALSE;
    
    GET DIAGNOSTICS v_count = ROW_COUNT;
    
    RETURN QUERY
    SELECT 
        TRUE,
        v_count,
        'Se actualizaron ' || v_count || ' contraseñas exitosamente'::TEXT;
EXCEPTION WHEN OTHERS THEN
    RETURN QUERY
    SELECT 
        FALSE,
        0,
        'Error al actualizar contraseñas: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para auditar intentos de login
CREATE TABLE IF NOT EXISTS login_audit (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    ip_address TEXT,
    user_agent TEXT,
    success BOOLEAN NOT NULL,
    timestamp TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION audit_login_attempt(
    p_username TEXT,
    p_ip_address TEXT,
    p_user_agent TEXT,
    p_success BOOLEAN
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO login_audit (username, ip_address, user_agent, success)
    VALUES (p_username, p_ip_address, p_user_agent, p_success);
END;
$$ LANGUAGE plpgsql;

-- Eliminar los procedimientos anteriores con formato sp_xxx
DROP FUNCTION IF EXISTS sp_user_login(TEXT, TEXT);
DROP FUNCTION IF EXISTS sp_validate_password(TEXT, TEXT);
DROP FUNCTION IF EXISTS sp_update_user_password(TEXT, TEXT);
DROP FUNCTION IF EXISTS sp_reset_all_passwords(TEXT);
DROP FUNCTION IF EXISTS sp_audit_login_attempt(TEXT, TEXT, TEXT, BOOLEAN);


-- Archivo: additional_procedures.sql
-- Descripción: Procedimientos almacenados adicionales para consultas y mutaciones

-- =============================================
-- Procedimientos para consultas de usuario
-- =============================================

-- Obtener todos los usuarios
CREATE OR REPLACE FUNCTION get_all_users()
RETURNS SETOF mdl_user AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_user
    WHERE deleted = FALSE
    ORDER BY id;
END;
$$ LANGUAGE plpgsql;

-- Obtener un usuario por ID
CREATE OR REPLACE FUNCTION get_user_by_id(p_user_id INTEGER)
RETURNS SETOF mdl_user AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_user
    WHERE id = p_user_id AND deleted = FALSE;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para consultas de curso
-- =============================================

-- Obtener todos los cursos
CREATE OR REPLACE FUNCTION get_all_courses()
RETURNS SETOF mdl_course AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_course
    ORDER BY id;
END;
$$ LANGUAGE plpgsql;

-- Obtener un curso por ID
CREATE OR REPLACE FUNCTION get_course_by_id(p_course_id INTEGER)
RETURNS SETOF mdl_course AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_course
    WHERE id = p_course_id;
END;
$$ LANGUAGE plpgsql;

-- Obtener secciones de un curso
CREATE OR REPLACE FUNCTION get_course_sections(p_course_id INTEGER)
RETURNS SETOF mdl_course_sections AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_course_sections
    WHERE course = p_course_id
    ORDER BY section;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para consultas de categoría
-- =============================================

-- Obtener todas las categorías
CREATE OR REPLACE FUNCTION get_all_categories()
RETURNS SETOF mdl_course_categories AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_course_categories
    ORDER BY sortorder;
END;
$$ LANGUAGE plpgsql;

-- Obtener una categoría por ID
CREATE OR REPLACE FUNCTION get_category_by_id(p_category_id INTEGER)
RETURNS SETOF mdl_course_categories AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_course_categories
    WHERE id = p_category_id;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para consultas de rol
-- =============================================

-- Obtener todos los roles
CREATE OR REPLACE FUNCTION get_all_roles()
RETURNS SETOF mdl_role AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_role
    ORDER BY sortorder;
END;
$$ LANGUAGE plpgsql;

-- Obtener un rol por ID
CREATE OR REPLACE FUNCTION get_role_by_id(p_role_id INTEGER)
RETURNS SETOF mdl_role AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_role
    WHERE id = p_role_id;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para mutaciones de rol
-- =============================================

-- Crear un rol
CREATE OR REPLACE FUNCTION create_role(
    p_name TEXT,
    p_shortname TEXT,
    p_description TEXT,
    p_sortorder INTEGER,
    p_archetype TEXT
)
RETURNS SETOF mdl_role AS $$
BEGIN
    RETURN QUERY
    INSERT INTO mdl_role(name, shortname, description, sortorder, archetype)
    VALUES (p_name, p_shortname, p_description, p_sortorder, p_archetype)
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- Actualizar un rol
CREATE OR REPLACE FUNCTION update_role(
    p_role_id INTEGER,
    p_name TEXT,
    p_shortname TEXT,
    p_description TEXT,
    p_sortorder INTEGER,
    p_archetype TEXT
)
RETURNS SETOF mdl_role AS $$
BEGIN
    RETURN QUERY
    UPDATE mdl_role
    SET name = p_name,
        shortname = p_shortname,
        description = p_description,
        sortorder = p_sortorder,
        archetype = p_archetype
    WHERE id = p_role_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- Eliminar un rol
CREATE OR REPLACE FUNCTION delete_role(p_role_id INTEGER)
RETURNS SETOF mdl_role AS $$
DECLARE
    v_role mdl_role;
BEGIN
    -- Guardar datos del rol antes de eliminarlo
    SELECT * INTO v_role FROM mdl_role WHERE id = p_role_id;
    
    -- Eliminar el rol
    DELETE FROM mdl_role WHERE id = p_role_id;
    
    -- Devolver los datos del rol eliminado
    RETURN NEXT v_role;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para mutaciones de usuario
-- =============================================

-- Crear un usuario
CREATE OR REPLACE FUNCTION create_user(
    p_username TEXT,
    p_password TEXT,
    p_firstname TEXT,
    p_lastname TEXT,
    p_email TEXT,
    p_institution TEXT,
    p_department TEXT
)
RETURNS SETOF mdl_user AS $$
DECLARE
    v_now TIMESTAMP := NOW();
BEGIN
    RETURN QUERY
    INSERT INTO mdl_user(
        username, 
        password, 
        firstname, 
        lastname, 
        email, 
        institution, 
        department,
        confirmed,
        deleted,
        suspended,
        timecreated,
        timemodified
    )
    VALUES (
        p_username, 
        p_password, 
        p_firstname, 
        p_lastname, 
        p_email, 
        p_institution, 
        p_department,
        TRUE,  -- confirmed
        FALSE, -- deleted
        FALSE, -- suspended
        v_now, -- timecreated
        v_now  -- timemodified
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- Actualizar un usuario
CREATE OR REPLACE FUNCTION update_user(
    p_user_id INTEGER,
    p_username TEXT,
    p_password TEXT,
    p_firstname TEXT,
    p_lastname TEXT,
    p_email TEXT,
    p_institution TEXT,
    p_department TEXT
)
RETURNS SETOF mdl_user AS $$
BEGIN
    RETURN QUERY
    UPDATE mdl_user
    SET username = p_username,
        password = p_password,
        firstname = p_firstname,
        lastname = p_lastname,
        email = p_email,
        institution = p_institution,
        department = p_department,
        timemodified = NOW()
    WHERE id = p_user_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para asignaciones
-- =============================================

-- Obtener todas las asignaciones
CREATE OR REPLACE FUNCTION get_all_assignments()
RETURNS SETOF mdl_assign AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_assign
    ORDER BY id;
END;
$$ LANGUAGE plpgsql;

-- Obtener asignaciones por curso y sección
CREATE OR REPLACE FUNCTION get_assignments_by_course_section(
    p_course_id INTEGER,
    p_section_id INTEGER
)
RETURNS SETOF mdl_assign AS $$
BEGIN
    IF p_course_id IS NOT NULL AND p_section_id IS NOT NULL THEN
        RETURN QUERY
        SELECT * FROM mdl_assign
        WHERE course = p_course_id AND section = p_section_id
        ORDER BY id;
    ELSIF p_course_id IS NOT NULL THEN
        RETURN QUERY
        SELECT * FROM mdl_assign
        WHERE course = p_course_id
        ORDER BY id;
    ELSIF p_section_id IS NOT NULL THEN
        RETURN QUERY
        SELECT * FROM mdl_assign
        WHERE section = p_section_id
        ORDER BY id;
    ELSE
        RETURN QUERY
        SELECT * FROM mdl_assign
        ORDER BY id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Obtener asignaciones próximas
CREATE OR REPLACE FUNCTION get_upcoming_assignments()
RETURNS SETOF mdl_assign AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_assign
    WHERE duedate IS NOT NULL AND duedate >= NOW()
    ORDER BY duedate;
END;
$$ LANGUAGE plpgsql;

-- Obtener asignaciones próximas por curso
CREATE OR REPLACE FUNCTION get_upcoming_assignments_by_course(p_course_id INTEGER)
RETURNS SETOF mdl_assign AS $$
BEGIN
    IF p_course_id IS NOT NULL THEN
        RETURN QUERY
        SELECT * FROM mdl_assign
        WHERE duedate IS NOT NULL AND duedate >= NOW() AND course = p_course_id
        ORDER BY duedate;
    ELSE
        RETURN QUERY
        SELECT * FROM mdl_assign
        WHERE duedate IS NOT NULL AND duedate >= NOW()
        ORDER BY duedate;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Obtener una asignación por ID
CREATE OR REPLACE FUNCTION get_assignment_by_id(p_assignment_id INTEGER)
RETURNS SETOF mdl_assign AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_assign
    WHERE id = p_assignment_id;
END;
$$ LANGUAGE plpgsql;

-- Crear una asignación
CREATE OR REPLACE FUNCTION public.create_assignment(
    p_course integer,
    p_name text,
    p_intro text,
    p_section integer,
    p_duedate timestamp without time zone,
    p_allowsubmissionsfromdate timestamp without time zone,
    p_grade integer)
    RETURNS SETOF mdl_assign 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000
AS $BODY$
BEGIN
    -- Validaciones
    IF p_name IS NULL OR p_name = '' THEN
        RAISE EXCEPTION 'El nombre de la asignación no puede estar vacío';
    END IF;
    
    IF p_course <= 0 THEN
        RAISE EXCEPTION 'El ID del curso debe ser un número positivo';
    END IF;
    
    -- Insertar registro (ya no necesitamos conversión de fechas)
    RETURN QUERY
    INSERT INTO mdl_assign(
        course,
        name,
        intro,
        section,
        duedate,
        allowsubmissionsfromdate,
        grade,
        introformat,
        timemodified
    )
    VALUES (
        p_course,
        p_name,
        p_intro,
        p_section,
        p_duedate,  -- Usamos el timestamp directamente
        p_allowsubmissionsfromdate,  -- Usamos el timestamp directamente
        p_grade,
        1, -- introformat
        NOW() -- timemodified
    )
    RETURNING *;
END;
$BODY$;

ALTER FUNCTION public.create_assignment(integer, text, text, integer, timestamp without time zone, timestamp without time zone, integer)
    OWNER TO admin;


-- CREATE OR REPLACE FUNCTION public.create_assignment(
--     p_course integer,
--     p_name text,
--     p_intro text,
--     p_section integer,
--     p_duedate text,
--     p_allowsubmissionsfromdate text,
--     p_grade integer)
--     RETURNS SETOF mdl_assign 
--     LANGUAGE 'plpgsql'
--     COST 100
--     VOLATILE PARALLEL UNSAFE
--     ROWS 1000
-- AS $BODY$
-- DECLARE
--     v_duedate timestamp without time zone;
--     v_allowsubmissionsfromdate timestamp without time zone;
-- BEGIN
--     -- Validaciones
--     IF p_name IS NULL OR p_name = '' THEN
--         RAISE EXCEPTION 'El nombre de la asignación no puede estar vacío';
--     END IF;
    
--     IF p_course <= 0 THEN
--         RAISE EXCEPTION 'El ID del curso debe ser un número positivo';
--     END IF;
    
--     -- Convertir fechas con manejo de errores
--     BEGIN
--         IF p_duedate IS NOT NULL THEN
--             v_duedate := p_duedate::timestamp without time zone;
--         END IF;
--     EXCEPTION WHEN OTHERS THEN
--         RAISE EXCEPTION 'Formato de fecha inválido para duedate: %', p_duedate;
--     END;
    
--     BEGIN
--         IF p_allowsubmissionsfromdate IS NOT NULL THEN
--             v_allowsubmissionsfromdate := p_allowsubmissionsfromdate::timestamp without time zone;
--         END IF;
--     EXCEPTION WHEN OTHERS THEN
--         RAISE EXCEPTION 'Formato de fecha inválido para allowsubmissionsfromdate: %', p_allowsubmissionsfromdate;
--     END;
    
--     -- Insertar registro
--     RETURN QUERY
--     INSERT INTO mdl_assign(
--         course,
--         name,
--         intro,
--         section,
--         duedate,
--         allowsubmissionsfromdate,
--         grade,
--         introformat,
--         timemodified
--     )
--     VALUES (
--         p_course,
--         p_name,
--         p_intro,
--         p_section,
--         v_duedate,
--         v_allowsubmissionsfromdate,
--         p_grade,
--         1, -- introformat
--         NOW() -- timemodified
--     )
--     RETURNING *;
-- END;
-- $BODY$;

-- ALTER FUNCTION public.create_assignment(integer, text, text, integer, text, text, integer)
--     OWNER TO admin;

-- Actualizar una asignación
CREATE OR REPLACE FUNCTION public.update_assignment(
    p_id integer,
    p_name text DEFAULT NULL,
    p_intro text DEFAULT NULL,
    p_section integer DEFAULT NULL,
    p_duedate timestamp without time zone DEFAULT NULL,
    p_allowsubmissionsfromdate timestamp without time zone DEFAULT NULL,
    p_grade integer DEFAULT NULL,
    p_alwaysshowdescription boolean DEFAULT NULL,
    p_nosubmissions boolean DEFAULT NULL)
    RETURNS SETOF mdl_assign 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000
AS $BODY$
DECLARE
    v_update_parts text := '';
BEGIN
    -- Verificar si la asignación existe
    IF NOT EXISTS (SELECT 1 FROM mdl_assign WHERE id = p_id) THEN
        RAISE EXCEPTION 'La asignación con ID % no existe', p_id;
    END IF;
    
    -- Preparar las partes de la consulta de actualización
    IF p_name IS NOT NULL THEN
        v_update_parts := v_update_parts || ', name = ' || quote_literal(p_name);
    END IF;
    
    IF p_intro IS NOT NULL THEN
        v_update_parts := v_update_parts || ', intro = ' || quote_literal(p_intro);
    END IF;
    
    IF p_section IS NOT NULL THEN
        v_update_parts := v_update_parts || ', section = ' || p_section;
    END IF;
    
    -- Manejar fechas directamente (sin conversión)
    IF p_duedate IS NOT NULL THEN
        v_update_parts := v_update_parts || ', duedate = ' || quote_literal(p_duedate);
    END IF;
    
    IF p_allowsubmissionsfromdate IS NOT NULL THEN
        v_update_parts := v_update_parts || ', allowsubmissionsfromdate = ' || quote_literal(p_allowsubmissionsfromdate);
    END IF;
    
    IF p_grade IS NOT NULL THEN
        v_update_parts := v_update_parts || ', grade = ' || p_grade;
    END IF;
    
    IF p_alwaysshowdescription IS NOT NULL THEN
        v_update_parts := v_update_parts || ', alwaysshowdescription = ' || p_alwaysshowdescription;
    END IF;
    
    IF p_nosubmissions IS NOT NULL THEN
        v_update_parts := v_update_parts || ', nosubmissions = ' || p_nosubmissions;
    END IF;
    
    -- Si no hay nada que actualizar, salir
    IF v_update_parts = '' THEN
        RETURN QUERY SELECT * FROM mdl_assign WHERE id = p_id;
        RETURN;
    END IF;
    
    -- Eliminar la primera coma y agregar la actualización de timemodified
    v_update_parts := substring(v_update_parts from 2) || ', timemodified = NOW()';
    
    -- Construir y ejecutar la consulta dinámica
    RETURN QUERY EXECUTE 'UPDATE mdl_assign SET ' || v_update_parts || ' WHERE id = ' || p_id || ' RETURNING *';
END;
$BODY$;

ALTER FUNCTION public.update_assignment(
    integer, text, text, integer, 
    timestamp without time zone, timestamp without time zone, 
    integer, boolean, boolean)
    OWNER TO admin;


-- CREATE OR REPLACE FUNCTION public.update_assignment(
--     p_id integer,
--     p_name text DEFAULT NULL,
--     p_intro text DEFAULT NULL,
--     p_section integer DEFAULT NULL,
--     p_duedate text DEFAULT NULL,
--     p_allowsubmissionsfromdate text DEFAULT NULL,
--     p_grade integer DEFAULT NULL,
--     -- Añadir aquí el resto de campos que se pueden actualizar
--     p_alwaysshowdescription boolean DEFAULT NULL,
--     p_nosubmissions boolean DEFAULT NULL
--     -- etc.
-- )
-- RETURNS SETOF mdl_assign 
-- LANGUAGE 'plpgsql'
-- AS $BODY$
-- DECLARE
--     v_duedate timestamp without time zone;
--     v_allowsubmissionsfromdate timestamp without time zone;
--     v_update_parts text := '';
-- BEGIN
--     -- Verificar si la asignación existe
--     IF NOT EXISTS (SELECT 1 FROM mdl_assign WHERE id = p_id) THEN
--         RAISE EXCEPTION 'La asignación con ID % no existe', p_id;
--     END IF;
    
--     -- Preparar las partes de la consulta de actualización
--     IF p_name IS NOT NULL THEN
--         v_update_parts := v_update_parts || ', name = ' || quote_literal(p_name);
--     END IF;
    
--     IF p_intro IS NOT NULL THEN
--         v_update_parts := v_update_parts || ', intro = ' || quote_literal(p_intro);
--     END IF;
    
--     IF p_section IS NOT NULL THEN
--         v_update_parts := v_update_parts || ', section = ' || p_section;
--     END IF;
    
--     -- Manejar fechas con conversión
--     IF p_duedate IS NOT NULL THEN
--         BEGIN
--             v_duedate := p_duedate::timestamp without time zone;
--             v_update_parts := v_update_parts || ', duedate = ' || quote_literal(v_duedate);
--         EXCEPTION WHEN OTHERS THEN
--             RAISE EXCEPTION 'Formato de fecha inválido para duedate: %', p_duedate;
--         END;
--     END IF;
    
--     IF p_allowsubmissionsfromdate IS NOT NULL THEN
--         BEGIN
--             v_allowsubmissionsfromdate := p_allowsubmissionsfromdate::timestamp without time zone;
--             v_update_parts := v_update_parts || ', allowsubmissionsfromdate = ' || quote_literal(v_allowsubmissionsfromdate);
--         EXCEPTION WHEN OTHERS THEN
--             RAISE EXCEPTION 'Formato de fecha inválido para allowsubmissionsfromdate: %', p_allowsubmissionsfromdate;
--         END;
--     END IF;
    
--     -- Manejar el resto de campos aquí...
    
--     -- Si no hay nada que actualizar, salir
--     IF v_update_parts = '' THEN
--         RETURN QUERY SELECT * FROM mdl_assign WHERE id = p_id;
--         RETURN;
--     END IF;
    
--     -- Eliminar la primera coma y agregar la actualización de timemodified
--     v_update_parts := substring(v_update_parts from 2) || ', timemodified = NOW()';
    
--     -- Construir y ejecutar la consulta dinámica
--     RETURN QUERY EXECUTE 'UPDATE mdl_assign SET ' || v_update_parts || ' WHERE id = ' || p_id || ' RETURNING *';
-- END;
-- $BODY$;


-- FUNCTION: public.get_sections()

-- DROP FUNCTION IF EXISTS public.get_sections();

CREATE OR REPLACE FUNCTION public.get_sections()
    RETURNS SETOF mdl_course_sections 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_course_sections;
END;
$BODY$;

ALTER FUNCTION public.get_sections()
    OWNER TO admin;

-- =============================================
-- Procedimientos para envíos (submissions)
-- =============================================

-- Obtener envíos por asignación
CREATE OR REPLACE FUNCTION get_submissions_by_assignment(p_assignment_id INTEGER)
RETURNS SETOF mdl_assign_submission AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_assign_submission
    WHERE assignment = p_assignment_id
    ORDER BY timemodified DESC;
END;
$$ LANGUAGE plpgsql;

-- Obtener envíos por usuario
CREATE OR REPLACE FUNCTION get_submissions_by_user(p_user_id INTEGER)
RETURNS SETOF mdl_assign_submission AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_assign_submission
    WHERE userid = p_user_id
    ORDER BY timemodified DESC;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para foros
-- =============================================

-- Obtener foros
CREATE OR REPLACE FUNCTION get_forums(p_course_id INTEGER DEFAULT NULL)
RETURNS SETOF mdl_forum AS $$
BEGIN
    IF p_course_id IS NOT NULL THEN
        RETURN QUERY
        SELECT * FROM mdl_forum
        WHERE course = p_course_id
        ORDER BY id;
    ELSE
        RETURN QUERY
        SELECT * FROM mdl_forum
        ORDER BY id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Obtener discusiones por foro
CREATE OR REPLACE FUNCTION get_forum_discussions(p_forum_id INTEGER)
RETURNS SETOF mdl_forum_discussions AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_forum_discussions
    WHERE forum = p_forum_id
    ORDER BY timemodified DESC;
END;
$$ LANGUAGE plpgsql;

-- Obtener posts por discusión
CREATE OR REPLACE FUNCTION get_forum_posts(p_discussion_id INTEGER)
RETURNS SETOF mdl_forum_posts AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_forum_posts
    WHERE discussion = p_discussion_id
    ORDER BY created;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para calificaciones
-- =============================================

-- Obtener items de calificación por curso
CREATE OR REPLACE FUNCTION get_grade_items_by_course(p_course_id INTEGER)
RETURNS SETOF mdl_grade_items AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_grade_items
    WHERE courseid = p_course_id
    ORDER BY id;
END;
$$ LANGUAGE plpgsql;

-- Obtener calificaciones por usuario
CREATE OR REPLACE FUNCTION get_grades_by_user(p_user_id INTEGER)
RETURNS SETOF mdl_grade_grades AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_grade_grades
    WHERE userid = p_user_id
    ORDER BY itemid;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para inscripciones
-- =============================================

-- Obtener inscripciones por curso
CREATE OR REPLACE FUNCTION get_enrollments_by_course(p_course_id INTEGER)
RETURNS SETOF mdl_user_enrolments AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_user_enrolments
    WHERE courseid = p_course_id
    ORDER BY id;
END;
$$ LANGUAGE plpgsql;

-- Obtener inscripciones por usuario (con datos del curso)
CREATE OR REPLACE FUNCTION get_enrollments_by_user(p_user_id INTEGER)
RETURNS TABLE (
    id INTEGER,
    enrolid INTEGER,
    userid INTEGER,
    courseid INTEGER,
    status INTEGER,
    timestart TIMESTAMP,
    timeend TIMESTAMP,
    timecreated TIMESTAMP,
    timemodified TIMESTAMP,
    -- Campos del curso
    course_id INTEGER,
    category INTEGER,
    sortorder INTEGER,
    fullname TEXT,
    shortname TEXT,
    idnumber TEXT,
    summary TEXT,
    format TEXT,
    startdate TIMESTAMP,
    enddate TIMESTAMP,
    visible BOOLEAN,
    course_timecreated TIMESTAMP,
    course_timemodified TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id, 
        e.enrolid, 
        e.userid, 
        e.courseid, 
        e.status, 
        e.timestart, 
        e.timeend, 
        e.timecreated, 
        e.timemodified,
        c.id,
        c.category,
        c.sortorder,
        c.fullname,
        c.shortname,
        c.idnumber,
        c.summary,
        c.format,
        c.startdate,
        c.enddate,
        c.visible,
        c.timecreated,
        c.timemodified
    FROM mdl_user_enrolments e
    JOIN mdl_course c ON e.courseid = c.id
    WHERE e.userid = p_user_id
    ORDER BY e.id;
END;
$$ LANGUAGE plpgsql;

-- Crear una inscripción
CREATE OR REPLACE FUNCTION create_enrollment(
    p_enrolid INTEGER,
    p_userid INTEGER,
    p_courseid INTEGER,
    p_status INTEGER,
    p_timestart TIMESTAMP,
    p_timeend TIMESTAMP
)
RETURNS SETOF mdl_user_enrolments AS $$
DECLARE
    v_now TIMESTAMP := NOW();
BEGIN
    RETURN QUERY
    INSERT INTO mdl_user_enrolments(
        enrolid,
        userid,
        courseid,
        status,
        timestart,
        timeend,
        timecreated,
        timemodified
    )
    VALUES (
        p_enrolid,
        p_userid,
        p_courseid,
        p_status,
        p_timestart,
        p_timeend,
        v_now,
        v_now
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- Actualizar una inscripción
CREATE OR REPLACE FUNCTION update_enrollment(
    p_enrollment_id INTEGER,
    p_enrolid INTEGER,
    p_status INTEGER,
    p_timestart TIMESTAMP,
    p_timeend TIMESTAMP
)
RETURNS SETOF mdl_user_enrolments AS $$
BEGIN
    RETURN QUERY
    UPDATE mdl_user_enrolments
    SET enrolid = p_enrolid,
        status = p_status,
        timestart = p_timestart,
        timeend = p_timeend,
        timemodified = NOW()
    WHERE id = p_enrollment_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- Eliminar una inscripción
CREATE OR REPLACE FUNCTION delete_enrollment(p_enrollment_id INTEGER)
RETURNS SETOF mdl_user_enrolments AS $$
DECLARE
    v_enrollment mdl_user_enrolments;
BEGIN
    -- Guardar datos antes de eliminar
    SELECT * INTO v_enrollment FROM mdl_user_enrolments WHERE id = p_enrollment_id;
    
    -- Eliminar
    DELETE FROM mdl_user_enrolments WHERE id = p_enrollment_id;
    
    -- Devolver los datos eliminados
    RETURN NEXT v_enrollment;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para completados de curso
-- =============================================

-- Obtener completados por curso
CREATE OR REPLACE FUNCTION get_completions_by_course(p_course_id INTEGER)
RETURNS SETOF mdl_course_completions AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_course_completions
    WHERE course = p_course_id
    ORDER BY userid;
END;
$$ LANGUAGE plpgsql;

-- Obtener completados por usuario
CREATE OR REPLACE FUNCTION get_completions_by_user(p_user_id INTEGER)
RETURNS SETOF mdl_course_completions AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM mdl_course_completions
    WHERE userid = p_user_id
    ORDER BY course;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para cursos
-- =============================================

-- Crear un curso
CREATE OR REPLACE FUNCTION create_course(
    p_category INTEGER,
    p_sortorder INTEGER,
    p_fullname TEXT,
    p_shortname TEXT,
    p_idnumber TEXT,
    p_summary TEXT,
    p_format TEXT,
    p_startdate TIMESTAMP,
    p_enddate TIMESTAMP,
    p_visible BOOLEAN
)
RETURNS SETOF mdl_course AS $$
DECLARE
    v_now TIMESTAMP := NOW();
BEGIN
    RETURN QUERY
    INSERT INTO mdl_course(
        category,
        sortorder,
        fullname,
        shortname,
        idnumber,
        summary,
        format,
        startdate,
        enddate,
        visible,
        timecreated,
        timemodified
    )
    VALUES (
        p_category,
        p_sortorder,
        p_fullname,
        p_shortname,
        p_idnumber,
        p_summary,
        p_format,
        p_startdate,
        p_enddate,
        p_visible,
        v_now,
        v_now
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- Actualizar un curso
CREATE OR REPLACE FUNCTION update_course(
    p_course_id INTEGER,
    p_category INTEGER,
    p_sortorder INTEGER,
    p_fullname TEXT,
    p_shortname TEXT,
    p_idnumber TEXT,
    p_summary TEXT,
    p_format TEXT,
    p_startdate TIMESTAMP,
    p_enddate TIMESTAMP,
    p_visible BOOLEAN
)
RETURNS SETOF mdl_course AS $$
BEGIN
    RETURN QUERY
    UPDATE mdl_course
    SET category = p_category,
        sortorder = p_sortorder,
        fullname = p_fullname,
        shortname = p_shortname,
        idnumber = p_idnumber,
        summary = p_summary,
        format = p_format,
        startdate = p_startdate,
        enddate = p_enddate,
        visible = p_visible,
        timemodified = NOW()
    WHERE id = p_course_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Procedimientos para secciones
-- =============================================

-- Crear una sección
CREATE OR REPLACE FUNCTION create_section(
    p_course INTEGER,
    p_name TEXT,
    p_summary TEXT,
    p_sequence TEXT,
    p_visible BOOLEAN
)
RETURNS SETOF mdl_course_sections AS $$
DECLARE
    v_section_count INTEGER;
    v_new_section_number INTEGER;
BEGIN
    -- Obtener el número actual de secciones
    SELECT COUNT(*) INTO v_section_count FROM mdl_course_sections WHERE course = p_course;
    
    -- Asignar un nuevo número de sección
    v_new_section_number := v_section_count + 1;
    
    RETURN QUERY
    INSERT INTO mdl_course_sections(
        course,
        section,
        name,
        summary,
        sequence,
        visible,
        timemodified
    )
    VALUES (
        p_course,
        v_new_section_number,
        p_name,
        p_summary,
        p_sequence,
        p_visible,
        NOW()
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- Actualizar una sección
CREATE OR REPLACE FUNCTION update_section(
    p_section_id INTEGER,
    p_name TEXT,
    p_summary TEXT,
    p_sequence TEXT,
    p_visible BOOLEAN
)
RETURNS SETOF mdl_course_sections AS $$
BEGIN
    RETURN QUERY
    UPDATE mdl_course_sections
    SET name = p_name,
        summary = p_summary,
        sequence = p_sequence,
        visible = p_visible,
        timemodified = NOW()
    WHERE id = p_section_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- Eliminar una sección
CREATE OR REPLACE FUNCTION delete_section(p_section_id INTEGER)
RETURNS SETOF mdl_course_sections AS $$
DECLARE
    v_section mdl_course_sections;
BEGIN
    -- Guardar datos antes de eliminar
    SELECT * INTO v_section FROM mdl_course_sections WHERE id = p_section_id;
    
    -- Eliminar
    DELETE FROM mdl_course_sections WHERE id = p_section_id;
    
    -- Devolver los datos eliminados
    RETURN NEXT v_section;
    RETURN;
END;
$$ LANGUAGE plpgsql;
