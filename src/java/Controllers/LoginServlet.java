package Controllers;

import DAOs.UsuarioDAO;
import Models.Usuario;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            usuarioDAO = new UsuarioDAO();
        } catch (SQLException e) {
            throw new ServletException("Error initializing UsuarioDAO", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String correo = request.getParameter("email");
        String contraseña = request.getParameter("password");
        String mensaje = "";

        System.out.println("[LoginServlet] Intento de inicio de sesión - Email: " + correo);

        try {
            Usuario usuario = usuarioDAO.autenticarUsuario(correo, contraseña);
                        if (usuario != null) {
                System.out.println("[LoginServlet] Autenticación exitosa - Usuario: " + usuario.getNombre() + ", Rol: " + usuario.getIdRol());
                // Actualizar última conexión
                usuario.setUltimaConexion(new Date(System.currentTimeMillis()));
                usuarioDAO.actualizarUltimaConexion(usuario);
                
                // Iniciar sesión
                HttpSession session = request.getSession();
                session.setAttribute("userId", usuario.getId());
                session.setAttribute("userNombre", usuario.getNombre());
                session.setAttribute("userRol", usuario.getIdRol());
                
                // Redirigir según rol
                switch (usuario.getIdRol()) {
                    case 3: // Administrador
                        System.out.println("[LoginServlet] Redirigiendo a dashboard de administrador");
                        response.sendRedirect(request.getContextPath() + "/dashboard/");
                        break;
                    case 2: // Profesor
                        System.out.println("[LoginServlet] Redirigiendo a dashboard de profesor");
                        response.sendRedirect(request.getContextPath() + "/dashboard/");
                        break;
                    case 1: // Estudiante
                        System.out.println("[LoginServlet] Redirigiendo a dashboard de estudiante");
                        response.sendRedirect(request.getContextPath() + "/dashboard/");
                        break;
                    default:
                        mensaje = "Rol no válido";
                        System.out.println("[LoginServlet] Error - Rol no válido: " + usuario.getIdRol());
                        request.setAttribute("error", mensaje);
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                mensaje = "Credenciales inválidas";
                System.out.println("[LoginServlet] Error - Credenciales inválidas para el email: " + correo);
                request.setAttribute("error", mensaje);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            mensaje = "Error en el servidor: " + e.getMessage();
            System.out.println("[LoginServlet] Error del servidor: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", mensaje);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                System.out.println("[LoginServlet] Cerrando sesión - Usuario: " + session.getAttribute("userNombre"));
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}