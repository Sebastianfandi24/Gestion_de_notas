package Controllers;

import Models.Profesor;
import DAOs.ProfesorDAO; // Added missing import
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException; // Added import
import java.text.SimpleDateFormat; // Added import
import java.util.Date; // Added import
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Controlador para gestionar los profesores del sistema
 */
@WebServlet("/ProfesoresController")
public class ProfesoresController extends HttpServlet {

    private final ProfesorDAO profesorDAO;
    private final SimpleDateFormat dateFormat; // Added SimpleDateFormat instance

    public ProfesoresController() {
        this.profesorDAO = new ProfesorDAO();
        this.dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // Initialize SimpleDateFormat
    }
    
    /**
     * Maneja las solicitudes GET para obtener profesores
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            String idParam = request.getParameter("id");
            
            if (idParam != null) {
                // Obtener un profesor específico
                int id = Integer.parseInt(idParam);
                Profesor profesor = obtenerProfesorPorId(id);
                
                if (profesor != null) {
                    JSONObject jsonProfesor = new JSONObject();
                    jsonProfesor.put("id_profesor", profesor.getId());
                    jsonProfesor.put("nombre", profesor.getNombre());
                    jsonProfesor.put("correo", profesor.getCorreo());
                    jsonProfesor.put("fecha_nacimiento", profesor.getFechaNacimiento());
                    jsonProfesor.put("telefono", profesor.getTelefono());
                    jsonProfesor.put("grado_academico", profesor.getGradoAcademico());
                    jsonProfesor.put("especializacion", profesor.getEspecializacion());
                    jsonProfesor.put("fecha_contratacion", profesor.getFechaContratacion());
                    jsonProfesor.put("estado", profesor.getEstado());
                    jsonProfesor.put("direccion", profesor.getDireccion());
                    
                    out.print(jsonProfesor.toString());
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(new JSONObject().put("error", "Profesor no encontrado").toString());
                }
            } else {
                // Obtener todos los profesores
                List<Profesor> profesores = obtenerTodosProfesores();
                JSONArray jsonArray = new JSONArray();
                
                for (Profesor profesor : profesores) {
                    JSONObject jsonProfesor = new JSONObject();
                    jsonProfesor.put("id_profesor", profesor.getId());
                    jsonProfesor.put("nombre", profesor.getNombre());
                    jsonProfesor.put("correo", profesor.getCorreo());
                    jsonProfesor.put("fecha_nacimiento", profesor.getFechaNacimiento());
                    jsonProfesor.put("telefono", profesor.getTelefono());
                    jsonProfesor.put("grado_academico", profesor.getGradoAcademico());
                    jsonProfesor.put("especializacion", profesor.getEspecializacion());
                    jsonProfesor.put("fecha_contratacion", profesor.getFechaContratacion());
                    jsonProfesor.put("estado", profesor.getEstado());
                    jsonProfesor.put("direccion", profesor.getDireccion());
                    
                    jsonArray.put(jsonProfesor);
                }
                
                out.print(jsonArray.toString());
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print(new JSONObject().put("error", e.getMessage()).toString());
        }
    }

    /**
     * Maneja las solicitudes POST para crear profesores
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Leer el cuerpo de la solicitud
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }

            JSONObject jsonRequest = new JSONObject(sb.toString());

            // Crear objeto Profesor
            Profesor profesor = new Profesor();
            profesor.setNombre(jsonRequest.getString("nombre"));
            profesor.setCorreo(jsonRequest.getString("correo"));
            profesor.setTelefono(jsonRequest.optString("telefono", null));
            profesor.setGradoAcademico(jsonRequest.optString("grado_academico", null));
            profesor.setEspecializacion(jsonRequest.optString("especializacion", null));
            profesor.setEstado(jsonRequest.optString("estado", "Activo"));
            profesor.setDireccion(jsonRequest.optString("direccion", null));
            profesor.setIdRol(2); // Assuming Rol 2 is Profesor

            // Parse dates
            String fechaNacStr = jsonRequest.optString("fecha_nacimiento", null);
            if (fechaNacStr != null && !fechaNacStr.isEmpty()) {
                try {
                    profesor.setFechaNacimiento(dateFormat.parse(fechaNacStr));
                } catch (ParseException e) {
                    throw new ServletException("Formato de fecha de nacimiento inválido", e);
                }
            }

            String fechaContratacionStr = jsonRequest.optString("fecha_contratacion", null);
            if (fechaContratacionStr != null && !fechaContratacionStr.isEmpty()) {
                try {
                    profesor.setFechaContratacion(dateFormat.parse(fechaContratacionStr));
                } catch (ParseException e) {
                    throw new ServletException("Formato de fecha de contratación inválido", e);
                }
            }

            // Guardar el profesor
            boolean exito = crearProfesor(profesor);

            if (exito) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                response.getWriter().print(new JSONObject().put("mensaje", "Profesor creado exitosamente").toString());
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print(new JSONObject().put("error", "Error al crear el profesor").toString());
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Changed to BAD_REQUEST for parsing errors
            response.getWriter().print(new JSONObject().put("error", e.getMessage()).toString());
        }
    }

    /**
     * Maneja las solicitudes PUT para actualizar profesores
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Leer el cuerpo de la solicitud
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }

            JSONObject jsonRequest = new JSONObject(sb.toString());

            // Crear objeto Profesor
            Profesor profesor = new Profesor();
            profesor.setId(jsonRequest.getInt("id_profesor")); // Use setId for the primary key
            profesor.setIdUsu(jsonRequest.getInt("id_usu")); // Need id_usu for update
            profesor.setNombre(jsonRequest.getString("nombre"));
            profesor.setCorreo(jsonRequest.getString("correo"));
            profesor.setTelefono(jsonRequest.optString("telefono", null));
            profesor.setGradoAcademico(jsonRequest.optString("grado_academico", null));
            profesor.setEspecializacion(jsonRequest.optString("especializacion", null));
            profesor.setEstado(jsonRequest.optString("estado", "Activo"));
            profesor.setDireccion(jsonRequest.optString("direccion", null));

            // Parse dates
            String fechaNacStr = jsonRequest.optString("fecha_nacimiento", null);
            if (fechaNacStr != null && !fechaNacStr.isEmpty()) {
                try {
                    profesor.setFechaNacimiento(dateFormat.parse(fechaNacStr));
                } catch (ParseException e) {
                    throw new ServletException("Formato de fecha de nacimiento inválido", e);
                }
            }

            String fechaContratacionStr = jsonRequest.optString("fecha_contratacion", null);
            if (fechaContratacionStr != null && !fechaContratacionStr.isEmpty()) {
                try {
                    profesor.setFechaContratacion(dateFormat.parse(fechaContratacionStr));
                } catch (ParseException e) {
                    throw new ServletException("Formato de fecha de contratación inválido", e);
                }
            }

            // Actualizar el profesor
            boolean exito = actualizarProfesor(profesor);

            if (exito) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().print(new JSONObject().put("mensaje", "Profesor actualizado exitosamente").toString());
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print(new JSONObject().put("error", "Error al actualizar el profesor").toString());
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Changed to BAD_REQUEST for parsing errors
            response.getWriter().print(new JSONObject().put("error", e.getMessage()).toString());
        }
    }

    /**
     * Maneja las solicitudes DELETE para eliminar profesores
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String idParam = request.getParameter("id");
            
            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                boolean exito = eliminarProfesor(id);
                
                if (exito) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().print(new JSONObject().put("mensaje", "Profesor eliminado exitosamente").toString());
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().print(new JSONObject().put("error", "Error al eliminar el profesor").toString());
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print(new JSONObject().put("error", "ID de profesor no proporcionado").toString());
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print(new JSONObject().put("error", e.getMessage()).toString());
        }
    }
    
    // Métodos auxiliares para interactuar con la base de datos
    
    // Removed duplicate ProfesorDAO instance

    private Profesor obtenerProfesorPorId(int id) {
        return profesorDAO.read(id);
    }

    private List<Profesor> obtenerTodosProfesores() {
        return profesorDAO.readAll();
    }

    private boolean crearProfesor(Profesor profesor) {
        return profesorDAO.create(profesor);
    }

    private boolean actualizarProfesor(Profesor profesor) {
        return profesorDAO.update(profesor);
    }

    private boolean eliminarProfesor(int id) {
        return profesorDAO.delete(id);
    }
}