INSERT INTO ROL (nombre) VALUES ('Estudiante'), ('Profesor'), ('Administrador');


-- Insertar usuarios para cada rol

INSERT INTO USUARIO (nombre, correo, contraseña, id_rol, fecha_creacion, ultima_conexion) 
VALUES 
    ('Admin User', 'admin@example.com', '8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918', (SELECT id_rol FROM ROL WHERE nombre = 'Administrador'), CURDATE(), CURDATE()),
    ('Profesor User', 'profesor@example.com', '2BB80D537B1DA3E38BD30361AA855686BDE0EACD7162FEF6A25FE97BF527A25B', (SELECT id_rol FROM ROL WHERE nombre = 'Profesor'), CURDATE(), CURDATE()),
    ('Estudiante User', 'estudiante@example.com', '3B64EC643AC5E82AF6C5A72BC5FFB1E7E06E0311ED0BE625DB12A5EAF8C39CA9', (SELECT id_rol FROM ROL WHERE nombre = 'Estudiante'), CURDATE(), CURDATE());

-- Insertar profesor
INSERT INTO PROFESOR (idUsuario, fecha_nacimiento, direccion, telefono, grado_academico, especializacion, fecha_contratacion, estado)
VALUES (
    (SELECT id_usu FROM USUARIO WHERE correo = 'profesor@example.com'),
    '1980-05-15', 'Calle Falsa 123', '555-1234', 'Maestría', 'Ingeniería de Sistemas', '2020-08-01', 'Activo'
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
    'Sistemas', '2019-01-10'
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
    ('Tarea 1', 'Resolver ejercicios de lógica.', '2023-04-01', '2023-04-15', 
     (SELECT id_curso FROM CURSO WHERE codigo = 'CS101')),
    ('Tarea 2', 'Diseñar una base de datos simple.', '2023-04-05', '2023-04-20', 
     (SELECT id_curso FROM CURSO WHERE codigo = 'CS102'));

-- Insertar notas de tareas
INSERT INTO NOTA_TAREA (id_tarea, id_estudiante, nota, fecha_evaluacion, comentario)
VALUES 
    ((SELECT id_tarea FROM TAREA WHERE titulo = 'Tarea 1'), 
     (SELECT id_estudiante FROM ESTUDIANTE WHERE idUsuario = (SELECT id_usu FROM USUARIO WHERE correo = 'estudiante@example.com')),
     92.5, '2023-04-16', 'Buen desempeño'),
    ((SELECT id_tarea FROM TAREA WHERE titulo = 'Tarea 2'), 
     (SELECT id_estudiante FROM ESTUDIANTE WHERE idUsuario = (SELECT id_usu FROM USUARIO WHERE correo = 'estudiante@example.com')),
     88.0, '2023-04-21', 'Buen trabajo, pero hay aspectos a mejorar');