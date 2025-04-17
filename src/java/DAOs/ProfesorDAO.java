package DAOs;

import Interfaces.CRUD;
import Models.Conexion;
import Models.Profesor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProfesorDAO implements CRUD<Profesor> {
    private final Conexion conexion;
    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;
    
    public ProfesorDAO() {
        this.conexion = new Conexion();
    }
    
    @Override
    public boolean create(Profesor profesor) {
        System.out.println("[ProfesorDAO] Iniciando creación de nuevo profesor: " + profesor.getNombre());
        String sqlUsuario = "INSERT INTO USUARIO (nombre, correo, id_rol, fecha_creacion) VALUES (?, ?, ?, NOW())";
        String sqlProfesor = "INSERT INTO PROFESOR (idUsuario, fecha_nacimiento, direccion, telefono, grado_academico, especializacion, fecha_contratacion, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            conn = conexion.crearConexion();
            conn.setAutoCommit(false);
            System.out.println("[ProfesorDAO] Iniciando transacción...");
            
            // Insertar en la tabla USUARIO
            ps = conn.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, profesor.getNombre());
            ps.setString(2, profesor.getCorreo());
            ps.setInt(3, profesor.getIdRol());
            System.out.println("[ProfesorDAO] Insertando en tabla USUARIO...");
            ps.executeUpdate();
            
            // Obtener el ID generado para el usuario
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int idUsuario = rs.getInt(1);
                
                // Insertar en la tabla PROFESOR
                ps = conn.prepareStatement(sqlProfesor);
                ps.setInt(1, idUsuario);
                ps.setString(3, profesor.getDireccion());
                ps.setString(4, profesor.getTelefono());
                ps.setString(5, profesor.getGradoAcademico());
                ps.setString(6, profesor.getEspecializacion());
                ps.setDate(7, profesor.getFechaContratacion() != null ? new java.sql.Date(profesor.getFechaContratacion().getTime()) : null);
                ps.setString(8, profesor.getEstado());
                ps.executeUpdate();
                
                conn.commit();
                return true;
            }
            
            System.out.println("[ProfesorDAO] Error: No se pudo obtener el ID de usuario generado");
            conn.rollback();
            return false;
            
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                    System.out.println("[ProfesorDAO] Transacción revertida");
                }
            } catch (SQLException ex) {
                System.err.println("[ProfesorDAO] Error en rollback - " + ex.getMessage());
                ex.printStackTrace();
            }
            System.err.println("[ProfesorDAO] Error al crear profesor - Código: " + e.getErrorCode());
            System.err.println("[ProfesorDAO] Mensaje: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.close();
                    System.out.println("[ProfesorDAO] Conexiones cerradas");
                }
            } catch (SQLException e) {
                System.err.println("[ProfesorDAO] Error al cerrar conexiones - " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
    
    @Override
    public Profesor read(int id) {
        String sql = "SELECT u.*, p.* FROM USUARIO u INNER JOIN PROFESOR p ON u.id_usu = p.idUsuario WHERE p.id_profesor = ?";
        Profesor profesor = null;
        
        try {
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
            }
            
        } catch (SQLException e) {
            System.out.println("Error al leer profesor - " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.close();
                    System.out.println("[ProfesorDAO] Conexiones cerradas");
                }
            } catch (SQLException e) {
                System.err.println("[ProfesorDAO] Error al cerrar conexiones - " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return profesor;
    }
    
    @Override
    public List<Profesor> readAll() {
        String sql = "SELECT u.*, p.* FROM USUARIO u INNER JOIN PROFESOR p ON u.id_usu = p.idUsuario";
        List<Profesor> profesores = new ArrayList<>();
        
        try {
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
            
        } catch (SQLException e) {
            System.out.println("Error al leer todos los profesores - " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.close();
                    System.out.println("[ProfesorDAO] Conexiones cerradas");
                }
            } catch (SQLException e) {
                System.err.println("[ProfesorDAO] Error al cerrar conexiones - " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return profesores;
    }
    
    @Override
    public boolean update(Profesor profesor) {
        String sqlUsuario = "UPDATE USUARIO SET nombre = ?, correo = ? WHERE id_usu = ?";
        String sqlProfesor = "UPDATE PROFESOR SET fecha_nacimiento = ?, direccion = ?, telefono = ?, grado_academico = ?, especializacion = ?, fecha_contratacion = ?, estado = ? WHERE id_profesor = ?";
        
        try {
            conn = conexion.crearConexion();
            conn.setAutoCommit(false);
            
            // Actualizar tabla USUARIO
            ps = conn.prepareStatement(sqlUsuario);
            ps.setString(1, profesor.getNombre());
            ps.setString(2, profesor.getCorreo());
            ps.setInt(3, profesor.getId_usu());
            ps.executeUpdate();
            
            // Actualizar tabla PROFESOR
            ps = conn.prepareStatement(sqlProfesor);
            ps.setDate(1, profesor.getFecha_nacimiento() != null ? new java.sql.Date(profesor.getFecha_nacimiento().getTime()) : null);
            ps.setString(2, profesor.getDireccion());
            ps.setString(3, profesor.getTelefono());
            ps.setString(4, profesor.getGrado_academico());
            ps.setString(5, profesor.getEspecializacion());
            ps.setDate(6, profesor.getFecha_contratacion() != null ? new java.sql.Date(profesor.getFecha_contratacion().getTime()) : null);
            ps.setString(7, profesor.getEstado());
            ps.setInt(8, profesor.getId_profesor());
            ps.executeUpdate();
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                System.out.println("Error en rollback - " + ex.getMessage());
            }
            System.out.println("Error al actualizar profesor - " + e.getMessage());
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones - " + e.getMessage());
            }
        }
    }
    
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM USUARIO WHERE id_usu = (SELECT idUsuario FROM PROFESOR WHERE id_profesor = ?)";
        
        try {
            conn = conexion.crearConexion();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int resultado = ps.executeUpdate();
            return resultado > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al eliminar profesor - " + e.getMessage());
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones - " + e.getMessage());
            }
        }
    }
}