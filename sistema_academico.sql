-- Crear el esquema de base de datos y seleccionarlo
CREATE DATABASE IF NOT EXISTS sistema_academico;
USE sistema_academico;

-- 1. Tabla ROL para definir los roles disponibles
CREATE TABLE IF NOT EXISTS ROL (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Insertar los roles básicos
INSERT INTO ROL (nombre) VALUES ('Estudiante'), ('Profesor'), ('Administrador');

-- 2. Tabla USUARIO, ahora con id_rol que referencia la tabla ROL
CREATE TABLE IF NOT EXISTS USUARIO (
    id_usu INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    id_rol INT NOT NULL,
    fecha_creacion DATE NOT NULL,
    ultima_conexion DATE,
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol)
);

-- 3. Tabla PROFESOR: Se relaciona mediante idUsuario que referencia USUARIO(id_usu)
CREATE TABLE IF NOT EXISTS PROFESOR (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    fecha_nacimiento DATE,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    grado_academico VARCHAR(255),
    especializacion VARCHAR(255),
    fecha_contratacion DATE,
    estado ENUM('Activo', 'Baja') NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES USUARIO(id_usu) ON DELETE CASCADE,
    INDEX idx_profesor_usuario (idUsuario)
);

-- 4. Tabla ESTUDIANTE: Se relaciona también mediante idUsuario que referencia USUARIO(id_usu)
CREATE TABLE IF NOT EXISTS ESTUDIANTE (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    fecha_nacimiento DATE,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    numero_identificacion VARCHAR(50) UNIQUE,
    estado ENUM('Activo', 'Inactivo') NOT NULL,
    promedio_academico FLOAT,
    FOREIGN KEY (idUsuario) REFERENCES USUARIO(id_usu) ON DELETE CASCADE,
    INDEX idx_estudiante_usuario (idUsuario)
);

-- 5. (Opcional) Tabla ADMINISTRADOR para almacenar información adicional del rol Administrador
CREATE TABLE IF NOT EXISTS ADMINISTRADOR (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    departamento VARCHAR(255),
    fecha_ingreso DATE,
    FOREIGN KEY (idUsuario) REFERENCES USUARIO(id_usu) ON DELETE CASCADE,
    INDEX idx_admin_usuario (idUsuario)
);

-- 6. Tabla CURSO: Incluye nombre, código único, descripción y la opción de asignar un profesor
CREATE TABLE IF NOT EXISTS CURSO (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    codigo VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    idProfesor INT,
    FOREIGN KEY (idProfesor) REFERENCES PROFESOR(id_profesor) ON DELETE SET NULL,
    INDEX idx_curso_profesor (idProfesor)
);

-- 7. Tabla CURSO_ESTUDIANTE: Relación muchos a muchos entre cursos y estudiantes
CREATE TABLE IF NOT EXISTS CURSO_ESTUDIANTE (
    id_curso INT NOT NULL,
    id_estudiante INT NOT NULL,
    PRIMARY KEY (id_curso, id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES CURSO(id_curso) ON DELETE CASCADE,
    FOREIGN KEY (id_estudiante) REFERENCES ESTUDIANTE(id_estudiante) ON DELETE CASCADE
);

-- 8. Tabla ACTIVIDAD: Define las funcionalidades o acciones del sistema con un enlace (por ejemplo, al JSP)
CREATE TABLE IF NOT EXISTS ACTIVIDAD (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    enlace VARCHAR(255) NOT NULL
);

-- 9. Tabla GESTION_ACTIVIDADES: Relaciona cada actividad con el rol que tiene permiso para ejecutarla
CREATE TABLE IF NOT EXISTS GESTION_ACTIVIDADES (
    id_rol INT NOT NULL,
    id_actividad INT NOT NULL,
    PRIMARY KEY (id_rol, id_actividad),
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol) ON DELETE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES ACTIVIDAD(id_actividad) ON DELETE CASCADE
);
