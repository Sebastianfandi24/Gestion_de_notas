CREATE DATABASE IF NOT EXISTS sistema_academico;
USE sistema_academico;

-- Tabla ROL
CREATE TABLE ROL (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla USUARIO
CREATE TABLE USUARIO (
    id_usu INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(191) UNIQUE NOT NULL,
    contraseña VARCHAR(64) NOT NULL,
    id_rol INT NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    ultima_conexion DATETIME,
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol)
);

-- Tabla PROFESOR
CREATE TABLE PROFESOR (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    fecha_nacimiento DATE,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    grado_academico VARCHAR(255),
    especializacion VARCHAR(255),
    fecha_contratacion DATETIME,
    estado ENUM('Activo', 'Baja') NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES USUARIO(id_usu) ON DELETE CASCADE
);

-- Tabla ESTUDIANTE
CREATE TABLE ESTUDIANTE (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    fecha_nacimiento DATE,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    numero_identificacion VARCHAR(50) UNIQUE,
    estado ENUM('Activo', 'Inactivo') NOT NULL,
    promedio_academico DECIMAL(5,2),
    FOREIGN KEY (idUsuario) REFERENCES USUARIO(id_usu) ON DELETE CASCADE
);

-- Tabla ADMINISTRADOR
CREATE TABLE ADMINISTRADOR (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    departamento VARCHAR(255),
    fecha_ingreso DATETIME,
    FOREIGN KEY (idUsuario) REFERENCES USUARIO(id_usu) ON DELETE CASCADE
);

-- Tabla CURSO
CREATE TABLE CURSO (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    codigo VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    idProfesor INT,
    FOREIGN KEY (idProfesor) REFERENCES PROFESOR(id_profesor) ON DELETE SET NULL
);

-- Tabla CURSO_ESTUDIANTE
CREATE TABLE CURSO_ESTUDIANTE (
    id_curso INT NOT NULL,
    id_estudiante INT NOT NULL,
    PRIMARY KEY (id_curso, id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES CURSO(id_curso) ON DELETE CASCADE,
    FOREIGN KEY (id_estudiante) REFERENCES ESTUDIANTE(id_estudiante) ON DELETE CASCADE
);

-- Tabla ACTIVIDAD
CREATE TABLE ACTIVIDAD (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    enlace VARCHAR(255) NOT NULL
);

-- Tabla GESTION_ACTIVIDADES
CREATE TABLE GESTION_ACTIVIDADES (
    id_rol INT NOT NULL,
    id_actividad INT NOT NULL,
    PRIMARY KEY (id_rol, id_actividad),
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol) ON DELETE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES ACTIVIDAD(id_actividad) ON DELETE CASCADE
);

-- Tabla TAREA
CREATE TABLE TAREA (
    id_tarea INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    fecha_asignacion DATETIME,
    fecha_entrega DATETIME,
    id_curso INT NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES CURSO(id_curso) ON DELETE CASCADE
);

-- Tabla NOTA_TAREA
CREATE TABLE NOTA_TAREA (
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    id_tarea INT NOT NULL,
    id_estudiante INT NOT NULL,
    nota DECIMAL(5,2) DEFAULT NULL,
    fecha_evaluacion DATETIME,
    comentario TEXT,
    UNIQUE KEY uk_tarea_estudiante (id_tarea, id_estudiante),
    FOREIGN KEY (id_tarea) REFERENCES TAREA(id_tarea) ON DELETE CASCADE,
    FOREIGN KEY (id_estudiante) REFERENCES ESTUDIANTE(id_estudiante) ON DELETE CASCADE
);


INSERT INTO ROL (nombre) VALUES ('Estudiante'), ('Profesor'), ('Administrador');


-- Insertar usuarios para cada rol

INSERT INTO USUARIO (nombre, correo, contraseña, id_rol, fecha_creacion, ultima_conexion) 
VALUES 
    ('Admin User', 'admin@example.com', '8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918', (SELECT id_rol FROM ROL WHERE nombre = 'Administrador'), NOW(), NOW()),
    ('Profesor User', 'profesor@example.com', '2BB80D537B1DA3E38BD30361AA855686BDE0EACD7162FEF6A25FE97BF527A25B', (SELECT id_rol FROM ROL WHERE nombre = 'Profesor'), NOW(), NOW()),
    ('Estudiante User', 'estudiante@example.com', '3B64EC643AC5E82AF6C5A72BC5FFB1E7E06E0311ED0BE625DB12A5EAF8C39CA9', (SELECT id_rol FROM ROL WHERE nombre = 'Estudiante'), NOW(), NOW());

-- Insertar profesor
INSERT INTO PROFESOR (idUsuario, fecha_nacimiento, direccion, telefono, grado_academico, especializacion, fecha_contratacion, estado)
VALUES (
    (SELECT id_usu FROM USUARIO WHERE correo = 'profesor@example.com'),
    '1980-05-15', 'Calle Falsa 123', '555-1234', 'Maestría', 'Ingeniería de Sistemas', '2020-08-01 09:00:00', 'Activo'
);

-- Insertar estudiante
INSERT INTO ESTUDIANTE (idUsuario, fecha_nacimiento, direccion, telefono, numero_identificacion, estado, promedio_academico)
VALUES (
    (SELECT id_usu FROM USUARIO WHERE correo = 'estudiante@example.com'),
    '2000-03-20', 'Avenida Siempre Viva 456', '555-5678', 'ID123456', 'Activo', 85.5
);

-- Insertar administrador
INSERT INTO ADMINISTRADOR (idUsuario, departamento, fecha_ingreso)
VALUES (
    (SELECT id_usu FROM USUARIO WHERE correo = 'admin@example.com'),
    'Sistemas', '2019-01-10 08:00:00'
);

-- Insertar cursos
INSERT INTO CURSO (nombre, codigo, descripcion, idProfesor)
VALUES 
    ('Introducción a la Programación', 'CS101', 'Curso introductorio de programación.',
    (SELECT id_profesor FROM PROFESOR WHERE idUsuario = (SELECT id_usu FROM USUARIO WHERE correo = 'profesor@example.com'))),
    ('Bases de Datos', 'CS102', 'Curso sobre diseño y gestión de bases de datos.',
    (SELECT id_profesor FROM PROFESOR WHERE idUsuario = (SELECT id_usu FROM USUARIO WHERE correo = 'profesor@example.com')));

-- Vincular cursos con estudiante
INSERT INTO CURSO_ESTUDIANTE (id_curso, id_estudiante)
VALUES 
    ((SELECT id_curso FROM CURSO WHERE codigo = 'CS101'), 
     (SELECT id_estudiante FROM ESTUDIANTE WHERE idUsuario = (SELECT id_usu FROM USUARIO WHERE correo = 'estudiante@example.com'))),
    ((SELECT id_curso FROM CURSO WHERE codigo = 'CS102'), 
     (SELECT id_estudiante FROM ESTUDIANTE WHERE idUsuario = (SELECT id_usu FROM USUARIO WHERE correo = 'estudiante@example.com')));

-- Insertar actividades del sistema
INSERT INTO ACTIVIDAD (nombre, enlace)
VALUES 
    ('Gestionar Profesores', 'dashboard/admin/profesores.jsp'),
    ('Gestionar Estudiantes', 'dashboard/admin/estudiantes.jsp'),
    ('Gestionar Cursos', 'dashboard/admin/cursos.jsp'),
    ('Ver Mis Cursos', 'dashboard/profesor/mis-cursos.jsp'),
    ('Crear Tarea', 'dashboard/profesor/nueva-tarea.jsp'),
    ('Calificar Tareas', 'dashboard/profesor/calificar-tareas.jsp'),
    ('Ver Cursos Estudiante', 'dashboard/estudiante/mis-cursos.jsp'),
    ('Ver Tareas Estudiante', 'dashboard/estudiante/mis-tareas.jsp'),
    ('Ver Notas Estudiante', 'dashboard/estudiante/mis-notas.jsp');

-- Asignar permisos de actividades a roles
INSERT INTO GESTION_ACTIVIDADES (id_rol, id_actividad)
VALUES 
    -- Permisos de Administrador
    ((SELECT id_rol FROM ROL WHERE nombre = 'Administrador'), (SELECT id_actividad FROM ACTIVIDAD WHERE nombre = 'Gestionar Profesores')),
    ((SELECT id_rol FROM ROL WHERE nombre = 'Administrador'), (SELECT id_actividad FROM ACTIVIDAD WHERE nombre = 'Gestionar Estudiantes')),
    ((SELECT id_rol FROM ROL WHERE nombre = 'Administrador'), (SELECT id_actividad FROM ACTIVIDAD WHERE nombre = 'Gestionar Cursos')),
    -- Permisos de Profesor
    ((SELECT id_rol FROM ROL WHERE nombre = 'Profesor'), (SELECT id_actividad FROM ACTIVIDAD WHERE nombre = 'Ver Mis Cursos')),
    ((SELECT id_rol FROM ROL WHERE nombre = 'Profesor'), (SELECT id_actividad FROM ACTIVIDAD WHERE nombre = 'Crear Tarea')),
    ((SELECT id_rol FROM ROL WHERE nombre = 'Profesor'), (SELECT id_actividad FROM ACTIVIDAD WHERE nombre = 'Calificar Tareas')),
    -- Permisos de Estudiante
    ((SELECT id_rol FROM ROL WHERE nombre = 'Estudiante'), (SELECT id_actividad FROM ACTIVIDAD WHERE nombre = 'Ver Cursos Estudiante')),
    ((SELECT id_rol FROM ROL WHERE nombre = 'Estudiante'), (SELECT id_actividad FROM ACTIVIDAD WHERE nombre = 'Ver Tareas Estudiante')),
    ((SELECT id_rol FROM ROL WHERE nombre = 'Estudiante'), (SELECT id_actividad FROM ACTIVIDAD WHERE nombre = 'Ver Notas Estudiante'));


-- Insertar tareas
INSERT INTO TAREA (titulo, descripcion, fecha_asignacion, fecha_entrega, id_curso)
VALUES 
    ('Tarea 1', 'Resolver ejercicios de lógica.', '2023-04-01 08:00:00', '2023-04-15 23:59:59', 
     (SELECT id_curso FROM CURSO WHERE codigo = 'CS101')),
    ('Tarea 2', 'Diseñar una base de datos simple.', '2023-04-05 08:00:00', '2023-04-20 23:59:59', 
     (SELECT id_curso FROM CURSO WHERE codigo = 'CS102'));

-- Insertar notas de tareas
INSERT INTO NOTA_TAREA (id_tarea, id_estudiante, nota, fecha_evaluacion, comentario)
VALUES 
    ((SELECT id_tarea FROM TAREA WHERE titulo = 'Tarea 1'), 
     (SELECT id_estudiante FROM ESTUDIANTE WHERE idUsuario = (SELECT id_usu FROM USUARIO WHERE correo = 'estudiante@example.com')),
     92.5, '2023-04-16 14:30:00', 'Buen desempeño'),
    ((SELECT id_tarea FROM TAREA WHERE titulo = 'Tarea 2'), 
     (SELECT id_estudiante FROM ESTUDIANTE WHERE idUsuario = (SELECT id_usu FROM USUARIO WHERE correo = 'estudiante@example.com')),
     88.0, '2023-04-21 15:45:00', 'Buen trabajo, pero hay aspectos a mejorar');