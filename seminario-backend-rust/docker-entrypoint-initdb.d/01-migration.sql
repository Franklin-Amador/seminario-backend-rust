-- CreateTable
CREATE TABLE "mdl_user" (
    "id" SERIAL NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "firstname" TEXT NOT NULL,
    "lastname" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "auth" TEXT NOT NULL DEFAULT 'manual',
    "confirmed" BOOLEAN NOT NULL DEFAULT false,
    "lang" TEXT NOT NULL DEFAULT 'es',
    "timezone" TEXT NOT NULL DEFAULT '99',
    "firstaccess" TIMESTAMP(3),
    "lastaccess" TIMESTAMP(3),
    "lastlogin" TIMESTAMP(3),
    "currentlogin" TIMESTAMP(3),
    "deleted" BOOLEAN NOT NULL DEFAULT false,
    "suspended" BOOLEAN NOT NULL DEFAULT false,
    "mnethostid" INTEGER NOT NULL DEFAULT 1,
    "institution" TEXT,
    "department" TEXT,
    "timecreated" TIMESTAMP(3) NOT NULL,
    "timemodified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "mdl_user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_course" (
    "id" SERIAL NOT NULL,
    "category" INTEGER NOT NULL,
    "sortorder" INTEGER NOT NULL,
    "fullname" TEXT NOT NULL,
    "shortname" TEXT NOT NULL,
    "idnumber" TEXT,
    "summary" TEXT,
    "format" TEXT NOT NULL DEFAULT 'topics',
    "showgrades" BOOLEAN NOT NULL DEFAULT true,
    "newsitems" INTEGER NOT NULL DEFAULT 5,
    "startdate" TIMESTAMP(3) NOT NULL,
    "enddate" TIMESTAMP(3),
    "visible" BOOLEAN NOT NULL DEFAULT true,
    "groupmode" INTEGER NOT NULL DEFAULT 0,
    "timecreated" TIMESTAMP(3) NOT NULL,
    "timemodified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "mdl_course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_course_categories" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "idnumber" TEXT,
    "description" TEXT,
    "parent" INTEGER NOT NULL DEFAULT 0,
    "sortorder" INTEGER NOT NULL,
    "coursecount" INTEGER NOT NULL DEFAULT 0,
    "visible" BOOLEAN NOT NULL DEFAULT true,
    "visibleold" BOOLEAN NOT NULL DEFAULT true,
    "timemodified" TIMESTAMP(3) NOT NULL,
    "depth" INTEGER NOT NULL,
    "path" TEXT NOT NULL,
    "theme" TEXT,

    CONSTRAINT "mdl_course_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_course_category_map" (
    "category" INTEGER NOT NULL,
    "course" INTEGER NOT NULL,

    CONSTRAINT "mdl_course_category_map_pkey" PRIMARY KEY ("category","course")
);

-- CreateTable
CREATE TABLE "mdl_course_sections" (
    "id" SERIAL NOT NULL,
    "course" INTEGER NOT NULL,
    "section" INTEGER NOT NULL,
    "name" TEXT,
    "summary" TEXT,
    "sequence" TEXT,
    "visible" BOOLEAN NOT NULL DEFAULT true,
    "availability" TEXT,
    "timemodified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "mdl_course_sections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_modules" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "cron" INTEGER NOT NULL DEFAULT 0,
    "lastcron" TIMESTAMP(3),
    "search" TEXT,
    "visible" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "mdl_modules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_course_modules" (
    "id" SERIAL NOT NULL,
    "course" INTEGER NOT NULL,
    "module" INTEGER NOT NULL,
    "instance" INTEGER NOT NULL,
    "section" INTEGER NOT NULL,
    "idnumber" TEXT,
    "added" TIMESTAMP(3) NOT NULL,
    "score" INTEGER NOT NULL DEFAULT 0,
    "indent" INTEGER NOT NULL DEFAULT 0,
    "visible" BOOLEAN NOT NULL DEFAULT true,
    "visibleoncoursepage" BOOLEAN NOT NULL DEFAULT true,
    "visibleold" BOOLEAN NOT NULL DEFAULT true,
    "groupmode" INTEGER NOT NULL DEFAULT 0,
    "groupingid" INTEGER NOT NULL DEFAULT 0,
    "completion" INTEGER NOT NULL DEFAULT 0,
    "completiongradeitemnumber" INTEGER,
    "completionview" BOOLEAN NOT NULL DEFAULT false,
    "completionexpected" TIMESTAMP(3),
    "availability" TEXT,
    "showdescription" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "mdl_course_modules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_role" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "shortname" TEXT NOT NULL,
    "description" TEXT,
    "sortorder" INTEGER NOT NULL,
    "archetype" TEXT,

    CONSTRAINT "mdl_role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_role_assignments" (
     "id" SERIAL NOT NULL,
        "roleid" INTEGER NOT NULL,
        "contextid" INTEGER NOT NULL,
        "userid" INTEGER NOT NULL,
        "timemodified" TIMESTAMP(3) NOT NULL,
        "modifierid" INTEGER NOT NULL,
        "component" TEXT,
        "itemid" INTEGER NOT NULL DEFAULT 0,
        "sortorder" INTEGER NOT NULL DEFAULT 0,

        CONSTRAINT "mdl_role_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_user_enrolments" (
    "id" SERIAL NOT NULL,
    "enrolid" INTEGER NOT NULL,
    "userid" INTEGER NOT NULL,
    "courseid" INTEGER NOT NULL,
    "status" INTEGER NOT NULL DEFAULT 0,
    "timestart" TIMESTAMP(3),
    "timeend" TIMESTAMP(3),
    "timecreated" TIMESTAMP(3) NOT NULL,
    "timemodified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "mdl_user_enrolments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_assign" (
    "id" SERIAL NOT NULL,
    "course" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "intro" TEXT NOT NULL,
    "introformat" INTEGER NOT NULL DEFAULT 0,
    "section" INTEGER NOT NULL,
    "alwaysshowdescription" BOOLEAN NOT NULL DEFAULT true,
    "nosubmissions" BOOLEAN NOT NULL DEFAULT false,
    "submissiondrafts" BOOLEAN NOT NULL DEFAULT false,
    "sendnotifications" BOOLEAN NOT NULL DEFAULT false,
    "sendlatenotifications" BOOLEAN NOT NULL DEFAULT false,
    "duedate" TIMESTAMP(3),
    "allowsubmissionsfromdate" TIMESTAMP(3),
    "grade" INTEGER,
    "timemodified" TIMESTAMP(3) NOT NULL,
    "requiresubmissionstatement" BOOLEAN NOT NULL DEFAULT false,
    "completionsubmit" BOOLEAN NOT NULL DEFAULT false,
    "cutoffdate" TIMESTAMP(3),
    "gradingduedate" TIMESTAMP(3),
    "teamsubmission" BOOLEAN NOT NULL DEFAULT false,
    "requireallteammemberssubmit" BOOLEAN NOT NULL DEFAULT false,
    "teamsubmissiongroupingid" INTEGER NOT NULL DEFAULT 0,
    "blindmarking" BOOLEAN NOT NULL DEFAULT false,
    "revealidentities" BOOLEAN NOT NULL DEFAULT false,
    "attemptreopenmethod" TEXT NOT NULL DEFAULT 'none',
    "maxattempts" INTEGER NOT NULL DEFAULT -1,
    "markingworkflow" BOOLEAN NOT NULL DEFAULT false,
    "markingallocation" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "mdl_assign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_assign_submission" (
    "id" SERIAL NOT NULL,
    "assignment" INTEGER NOT NULL,
    "userid" INTEGER NOT NULL,
    "timecreated" TIMESTAMP(3) NOT NULL,
    "timemodified" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL,
    "groupid" INTEGER NOT NULL DEFAULT 0,
    "attemptnumber" INTEGER NOT NULL DEFAULT 0,
    "latest" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "mdl_assign_submission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_quiz" (
    "id" SERIAL NOT NULL,
    "course" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "intro" TEXT NOT NULL,
    "introformat" INTEGER NOT NULL DEFAULT 0,
    "timeopen" TIMESTAMP(3),
    "timeclose" TIMESTAMP(3),
    "timelimit" INTEGER,
    "preferredbehaviour" TEXT NOT NULL,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "grademethod" INTEGER NOT NULL DEFAULT 1,
    "decimalpoints" INTEGER NOT NULL DEFAULT 2,
    "questiondecimalpoints" INTEGER NOT NULL DEFAULT -1,
    "sumgrades" INTEGER NOT NULL DEFAULT 0,
    "grade" INTEGER NOT NULL DEFAULT 0,
    "timecreated" TIMESTAMP(3) NOT NULL,
    "timemodified" TIMESTAMP(3) NOT NULL,
    "password" TEXT,
    "subnet" TEXT,
    "browsersecurity" TEXT,
    "delay1" INTEGER NOT NULL DEFAULT 0,
    "delay2" INTEGER NOT NULL DEFAULT 0,
    "showuserpicture" INTEGER NOT NULL DEFAULT 0,
    "showblocks" INTEGER NOT NULL DEFAULT 0,
    "navmethod" TEXT NOT NULL DEFAULT 'free',
    "shuffleanswers" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "mdl_quiz_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_course_completions" (
    "id" SERIAL NOT NULL,
    "userid" INTEGER NOT NULL,
    "course" INTEGER NOT NULL,
    "timeenrolled" TIMESTAMP(3) NOT NULL,
    "timestarted" TIMESTAMP(3) NOT NULL,
    "timecompleted" TIMESTAMP(3),
    "reaggregate" TIMESTAMP(3),

    CONSTRAINT "mdl_course_completions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_forum" (
    "id" SERIAL NOT NULL,
    "course" INTEGER NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'general',
    "name" TEXT NOT NULL,
    "intro" TEXT NOT NULL,
    "introformat" INTEGER NOT NULL DEFAULT 0,
    "assessed" INTEGER NOT NULL DEFAULT 0,
    "assesstimestart" TIMESTAMP(3),
    "assesstimefinish" TIMESTAMP(3),
    "scale" INTEGER NOT NULL DEFAULT 0,
    "maxbytes" INTEGER NOT NULL DEFAULT 0,
    "maxattachments" INTEGER NOT NULL DEFAULT 1,
    "forcesubscribe" INTEGER NOT NULL DEFAULT 0,
    "trackingtype" INTEGER NOT NULL DEFAULT 1,
    "rsstype" INTEGER NOT NULL DEFAULT 0,
    "rssarticles" INTEGER NOT NULL DEFAULT 0,
    "timemodified" TIMESTAMP(3) NOT NULL,
    "warnafter" INTEGER NOT NULL DEFAULT 0,
    "blockafter" INTEGER NOT NULL DEFAULT 0,
    "blockperiod" INTEGER NOT NULL DEFAULT 0,
    "completiondiscussions" INTEGER NOT NULL DEFAULT 0,
    "completionreplies" INTEGER NOT NULL DEFAULT 0,
    "completionposts" INTEGER NOT NULL DEFAULT 0,
    "displaywordcount" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "mdl_forum_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_forum_discussions" (
    "id" SERIAL NOT NULL,
    "course" INTEGER NOT NULL,
    "forum" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "firstpost" INTEGER NOT NULL,
    "userid" INTEGER NOT NULL,
    "groupid" INTEGER NOT NULL DEFAULT -1,
    "assessed" BOOLEAN NOT NULL DEFAULT true,
    "timemodified" TIMESTAMP(3) NOT NULL,
    "usermodified" INTEGER NOT NULL DEFAULT 0,
    "timestart" TIMESTAMP(3),
    "timeend" TIMESTAMP(3),
    "pinned" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "mdl_forum_discussions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_forum_posts" (
    "id" SERIAL NOT NULL,
    "discussion" INTEGER NOT NULL,
    "parent" INTEGER NOT NULL DEFAULT 0,
    "userid" INTEGER NOT NULL,
    "created" TIMESTAMP(3) NOT NULL,
    "modified" TIMESTAMP(3) NOT NULL,
    "mailed" INTEGER NOT NULL DEFAULT 0,
    "subject" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "messageformat" INTEGER NOT NULL DEFAULT 0,
    "messagetrust" INTEGER NOT NULL DEFAULT 0,
    "attachment" TEXT,
    "totalscore" INTEGER NOT NULL DEFAULT 0,
    "mailnow" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "mdl_forum_posts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_grade_items" (
    "id" SERIAL NOT NULL,
    "courseid" INTEGER NOT NULL,
    "categoryid" INTEGER,
    "itemname" TEXT,
    "itemtype" TEXT NOT NULL,
    "itemmodule" TEXT,
    "iteminstance" INTEGER,
    "itemnumber" INTEGER,
    "iteminfo" TEXT,
    "idnumber" TEXT,
    "calculation" TEXT,
    "gradetype" INTEGER NOT NULL DEFAULT 1,
    "grademax" DECIMAL(10,5) NOT NULL DEFAULT 100,
    "grademin" DECIMAL(10,5) NOT NULL DEFAULT 0,
    "scaleid" INTEGER,
    "outcomeid" INTEGER,
    "gradepass" DECIMAL(10,5) NOT NULL DEFAULT 0,
    "multfactor" DECIMAL(10,5) NOT NULL DEFAULT 1,
    "plusfactor" DECIMAL(10,5) NOT NULL DEFAULT 0,
    "aggregationcoef" DECIMAL(10,5) NOT NULL DEFAULT 0,
    "aggregationcoef2" DECIMAL(10,5) NOT NULL DEFAULT 0,
    "sortorder" INTEGER NOT NULL DEFAULT 0,
    "display" INTEGER NOT NULL DEFAULT 0,
    "decimals" INTEGER,
    "hidden" INTEGER NOT NULL DEFAULT 0,
    "locked" INTEGER NOT NULL DEFAULT 0,
    "locktime" TIMESTAMP(3),
    "needsupdate" INTEGER NOT NULL DEFAULT 0,
    "weightoverride" INTEGER NOT NULL DEFAULT 0,
    "timecreated" TIMESTAMP(3) NOT NULL,
    "timemodified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "mdl_grade_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_grade_grades" (
    "id" SERIAL NOT NULL,
    "itemid" INTEGER NOT NULL,
    "userid" INTEGER NOT NULL,
    "rawgrade" INTEGER,
    "rawgrademax" INTEGER NOT NULL DEFAULT 100,
    "rawgrademin" INTEGER NOT NULL DEFAULT 0,
    "finalgrade" INTEGER,
    "hidden" INTEGER NOT NULL DEFAULT 0,
    "locked" INTEGER NOT NULL DEFAULT 0,
    "locktime" TIMESTAMP(3),
    "exported" INTEGER NOT NULL DEFAULT 0,
    "overridden" INTEGER NOT NULL DEFAULT 0,
    "excluded" INTEGER NOT NULL DEFAULT 0,
    "feedback" TEXT,
    "feedbackformat" INTEGER NOT NULL DEFAULT 0,
    "information" TEXT,
    "informationformat" INTEGER NOT NULL DEFAULT 0,
    "timecreated" TIMESTAMP(3) NOT NULL,
    "timemodified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "mdl_grade_grades_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_resource" (
    "id" SERIAL NOT NULL,
    "course" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "intro" TEXT,
    "introformat" INTEGER NOT NULL DEFAULT 0,
    "tobemigrated" INTEGER NOT NULL DEFAULT 0,
    "legacyfiles" INTEGER NOT NULL DEFAULT 0,
    "legacyfileslast" INTEGER,
    "display" INTEGER NOT NULL DEFAULT 0,
    "displayoptions" TEXT,
    "filterfiles" INTEGER NOT NULL DEFAULT 0,
    "revision" INTEGER NOT NULL DEFAULT 0,
    "timemodified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "mdl_resource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mdl_scorm" (
    "id" SERIAL NOT NULL,
    "course" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "scormtype" TEXT NOT NULL DEFAULT 'local',
    "reference" TEXT NOT NULL,
    "intro" TEXT NOT NULL,
    "introformat" INTEGER NOT NULL DEFAULT 0,
    "version" TEXT NOT NULL,
    "maxgrade" INTEGER NOT NULL DEFAULT 0,
    "grademethod" INTEGER NOT NULL DEFAULT 0,
    "whatgrade" INTEGER NOT NULL DEFAULT 0,
    "maxattempt" INTEGER NOT NULL DEFAULT 1,
    "forcecompleted" BOOLEAN NOT NULL DEFAULT false,
    "forcenewattempt" INTEGER NOT NULL DEFAULT 0,
    "lastattemptlock" BOOLEAN NOT NULL DEFAULT false,
    "masteryoverride" BOOLEAN NOT NULL DEFAULT true,
    "displayattemptstatus" INTEGER NOT NULL DEFAULT 1,
    "displaycoursestructure" BOOLEAN NOT NULL DEFAULT false,
    "updatefreq" INTEGER NOT NULL DEFAULT 0,
    "sha1hash" TEXT,
    "md5hash" TEXT,
    "revision" INTEGER NOT NULL DEFAULT 0,
    "launch" INTEGER NOT NULL DEFAULT 0,
    "skipview" INTEGER NOT NULL DEFAULT 1,
    "hidebrowse" BOOLEAN NOT NULL DEFAULT false,
    "hidetoc" INTEGER NOT NULL DEFAULT 0,
    "nav" INTEGER NOT NULL DEFAULT 1,
    "navpositionleft" INTEGER,
    "navpositiontop" INTEGER,
    "auto" BOOLEAN NOT NULL DEFAULT false,
    "popup" BOOLEAN NOT NULL DEFAULT false,
    "width" INTEGER NOT NULL DEFAULT 100,
    "height" INTEGER NOT NULL DEFAULT 600,
    "timeopen" TIMESTAMP(3),
    "timeclose" TIMESTAMP(3),
    "timemodified" TIMESTAMP(3) NOT NULL,
    "completionstatusrequired" INTEGER,
    "completionscorerequired" INTEGER,
    "completionstatusallscos" INTEGER,
    "autocommit" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "mdl_scorm_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "mdl_user_username_key" ON "mdl_user"("username");

-- CreateIndex
CREATE UNIQUE INDEX "mdl_user_email_key" ON "mdl_user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "mdl_modules_name_key" ON "mdl_modules"("name");

-- CreateIndex
CREATE UNIQUE INDEX "mdl_role_shortname_key" ON "mdl_role"("shortname");

-- AddForeignKey
ALTER TABLE "mdl_course_category_map" ADD CONSTRAINT "mdl_course_category_map_category_fkey" FOREIGN KEY ("category") REFERENCES "mdl_course_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_course_category_map" ADD CONSTRAINT "mdl_course_category_map_course_fkey" FOREIGN KEY ("course") REFERENCES "mdl_course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_course_sections" ADD CONSTRAINT "mdl_course_sections_course_fkey" FOREIGN KEY ("course") REFERENCES "mdl_course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_course_modules" ADD CONSTRAINT "mdl_course_modules_course_fkey" FOREIGN KEY ("course") REFERENCES "mdl_course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_course_modules" ADD CONSTRAINT "mdl_course_modules_module_fkey" FOREIGN KEY ("module") REFERENCES "mdl_modules"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_role_assignments" ADD CONSTRAINT "mdl_role_assignments_roleid_fkey" FOREIGN KEY ("roleid") REFERENCES "mdl_role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_role_assignments" ADD CONSTRAINT "mdl_role_assignments_userid_fkey" FOREIGN KEY ("userid") REFERENCES "mdl_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_user_enrolments" ADD CONSTRAINT "mdl_user_enrolments_userid_fkey" FOREIGN KEY ("userid") REFERENCES "mdl_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_user_enrolments" ADD CONSTRAINT "mdl_user_enrolments_courseid_fkey" FOREIGN KEY ("courseid") REFERENCES "mdl_course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_assign_submission" ADD CONSTRAINT "mdl_assign_submission_assignment_fkey" FOREIGN KEY ("assignment") REFERENCES "mdl_assign"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_assign_submission" ADD CONSTRAINT "mdl_assign_submission_userid_fkey" FOREIGN KEY ("userid") REFERENCES "mdl_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_course_completions" ADD CONSTRAINT "mdl_course_completions_userid_fkey" FOREIGN KEY ("userid") REFERENCES "mdl_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_course_completions" ADD CONSTRAINT "mdl_course_completions_course_fkey" FOREIGN KEY ("course") REFERENCES "mdl_course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_forum_discussions" ADD CONSTRAINT "mdl_forum_discussions_forum_fkey" FOREIGN KEY ("forum") REFERENCES "mdl_forum"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_forum_posts" ADD CONSTRAINT "mdl_forum_posts_discussion_fkey" FOREIGN KEY ("discussion") REFERENCES "mdl_forum_discussions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mdl_grade_grades" ADD CONSTRAINT "mdl_grade_grades_itemid_fkey" FOREIGN KEY ("itemid") REFERENCES "mdl_grade_items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "mdl_assign" ADD CONSTRAINT "mdl_assign_section_fkey" FOREIGN KEY ("section") REFERENCES "mdl_course_sections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- Inserta los roles si no existen
INSERT INTO "mdl_role" ("name", "shortname", "description", "sortorder", "archetype")
VALUES 
    ('Administrador', 'admin', 'Rol para los administradores', 1, 'manager'),
    ('Maestro', 'teacher', 'Rol para los docentes', 2, 'teacher'),
    ('Estudiante', 'student', 'Rol para los estudiantes', 3, 'student')
ON CONFLICT ("shortname") DO NOTHING;

-- Inserción de categorías de cursos (si no existe)
INSERT INTO "mdl_course_categories" ("name", "description", "parent", "sortorder", "visible", "visibleold", "timemodified", "depth", "path")
SELECT 'Ingeniería en Sistemas', 'Departamento de Ingeniería en Sistemas', 0, 1, true, true, CURRENT_TIMESTAMP, 1, '/1'
WHERE NOT EXISTS (
    SELECT 1 FROM "mdl_course_categories" WHERE "name" = 'Ingeniería en Sistemas'
);

-- Inserción de cursos (si no existen)
INSERT INTO "mdl_course" ("category", "sortorder", "fullname", "shortname", "summary", "format", "startdate", "visible", "timecreated", "timemodified")
SELECT 1, 1, 'Programación Orientada a Objetos', 'POO', 'Curso de Programación Orientada a Objetos', 'topics', CURRENT_TIMESTAMP, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (
    SELECT 1 FROM "mdl_course" WHERE "shortname" = 'POO'
);

INSERT INTO "mdl_course" ("category", "sortorder", "fullname", "shortname", "summary", "format", "startdate", "visible", "timecreated", "timemodified")
SELECT 1, 2, 'Ingeniería de Software', 'IS', 'Curso de Ingeniería de Software', 'topics', CURRENT_TIMESTAMP, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (
    SELECT 1 FROM "mdl_course" WHERE "shortname" = 'IS'
);

-- Obtener IDs de usuarios existentes (para verificar si existen antes de insertar)
DO $$
DECLARE
    admin_exists BOOLEAN;
    claude_exists BOOLEAN;
    frank_exists BOOLEAN;
    edwar_exists BOOLEAN;
    daniel_exists BOOLEAN;
    elvis_exists BOOLEAN;
    
    admin_id INTEGER;
    claude_id INTEGER;
    frank_id INTEGER;
    edwar_id INTEGER;
    daniel_id INTEGER;
    elvis_id INTEGER;
    
    poo_id INTEGER;
    is_id INTEGER;
BEGIN
    -- Verificar si los usuarios existen
    SELECT EXISTS(SELECT 1 FROM "mdl_user" WHERE "username" = 'admin') INTO admin_exists;
    SELECT EXISTS(SELECT 1 FROM "mdl_user" WHERE "username" = 'claude') INTO claude_exists;
    SELECT EXISTS(SELECT 1 FROM "mdl_user" WHERE "username" = 'frank') INTO frank_exists;
    SELECT EXISTS(SELECT 1 FROM "mdl_user" WHERE "username" = 'edwar') INTO edwar_exists;
    SELECT EXISTS(SELECT 1 FROM "mdl_user" WHERE "username" = 'daniel') INTO daniel_exists;
    SELECT EXISTS(SELECT 1 FROM "mdl_user" WHERE "username" = 'elvis') INTO elvis_exists;
    
    -- Insertar usuarios solo si no existen
    IF NOT admin_exists THEN
        INSERT INTO "mdl_user" ("username", "password", "firstname", "lastname", "email", "auth", "confirmed", "lang", "timezone", "institution", "department", "timecreated", "timemodified")
        VALUES ('admin', '1234', 'Administrador', 'Sistema', 'admin@unah.edu.hn', 'manual', true, 'es', '99', 'UNAH', 'IS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT claude_exists THEN
        INSERT INTO "mdl_user" ("username", "password", "firstname", "lastname", "email", "auth", "confirmed", "lang", "timezone", "institution", "department", "timecreated", "timemodified")
        VALUES ('claude', '1234', 'Claude', 'Docente', 'claude@unah.edu.hn', 'manual', true, 'es', '99', 'UNAH', 'IS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT frank_exists THEN
        INSERT INTO "mdl_user" ("username", "password", "firstname", "lastname", "email", "auth", "confirmed", "lang", "timezone", "institution", "department", "timecreated", "timemodified")
        VALUES ('frank', '1234', 'Frank', 'Estudiante', 'frank@unah.edu.hn', 'manual', true, 'es', '99', 'UNAH', 'IS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT edwar_exists THEN
        INSERT INTO "mdl_user" ("username", "password", "firstname", "lastname", "email", "auth", "confirmed", "lang", "timezone", "institution", "department", "timecreated", "timemodified")
        VALUES ('edwar', '1234', 'Edwar', 'Estudiante', 'edwar@unah.edu.hn', 'manual', true, 'es', '99', 'UNAH', 'IS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT daniel_exists THEN
        INSERT INTO "mdl_user" ("username", "password", "firstname", "lastname", "email", "auth", "confirmed", "lang", "timezone", "institution", "department", "timecreated", "timemodified")
        VALUES ('daniel', '1234', 'Daniel', 'Estudiante', 'daniel@unah.edu.hn', 'manual', true, 'es', '99', 'UNAH', 'IS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT elvis_exists THEN
        INSERT INTO "mdl_user" ("username", "password", "firstname", "lastname", "email", "auth", "confirmed", "lang", "timezone", "institution", "department", "timecreated", "timemodified")
        VALUES ('elvis', '1234', 'Elvis', 'Estudiante', 'elvis@unah.edu.hn', 'manual', true, 'es', '99', 'UNAH', 'IS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Obtener IDs de usuarios
    SELECT id INTO admin_id FROM "mdl_user" WHERE "username" = 'admin';
    SELECT id INTO claude_id FROM "mdl_user" WHERE "username" = 'claude';
    SELECT id INTO frank_id FROM "mdl_user" WHERE "username" = 'frank';
    SELECT id INTO edwar_id FROM "mdl_user" WHERE "username" = 'edwar';
    SELECT id INTO daniel_id FROM "mdl_user" WHERE "username" = 'daniel';
    SELECT id INTO elvis_id FROM "mdl_user" WHERE "username" = 'elvis';
    
    -- Obtener IDs de cursos
    SELECT id INTO poo_id FROM "mdl_course" WHERE "shortname" = 'POO';
    SELECT id INTO is_id FROM "mdl_course" WHERE "shortname" = 'IS';
    
    -- Insertar módulos si no existen
    INSERT INTO "mdl_modules" ("name", "cron", "visible")
    SELECT 'assign', 0, true
    WHERE NOT EXISTS (SELECT 1 FROM "mdl_modules" WHERE "name" = 'assign');
    
    INSERT INTO "mdl_modules" ("name", "cron", "visible")
    SELECT 'forum', 0, true
    WHERE NOT EXISTS (SELECT 1 FROM "mdl_modules" WHERE "name" = 'forum');
    
    INSERT INTO "mdl_modules" ("name", "cron", "visible")
    SELECT 'resource', 0, true
    WHERE NOT EXISTS (SELECT 1 FROM "mdl_modules" WHERE "name" = 'resource');
    
    INSERT INTO "mdl_modules" ("name", "cron", "visible")
    SELECT 'quiz', 0, true
    WHERE NOT EXISTS (SELECT 1 FROM "mdl_modules" WHERE "name" = 'quiz');
    
    -- Asignar roles a los usuarios (si no están asignados)
    -- Admin
    IF NOT EXISTS (SELECT 1 FROM "mdl_role_assignments" WHERE "userid" = admin_id AND "roleid" = 1) THEN
        INSERT INTO "mdl_role_assignments" ("roleid", "contextid", "userid", "timemodified", "modifierid")
        VALUES (1, 1, admin_id, CURRENT_TIMESTAMP, admin_id);
    END IF;
    
    -- Claude
    IF NOT EXISTS (SELECT 1 FROM "mdl_role_assignments" WHERE "userid" = claude_id AND "roleid" = 2) THEN
        INSERT INTO "mdl_role_assignments" ("roleid", "contextid", "userid", "timemodified", "modifierid")
        VALUES (2, 1, claude_id, CURRENT_TIMESTAMP, admin_id);
    END IF;
    
    -- Frank
    IF NOT EXISTS (SELECT 1 FROM "mdl_role_assignments" WHERE "userid" = frank_id AND "roleid" = 3) THEN
        INSERT INTO "mdl_role_assignments" ("roleid", "contextid", "userid", "timemodified", "modifierid")
        VALUES (3, 1, frank_id, CURRENT_TIMESTAMP, admin_id);
    END IF;
    
    -- Edwar
    IF NOT EXISTS (SELECT 1 FROM "mdl_role_assignments" WHERE "userid" = edwar_id AND "roleid" = 3) THEN
        INSERT INTO "mdl_role_assignments" ("roleid", "contextid", "userid", "timemodified", "modifierid")
        VALUES (3, 1, edwar_id, CURRENT_TIMESTAMP, admin_id);
    END IF;
    
    -- Daniel
    IF NOT EXISTS (SELECT 1 FROM "mdl_role_assignments" WHERE "userid" = daniel_id AND "roleid" = 3) THEN
        INSERT INTO "mdl_role_assignments" ("roleid", "contextid", "userid", "timemodified", "modifierid")
        VALUES (3, 1, daniel_id, CURRENT_TIMESTAMP, admin_id);
    END IF;
    
    -- Elvis
    IF NOT EXISTS (SELECT 1 FROM "mdl_role_assignments" WHERE "userid" = elvis_id AND "roleid" = 3) THEN
        INSERT INTO "mdl_role_assignments" ("roleid", "contextid", "userid", "timemodified", "modifierid")
        VALUES (3, 1, elvis_id, CURRENT_TIMESTAMP, admin_id);
    END IF;
    
    -- Crear tabla mdl_userrole si no existe (para Prisma)
    EXECUTE 'CREATE TABLE IF NOT EXISTS "mdl_userrole" (
        "id" SERIAL PRIMARY KEY,
        "userid" INTEGER NOT NULL,
        "roleid" INTEGER NOT NULL,
        "timemodified" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ("userid") REFERENCES "mdl_user"("id"),
        FOREIGN KEY ("roleid") REFERENCES "mdl_role"("id")
    )';
    
    -- Insertar relaciones usuario-rol en la tabla intermedia
    -- Admin
    IF NOT EXISTS (SELECT 1 FROM "mdl_userrole" WHERE "userid" = admin_id AND "roleid" = 1) THEN
        INSERT INTO "mdl_userrole" ("userid", "roleid")
        VALUES (admin_id, 1);
    END IF;
    
    -- Claude
    IF NOT EXISTS (SELECT 1 FROM "mdl_userrole" WHERE "userid" = claude_id AND "roleid" = 2) THEN
        INSERT INTO "mdl_userrole" ("userid", "roleid")
        VALUES (claude_id, 2);
    END IF;
    
    -- Frank
    IF NOT EXISTS (SELECT 1 FROM "mdl_userrole" WHERE "userid" = frank_id AND "roleid" = 3) THEN
        INSERT INTO "mdl_userrole" ("userid", "roleid")
        VALUES (frank_id, 3);
    END IF;
    
    -- Edwar
    IF NOT EXISTS (SELECT 1 FROM "mdl_userrole" WHERE "userid" = edwar_id AND "roleid" = 3) THEN
        INSERT INTO "mdl_userrole" ("userid", "roleid")
        VALUES (edwar_id, 3);
    END IF;
    
    -- Daniel
    IF NOT EXISTS (SELECT 1 FROM "mdl_userrole" WHERE "userid" = daniel_id AND "roleid" = 3) THEN
        INSERT INTO "mdl_userrole" ("userid", "roleid")
        VALUES (daniel_id, 3);
    END IF;
    
    -- Elvis
    IF NOT EXISTS (SELECT 1 FROM "mdl_userrole" WHERE "userid" = elvis_id AND "roleid" = 3) THEN
        INSERT INTO "mdl_userrole" ("userid", "roleid")
        VALUES (elvis_id, 3);
    END IF;
    
    -- Matricular estudiantes en cursos (si no están matriculados)
    -- Frank en POO
    IF NOT EXISTS (SELECT 1 FROM "mdl_user_enrolments" WHERE "userid" = frank_id AND "courseid" = poo_id) THEN
        INSERT INTO "mdl_user_enrolments" ("enrolid", "userid", "courseid", "status", "timecreated", "timemodified")
        VALUES (1, frank_id, poo_id, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Edwar en POO
    IF NOT EXISTS (SELECT 1 FROM "mdl_user_enrolments" WHERE "userid" = edwar_id AND "courseid" = poo_id) THEN
        INSERT INTO "mdl_user_enrolments" ("enrolid", "userid", "courseid", "status", "timecreated", "timemodified")
        VALUES (1, edwar_id, poo_id, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Daniel en POO
    IF NOT EXISTS (SELECT 1 FROM "mdl_user_enrolments" WHERE "userid" = daniel_id AND "courseid" = poo_id) THEN
        INSERT INTO "mdl_user_enrolments" ("enrolid", "userid", "courseid", "status", "timecreated", "timemodified")
        VALUES (1, daniel_id, poo_id, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Elvis en POO
    IF NOT EXISTS (SELECT 1 FROM "mdl_user_enrolments" WHERE "userid" = elvis_id AND "courseid" = poo_id) THEN
        INSERT INTO "mdl_user_enrolments" ("enrolid", "userid", "courseid", "status", "timecreated", "timemodified")
        VALUES (1, elvis_id, poo_id, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Frank en IS
    IF NOT EXISTS (SELECT 1 FROM "mdl_user_enrolments" WHERE "userid" = frank_id AND "courseid" = is_id) THEN
        INSERT INTO "mdl_user_enrolments" ("enrolid", "userid", "courseid", "status", "timecreated", "timemodified")
        VALUES (2, frank_id, is_id, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Edwar en IS
    IF NOT EXISTS (SELECT 1 FROM "mdl_user_enrolments" WHERE "userid" = edwar_id AND "courseid" = is_id) THEN
        INSERT INTO "mdl_user_enrolments" ("enrolid", "userid", "courseid", "status", "timecreated", "timemodified")
        VALUES (2, edwar_id, is_id, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Daniel en IS
    IF NOT EXISTS (SELECT 1 FROM "mdl_user_enrolments" WHERE "userid" = daniel_id AND "courseid" = is_id) THEN
        INSERT INTO "mdl_user_enrolments" ("enrolid", "userid", "courseid", "status", "timecreated", "timemodified")
        VALUES (2, daniel_id, is_id, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Elvis en IS
    IF NOT EXISTS (SELECT 1 FROM "mdl_user_enrolments" WHERE "userid" = elvis_id AND "courseid" = is_id) THEN
        INSERT INTO "mdl_user_enrolments" ("enrolid", "userid", "courseid", "status", "timecreated", "timemodified")
        VALUES (2, elvis_id, is_id, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Claude en POO
    IF NOT EXISTS (SELECT 1 FROM "mdl_user_enrolments" WHERE "userid" = claude_id AND "courseid" = poo_id) THEN
        INSERT INTO "mdl_user_enrolments" ("enrolid", "userid", "courseid", "status", "timecreated", "timemodified")
        VALUES (3, claude_id, poo_id, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Claude en IS
    IF NOT EXISTS (SELECT 1 FROM "mdl_user_enrolments" WHERE "userid" = claude_id AND "courseid" = is_id) THEN
        INSERT INTO "mdl_user_enrolments" ("enrolid", "userid", "courseid", "status", "timecreated", "timemodified")
        VALUES (4, claude_id, is_id, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    END IF;
    
    -- Crear secciones para los cursos (si no existen)
    -- POO
    IF NOT EXISTS (SELECT 1 FROM "mdl_course_sections" WHERE "course" = poo_id AND "section" = 0) THEN
        INSERT INTO "mdl_course_sections" ("course", "section", "name", "summary", "visible", "timemodified")
        VALUES (poo_id, 0, 'General', 'Sección general del curso', true, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "mdl_course_sections" WHERE "course" = poo_id AND "section" = 1) THEN
        INSERT INTO "mdl_course_sections" ("course", "section", "name", "summary", "visible", "timemodified")
        VALUES (poo_id, 1, 'Introducción a POO', 'Conceptos básicos de la programación orientada a objetos', true, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "mdl_course_sections" WHERE "course" = poo_id AND "section" = 2) THEN
        INSERT INTO "mdl_course_sections" ("course", "section", "name", "summary", "visible", "timemodified")
        VALUES (poo_id, 2, 'Clases y Objetos', 'Definición de clases y creación de objetos', true, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "mdl_course_sections" WHERE "course" = poo_id AND "section" = 3) THEN
        INSERT INTO "mdl_course_sections" ("course", "section", "name", "summary", "visible", "timemodified")
        VALUES (poo_id, 3, 'Herencia', 'Herencia y polimorfismo', true, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "mdl_course_sections" WHERE "course" = poo_id AND "section" = 4) THEN
        INSERT INTO "mdl_course_sections" ("course", "section", "name", "summary", "visible", "timemodified")
        VALUES (poo_id, 4, 'Interfaces', 'Interfaces y clases abstractas', true, CURRENT_TIMESTAMP);
    END IF;
    
    -- IS
    IF NOT EXISTS (SELECT 1 FROM "mdl_course_sections" WHERE "course" = is_id AND "section" = 0) THEN
        INSERT INTO "mdl_course_sections" ("course", "section", "name", "summary", "visible", "timemodified")
        VALUES (is_id, 0, 'General', 'Sección general del curso', true, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "mdl_course_sections" WHERE "course" = is_id AND "section" = 1) THEN
        INSERT INTO "mdl_course_sections" ("course", "section", "name", "summary", "visible", "timemodified")
        VALUES (is_id, 1, 'Fundamentos de IS', 'Introducción a la ingeniería de software', true, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "mdl_course_sections" WHERE "course" = is_id AND "section" = 2) THEN
        INSERT INTO "mdl_course_sections" ("course", "section", "name", "summary", "visible", "timemodified")
        VALUES (is_id, 2, 'Requerimientos', 'Análisis y especificación de requerimientos', true, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "mdl_course_sections" WHERE "course" = is_id AND "section" = 3) THEN
        INSERT INTO "mdl_course_sections" ("course", "section", "name", "summary", "visible", "timemodified")
        VALUES (is_id, 3, 'Diseño de Software', 'Principios y patrones de diseño', true, CURRENT_TIMESTAMP);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "mdl_course_sections" WHERE "course" = is_id AND "section" = 4) THEN
        INSERT INTO "mdl_course_sections" ("course", "section", "name", "summary", "visible", "timemodified")
        VALUES (is_id, 4, 'Pruebas', 'Metodologías de pruebas de software', true, CURRENT_TIMESTAMP);
    END IF;
END $$;


-- Archivo: seed_test_users.sql
-- Script para crear usuarios de prueba para benchmarking con Locust

-- Contraseña encriptada para '1234' usando bcrypt (hash fijo para pruebas)
-- En producción, cada usuario tendría un salt diferente
DO $$
DECLARE
    v_hashed_password TEXT := '$2b$12$Fh.KcXA9e5XA4XgYXjf/U.7e6g2pQS28O4.1XfUVTXCCcQqA5EBJO'; -- hash de '1234'
    v_first_names TEXT[] := ARRAY['Juan', 'María', 'Carlos', 'Ana', 'Luis', 'Elena', 'Pedro', 'Laura', 'Miguel', 'Sofía'];
    v_last_names TEXT[] := ARRAY['García', 'Rodríguez', 'Martínez', 'López', 'González', 'Pérez', 'Sánchez', 'Romero', 'Torres', 'Díaz'];
    v_first TEXT;
    v_last TEXT;
    v_current_time TIMESTAMP := NOW();
BEGIN
    -- Crear 10 usuarios de prueba
    FOR i IN 1..10 LOOP
        v_first := v_first_names[1 + (i-1) % array_length(v_first_names, 1)];
        v_last := v_last_names[1 + (i-1) % array_length(v_last_names, 1)];
        
        -- Insertar usuario con contraseña encriptada
        INSERT INTO mdl_user (
            username, 
            password, 
            firstname, 
            lastname, 
            email, 
            auth, 
            confirmed, 
            lang, 
            timezone, 
            deleted, 
            suspended, 
            mnethostid, 
            timecreated, 
            timemodified
        ) VALUES (
            'user' || i,                          -- username
            v_hashed_password,                    -- password (hash de '1234')
            v_first,                              -- firstname
            v_last,                               -- lastname
            'user' || i || '@example.com',        -- email
            'manual',                             -- auth
            TRUE,                                 -- confirmed
            'es',                                 -- lang
            '99',                                 -- timezone
            FALSE,                                -- deleted
            FALSE,                                -- suspended
            1,                                    -- mnethostid
            v_current_time,                       -- timecreated
            v_current_time                        -- timemodified
        ) ON CONFLICT (username) DO NOTHING;      -- Evitar duplicados
    END LOOP;
    
    -- Asignar algunos roles a los usuarios (suponiendo que existen roles básicos)
    -- Si no existen los roles, primero hay que crearlos
    INSERT INTO mdl_role (name, shortname, description, sortorder)
    VALUES 
        ('Administrador', 'admin', 'Acceso completo al sistema', 1),
        ('Profesor', 'teacher', 'Puede crear y gestionar cursos', 2),
        ('Estudiante', 'student', 'Puede acceder a cursos', 3)
    ON CONFLICT (shortname) DO NOTHING;
    
    -- Asignar roles a los usuarios
    -- Usuarios 1-3: administradores
    -- Usuarios 4-7: profesores
    -- Usuarios 8-10: estudiantes
    FOR i IN 1..10 LOOP
        -- Obtener ID del usuario
        DECLARE
            v_user_id INTEGER;
            v_role_id INTEGER;
        BEGIN
            -- Obtener ID del usuario
            SELECT id INTO v_user_id FROM mdl_user WHERE username = 'user' || i;
            
            -- Determinar qué rol asignar
            IF i <= 3 THEN
                SELECT id INTO v_role_id FROM mdl_role WHERE shortname = 'admin';
            ELSIF i <= 7 THEN
                SELECT id INTO v_role_id FROM mdl_role WHERE shortname = 'teacher';
            ELSE
                SELECT id INTO v_role_id FROM mdl_role WHERE shortname = 'student';
            END IF;
            
            -- Asignar rol al usuario
            INSERT INTO mdl_role_assignments (roleid, contextid, userid, timemodified, modifierid)
            VALUES (
                v_role_id,       -- roleid
                1,               -- contextid (1 es típicamente el contexto global)
                v_user_id,       -- userid
                v_current_time,  -- timemodified
                1                -- modifierid (suponemos que el admin con ID 1 hizo la asignación)
            ) ON CONFLICT DO NOTHING;
        END;
    END LOOP;
    
    -- Log de finalización
    RAISE NOTICE 'Se crearon 10 usuarios de prueba con la contraseña "1234" y roles asignados';
END; $$;


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
-- CREATE OR REPLACE FUNCTION create_assignment(
--     p_course INTEGER,
--     p_name TEXT,
--     p_intro TEXT,
--     p_section INTEGER,
--     p_duedate TIMESTAMP,
--     p_allowsubmissionsfromdate TIMESTAMP,
--     p_grade INTEGER
-- )
-- RETURNS SETOF mdl_assign AS $$
-- BEGIN
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
--         p_duedate,
--         p_allowsubmissionsfromdate,
--         p_grade,
--         1, -- introformat
--         NOW() -- timemodified
--     )
--     RETURNING *;
-- END;
-- $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.create_assignment(
    p_course integer,
    p_name text,
    p_intro text,
    p_section integer,
    p_duedate text,
    p_allowsubmissionsfromdate text,
    p_grade integer)
    RETURNS SETOF mdl_assign 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000
AS $BODY$
DECLARE
    v_duedate timestamp without time zone;
    v_allowsubmissionsfromdate timestamp without time zone;
BEGIN
    -- Validaciones
    IF p_name IS NULL OR p_name = '' THEN
        RAISE EXCEPTION 'El nombre de la asignación no puede estar vacío';
    END IF;
    
    IF p_course <= 0 THEN
        RAISE EXCEPTION 'El ID del curso debe ser un número positivo';
    END IF;
    
    -- Convertir fechas con manejo de errores
    BEGIN
        IF p_duedate IS NOT NULL THEN
            v_duedate := p_duedate::timestamp without time zone;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION 'Formato de fecha inválido para duedate: %', p_duedate;
    END;
    
    BEGIN
        IF p_allowsubmissionsfromdate IS NOT NULL THEN
            v_allowsubmissionsfromdate := p_allowsubmissionsfromdate::timestamp without time zone;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION 'Formato de fecha inválido para allowsubmissionsfromdate: %', p_allowsubmissionsfromdate;
    END;
    
    -- Insertar registro
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
        v_duedate,
        v_allowsubmissionsfromdate,
        p_grade,
        1, -- introformat
        NOW() -- timemodified
    )
    RETURNING *;
END;
$BODY$;

ALTER FUNCTION public.create_assignment(integer, text, text, integer, text, text, integer)
    OWNER TO admin;

-- Actualizar una asignación
-- CREATE OR REPLACE FUNCTION update_assignment(
--     p_assignment_id INTEGER,
--     p_name TEXT,
--     p_intro TEXT,
--     p_section INTEGER,
--     p_duedate TIMESTAMP,
--     p_allowsubmissionsfromdate TIMESTAMP,
--     p_grade INTEGER
-- )
-- RETURNS SETOF mdl_assign AS $$
-- BEGIN
--     RETURN QUERY
--     UPDATE mdl_assign
--     SET name = p_name,
--         intro = p_intro,
--         section = p_section,
--         duedate = p_duedate,
--         allowsubmissionsfromdate = p_allowsubmissionsfromdate,
--         grade = p_grade,
--         timemodified = NOW()
--     WHERE id = p_assignment_id
--     RETURNING *;
-- END;
-- $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.update_assignment(
    p_id integer,
    p_name text DEFAULT NULL,
    p_intro text DEFAULT NULL,
    p_section integer DEFAULT NULL,
    p_duedate text DEFAULT NULL,
    p_allowsubmissionsfromdate text DEFAULT NULL,
    p_grade integer DEFAULT NULL,
    -- Añadir aquí el resto de campos que se pueden actualizar
    p_alwaysshowdescription boolean DEFAULT NULL,
    p_nosubmissions boolean DEFAULT NULL
    -- etc.
)
RETURNS SETOF mdl_assign 
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    v_duedate timestamp without time zone;
    v_allowsubmissionsfromdate timestamp without time zone;
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
    
    -- Manejar fechas con conversión
    IF p_duedate IS NOT NULL THEN
        BEGIN
            v_duedate := p_duedate::timestamp without time zone;
            v_update_parts := v_update_parts || ', duedate = ' || quote_literal(v_duedate);
        EXCEPTION WHEN OTHERS THEN
            RAISE EXCEPTION 'Formato de fecha inválido para duedate: %', p_duedate;
        END;
    END IF;
    
    IF p_allowsubmissionsfromdate IS NOT NULL THEN
        BEGIN
            v_allowsubmissionsfromdate := p_allowsubmissionsfromdate::timestamp without time zone;
            v_update_parts := v_update_parts || ', allowsubmissionsfromdate = ' || quote_literal(v_allowsubmissionsfromdate);
        EXCEPTION WHEN OTHERS THEN
            RAISE EXCEPTION 'Formato de fecha inválido para allowsubmissionsfromdate: %', p_allowsubmissionsfromdate;
        END;
    END IF;
    
    -- Manejar el resto de campos aquí...
    
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
-- CREATE OR REPLACE FUNCTION create_assignment(
--     p_course INTEGER,
--     p_name TEXT,
--     p_intro TEXT,
--     p_section INTEGER,
--     p_duedate TIMESTAMP,
--     p_allowsubmissionsfromdate TIMESTAMP,
--     p_grade INTEGER
-- )
-- RETURNS SETOF mdl_assign AS $$
-- BEGIN
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
--         p_duedate,
--         p_allowsubmissionsfromdate,
--         p_grade,
--         1, -- introformat
--         NOW() -- timemodified
--     )
--     RETURNING *;
-- END;
-- $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.create_assignment(
    p_course integer,
    p_name text,
    p_intro text,
    p_section integer,
    p_duedate text,
    p_allowsubmissionsfromdate text,
    p_grade integer)
    RETURNS SETOF mdl_assign 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000
AS $BODY$
DECLARE
    v_duedate timestamp without time zone;
    v_allowsubmissionsfromdate timestamp without time zone;
BEGIN
    -- Validaciones
    IF p_name IS NULL OR p_name = '' THEN
        RAISE EXCEPTION 'El nombre de la asignación no puede estar vacío';
    END IF;
    
    IF p_course <= 0 THEN
        RAISE EXCEPTION 'El ID del curso debe ser un número positivo';
    END IF;
    
    -- Convertir fechas con manejo de errores
    BEGIN
        IF p_duedate IS NOT NULL THEN
            v_duedate := p_duedate::timestamp without time zone;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION 'Formato de fecha inválido para duedate: %', p_duedate;
    END;
    
    BEGIN
        IF p_allowsubmissionsfromdate IS NOT NULL THEN
            v_allowsubmissionsfromdate := p_allowsubmissionsfromdate::timestamp without time zone;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION 'Formato de fecha inválido para allowsubmissionsfromdate: %', p_allowsubmissionsfromdate;
    END;
    
    -- Insertar registro
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
        v_duedate,
        v_allowsubmissionsfromdate,
        p_grade,
        1, -- introformat
        NOW() -- timemodified
    )
    RETURNING *;
END;
$BODY$;

ALTER FUNCTION public.create_assignment(integer, text, text, integer, text, text, integer)
    OWNER TO admin;

-- Actualizar una asignación
-- CREATE OR REPLACE FUNCTION update_assignment(
--     p_assignment_id INTEGER,
--     p_name TEXT,
--     p_intro TEXT,
--     p_section INTEGER,
--     p_duedate TIMESTAMP,
--     p_allowsubmissionsfromdate TIMESTAMP,
--     p_grade INTEGER
-- )
-- RETURNS SETOF mdl_assign AS $$
-- BEGIN
--     RETURN QUERY
--     UPDATE mdl_assign
--     SET name = p_name,
--         intro = p_intro,
--         section = p_section,
--         duedate = p_duedate,
--         allowsubmissionsfromdate = p_allowsubmissionsfromdate,
--         grade = p_grade,
--         timemodified = NOW()
--     WHERE id = p_assignment_id
--     RETURNING *;
-- END;
-- $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.update_assignment(
    p_id integer,
    p_name text DEFAULT NULL,
    p_intro text DEFAULT NULL,
    p_section integer DEFAULT NULL,
    p_duedate text DEFAULT NULL,
    p_allowsubmissionsfromdate text DEFAULT NULL,
    p_grade integer DEFAULT NULL,
    -- Añadir aquí el resto de campos que se pueden actualizar
    p_alwaysshowdescription boolean DEFAULT NULL,
    p_nosubmissions boolean DEFAULT NULL
    -- etc.
)
RETURNS SETOF mdl_assign 
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    v_duedate timestamp without time zone;
    v_allowsubmissionsfromdate timestamp without time zone;
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
    
    -- Manejar fechas con conversión
    IF p_duedate IS NOT NULL THEN
        BEGIN
            v_duedate := p_duedate::timestamp without time zone;
            v_update_parts := v_update_parts || ', duedate = ' || quote_literal(v_duedate);
        EXCEPTION WHEN OTHERS THEN
            RAISE EXCEPTION 'Formato de fecha inválido para duedate: %', p_duedate;
        END;
    END IF;
    
    IF p_allowsubmissionsfromdate IS NOT NULL THEN
        BEGIN
            v_allowsubmissionsfromdate := p_allowsubmissionsfromdate::timestamp without time zone;
            v_update_parts := v_update_parts || ', allowsubmissionsfromdate = ' || quote_literal(v_allowsubmissionsfromdate);
        EXCEPTION WHEN OTHERS THEN
            RAISE EXCEPTION 'Formato de fecha inválido para allowsubmissionsfromdate: %', p_allowsubmissionsfromdate;
        END;
    END IF;
    
    -- Manejar el resto de campos aquí...
    
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


-- Archivo: indexes.sql
-- Descripción: Índices optimizados para mejorar el rendimiento de consultas frecuentes

-- Índice para búsquedas por username (ya filtrado por deleted = FALSE)
CREATE INDEX IF NOT EXISTS idx_mdl_user_username ON mdl_user(username) 
WHERE deleted = FALSE;

-- Índice para búsquedas por email (ya filtrado por deleted = FALSE)
CREATE INDEX IF NOT EXISTS idx_mdl_user_email ON mdl_user(email) 
WHERE deleted = FALSE;

-- Índice para búsquedas de roles por usuario
CREATE INDEX IF NOT EXISTS idx_mdl_role_assignments_userid ON mdl_role_assignments(userid);

-- Índice para búsquedas en tabla de auditoría
CREATE INDEX IF NOT EXISTS idx_login_audit_username ON login_audit(username);
CREATE INDEX IF NOT EXISTS idx_login_audit_timestamp ON login_audit(timestamp);
CREATE INDEX IF NOT EXISTS idx_login_audit_success ON login_audit(success);

-- Índice para búsquedas frecuentes en mdl_user
CREATE INDEX IF NOT EXISTS idx_mdl_user_lastname_firstname ON mdl_user(lastname, firstname)
WHERE deleted = FALSE;

-- Índice para optimizar joins con la tabla de roles
CREATE INDEX IF NOT EXISTS idx_mdl_role_name ON mdl_role(name);
CREATE INDEX IF NOT EXISTS idx_mdl_role_shortname ON mdl_role(shortname);

-- Índice para buscar por ID de usuario (para actualizaciones frecuentes)
CREATE INDEX IF NOT EXISTS idx_mdl_user_id_active ON mdl_user(id)
WHERE deleted = FALSE;

-- Análisis de tablas para optimizar el planificador de consultas
ANALYZE mdl_user;
ANALYZE mdl_role;
ANALYZE mdl_role_assignments;
ANALYZE login_audit;


