package DAOs;

import Interfaces.CRUD;
import Models.Conexion;
import Models.Profesor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProfesorDAO implements CRUD<Profesor> {
    private final Conexion conexion;
    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;
    private static final Logger LOGGER = Logger.getLogger(ProfesorDAO.class.getName());
    
    public ProfesorDAO() {
        this.conexion = new Conexion();
        LOGGER.info("ProfesorDAO inicializado");
    }
    
    @Override
    public boolean create(Profesor profesor) {
        LOGGER.info("[ProfesorDAO] Iniciando creación de nuevo profesor: " + profesor.getNombre());
        String sqlUsuario = "INSERT INTO USUARIO (nombre, correo, id_rol, fecha_creacion) VALUES (?, ?, ?, NOW())";
        String sqlProfesor = "INSERT INTO PROFESOR (idUsuario, fecha_nacimiento, direccion, telefono, grado_academico, especializacion, fecha_contratacion, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            LOGGER.info("[ProfesorDAO] Intentando abrir conexión a la base de datos...");
            conn = conexion.crearConexion();
            conn.setAutoCommit(false);
            LOGGER.info("[ProfesorDAO] Conexión abierta, iniciando transacción...");
            
            // Insertar en la tabla USUARIO
            ps = conn.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, profesor.getNombre());
            ps.setString(2, profesor.getCorreo());
            ps.setInt(3, profesor.getIdRol());
            LOGGER.info("[ProfesorDAO] SQL Usuario: " + sqlUsuario + " | Parámetros: " + profesor.getNombre() + ", " + profesor.getCorreo() + ", " + profesor.getIdRol());
            LOGGER.info("[ProfesorDAO] Insertando en tabla USUARIO...");
            ps.executeUpdate();
            
            // Obtener el ID generado para el usuario
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int idUsuario = rs.getInt(1);
                LOGGER.info("[ProfesorDAO] ID de usuario generado: " + idUsuario);
                
                // Insertar en la tabla PROFESOR
                ps = conn.prepareStatement(sqlProfesor);
                ps.setInt(1, idUsuario);
                // Manejo de fecha de nacimiento
                java.sql.Date sqlFechaNac = null;
                if (profesor.getFechaNacimiento() != null) {
                    sqlFechaNac = new java.sql.Date(profesor.getFechaNacimiento().getTime());
                    LOGGER.info("[ProfesorDAO] Fecha de nacimiento: " + sqlFechaNac);
                } else {
                    LOGGER.info("[ProfesorDAO] Fecha de nacimiento es NULL");
                }
                ps.setDate(2, sqlFechaNac);
                
                ps.setString(3, profesor.getDireccion());
                ps.setString(4, profesor.getTelefono());
                ps.setString(5, profesor.getGradoAcademico());
                ps.setString(6, profesor.getEspecializacion());
                
                // Manejo de fecha de contratación
                java.sql.Timestamp sqlFechaContratacion = null;
                if (profesor.getFechaContratacion() != null) {
                    sqlFechaContratacion = new java.sql.Timestamp(profesor.getFechaContratacion().getTime());
                    LOGGER.info("[ProfesorDAO] Fecha de contratación: " + sqlFechaContratacion);
                } else {
                    LOGGER.info("[ProfesorDAO] Fecha de contratación es NULL");
                }
                ps.setTimestamp(7, sqlFechaContratacion);
                
                ps.setString(8, profesor.getEstado());
                
                LOGGER.info("[ProfesorDAO] SQL Profesor: " + sqlProfesor + 
                           " | Parámetros: idUsuario=" + idUsuario + 
                           ", fechaNac=" + sqlFechaNac +
                           ", dirección=" + profesor.getDireccion() +
                           ", teléfono=" + profesor.getTelefono() +
                           ", gradoAcad=" + profesor.getGradoAcademico() +
                           ", espec=" + profesor.getEspecializacion() +
                           ", fechaContr=" + sqlFechaContratacion +
                           ", estado=" + profesor.getEstado());
                
                LOGGER.info("[ProfesorDAO] Insertando en tabla PROFESOR...");
                ps.executeUpdate();
                
                conn.commit();
                LOGGER.info("[ProfesorDAO] Transacción completada exitosamente");
                return true;
            }
            
            LOGGER.warning("[ProfesorDAO] Error: No se pudo obtener el ID de usuario generado");
            conn.rollback();
            return false;
            
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                    LOGGER.warning("[ProfesorDAO] Transacción revertida");
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error en rollback", ex);
            }
            LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error SQL al crear profesor - Código: " + e.getErrorCode() + " - Estado SQL: " + e.getSQLState(), e);
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.close();
                    LOGGER.info("[ProfesorDAO] Conexiones cerradas");
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error al cerrar conexiones", e);
            }
        }
    }
    
    @Override
    public Profesor read(int id) {
        String sql = "SELECT u.*, p.* FROM USUARIO u INNER JOIN PROFESOR p ON u.id_usu = p.idUsuario WHERE p.id_profesor = ?";
        Profesor profesor = null;
        
        try {
            LOGGER.info("[ProfesorDAO] Buscando profesor con ID: " + id);
            conn = conexion.crearConexion();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                profesor = new Profesor();
                profesor.setId(rs.getInt("id_profesor"));
                profesor.setIdUsu(rs.getInt("id_usu"));
                profesor.setNombre(rs.getString("nombre"));
                profesor.setCorreo(rs.getString("correo"));
                profesor.setIdRol(rs.getInt("id_rol"));
                profesor.setFechaCreacion(rs.getDate("fecha_creacion"));
                profesor.setUltimaConexion(rs.getDate("ultima_conexion"));
                profesor.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                profesor.setDireccion(rs.getString("direccion"));
                profesor.setTelefono(rs.getString("telefono"));
                profesor.setGradoAcademico(rs.getString("grado_academico"));
                profesor.setEspecializacion(rs.getString("especializacion"));
                profesor.setFechaContratacion(rs.getDate("fecha_contratacion"));
                profesor.setEstado(rs.getString("estado"));
                LOGGER.info("[ProfesorDAO] Profesor encontrado: " + profesor.getNombre());
                
                // Registrar los valores de fecha para depuración
                LOGGER.info("[ProfesorDAO] Fecha de nacimiento desde BD: " + rs.getDate("fecha_nacimiento"));
                LOGGER.info("[ProfesorDAO] Fecha de contratación desde BD: " + rs.getDate("fecha_contratacion"));
            } else {
                LOGGER.warning("[ProfesorDAO] No se encontró ningún profesor con ID: " + id);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error al leer profesor con ID: " + id, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.close();
                    LOGGER.info("[ProfesorDAO] Conexiones cerradas");
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error al cerrar conexiones", e);
            }
        }
        
        return profesor;
    }
    
    @Override
    public List<Profesor> readAll() {
        String sql = "SELECT u.*, p.* FROM USUARIO u INNER JOIN PROFESOR p ON u.id_usu = p.idUsuario";
        List<Profesor> profesores = new ArrayList<>();
        
        try {
            LOGGER.info("[ProfesorDAO] Obteniendo todos los profesores");
            conn = conexion.crearConexion();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Profesor profesor = new Profesor();
                profesor.setId(rs.getInt("id_profesor"));
                profesor.setIdUsu(rs.getInt("id_usu"));
                profesor.setNombre(rs.getString("nombre"));
                profesor.setCorreo(rs.getString("correo"));
                profesor.setIdRol(rs.getInt("id_rol"));
                profesor.setFechaCreacion(rs.getDate("fecha_creacion"));
                profesor.setUltimaConexion(rs.getDate("ultima_conexion"));
                profesor.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                profesor.setDireccion(rs.getString("direccion"));
                profesor.setTelefono(rs.getString("telefono"));
                profesor.setGradoAcademico(rs.getString("grado_academico"));
                profesor.setEspecializacion(rs.getString("especializacion"));
                profesor.setFechaContratacion(rs.getDate("fecha_contratacion"));
                profesor.setEstado(rs.getString("estado"));
                profesores.add(profesor);
            }
            
            LOGGER.info("[ProfesorDAO] Se encontraron " + profesores.size() + " profesores");
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error al leer todos los profesores", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.close();
                    LOGGER.info("[ProfesorDAO] Conexiones cerradas");
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error al cerrar conexiones", e);
            }
        }
        
        return profesores;
    }
    
    @Override
    public boolean update(Profesor profesor) {
        String sqlUsuario = "UPDATE USUARIO SET nombre = ?, correo = ? WHERE id_usu = ?";
        String sqlProfesor = "UPDATE PROFESOR SET fecha_nacimiento = ?, direccion = ?, telefono = ?, grado_academico = ?, especializacion = ?, fecha_contratacion = ?, estado = ? WHERE id_profesor = ?";
        
        try {
            LOGGER.info("[ProfesorDAO] Actualizando profesor ID: " + profesor.getId());
            conn = conexion.crearConexion();
            conn.setAutoCommit(false);
            
            // Actualizar tabla USUARIO
            ps = conn.prepareStatement(sqlUsuario);
            ps.setString(1, profesor.getNombre());
            ps.setString(2, profesor.getCorreo());
            ps.setInt(3, profesor.getId_usu());
            LOGGER.info("[ProfesorDAO] SQL Usuario: " + sqlUsuario + " | Parámetros: " + profesor.getNombre() + ", " + profesor.getCorreo() + ", " + profesor.getId_usu());
            LOGGER.info("[ProfesorDAO] Actualizando información de usuario...");
            int resultado1 = ps.executeUpdate();
            LOGGER.info("[ProfesorDAO] Filas afectadas en USUARIO: " + resultado1);
            
            // Actualizar tabla PROFESOR
            ps = conn.prepareStatement(sqlProfesor);
            
            // Manejo de fecha de nacimiento
            java.sql.Date sqlFechaNac = null;
            if (profesor.getFechaNacimiento() != null) {
                sqlFechaNac = new java.sql.Date(profesor.getFechaNacimiento().getTime());
                LOGGER.info("[ProfesorDAO] Fecha de nacimiento para actualización: " + sqlFechaNac);
            } else {
                LOGGER.info("[ProfesorDAO] Fecha de nacimiento es NULL para actualización");
            }
            ps.setDate(1, sqlFechaNac);
            
            ps.setString(2, profesor.getDireccion());
            ps.setString(3, profesor.getTelefono());
            ps.setString(4, profesor.getGradoAcademico());
            ps.setString(5, profesor.getEspecializacion());
            
            // Manejo de fecha de contratación
            java.sql.Timestamp sqlFechaContratacion = null;
            if (profesor.getFechaContratacion() != null) {
                sqlFechaContratacion = new java.sql.Timestamp(profesor.getFechaContratacion().getTime());
                LOGGER.info("[ProfesorDAO] Fecha de contratación para actualización: " + sqlFechaContratacion);
            } else {
                LOGGER.info("[ProfesorDAO] Fecha de contratación es NULL para actualización");
            }
            ps.setTimestamp(6, sqlFechaContratacion);
            
            ps.setString(7, profesor.getEstado());
            ps.setInt(8, profesor.getId());
            
            LOGGER.info("[ProfesorDAO] SQL Profesor: " + sqlProfesor + 
                       " | Parámetros: fechaNac=" + sqlFechaNac +
                       ", dirección=" + profesor.getDireccion() +
                       ", teléfono=" + profesor.getTelefono() +
                       ", gradoAcad=" + profesor.getGradoAcademico() +
                       ", espec=" + profesor.getEspecializacion() +
                       ", fechaContr=" + sqlFechaContratacion +
                       ", estado=" + profesor.getEstado() +
                       ", id=" + profesor.getId());
            
            LOGGER.info("[ProfesorDAO] Actualizando información de profesor...");
            int resultado2 = ps.executeUpdate();
            LOGGER.info("[ProfesorDAO] Filas afectadas en PROFESOR: " + resultado2);
            
            conn.commit();
            LOGGER.info("[ProfesorDAO] Actualización completada exitosamente");
            return resultado1 > 0 && resultado2 > 0;
            
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                    LOGGER.warning("[ProfesorDAO] Transacción revertida");
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error en rollback", ex);
            }
            LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error SQL al actualizar profesor - Código: " + e.getErrorCode() + " - Estado SQL: " + e.getSQLState(), e);
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.close();
                    LOGGER.info("[ProfesorDAO] Conexiones cerradas");
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error al cerrar conexiones", e);
            }
        }
    }
    
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM USUARIO WHERE id_usu = (SELECT idUsuario FROM PROFESOR WHERE id_profesor = ?)";
        
        try {
            LOGGER.info("[ProfesorDAO] Eliminando profesor con ID: " + id);
            conn = conexion.crearConexion();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int resultado = ps.executeUpdate();
            LOGGER.info("[ProfesorDAO] Filas afectadas: " + resultado);
            boolean exito = resultado > 0;
            
            if (exito) {
                LOGGER.info("[ProfesorDAO] Profesor eliminado exitosamente");
            } else {
                LOGGER.warning("[ProfesorDAO] No se pudo eliminar el profesor con ID: " + id);
            }
            
            return exito;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error al eliminar profesor con ID: " + id, e);
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "[ProfesorDAO] Error al cerrar conexiones", e);
            }
        }
    }
}