package Controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard/*"})
public class DashboardServlet extends HttpServlet {

    // Configuración de menús por rol
    private static final Map<String, String[][]> MENU_CONFIG = new HashMap<>();
    
    static {
        // Menú para Administrador (rol 3)
        MENU_CONFIG.put("3", new String[][] {
            {"Dashboard", "bi bi-speedometer2", "/admin/index.jsp"},
            {"Gestión de Profesores", "bi bi-person-badge", "/admin/profesores.jsp"},
            {"Gestión de Estudiantes", "bi bi-people", "/admin/estudiantes.jsp"},
            {"Gestión de Cursos", "bi bi-journal-bookmark", "/admin/cursos.jsp"},
            {"Gestión de Actividades", "bi bi-list-check", "/admin/actividades.jsp"}
        });
        
        // Menú para Profesor (rol 2)
        MENU_CONFIG.put("2", new String[][] {
            {"Dashboard", "bi bi-speedometer2", "/profesor/index.jsp"},
            {"Mis Cursos", "bi bi-journal-text", "/profesor/cursos.jsp"},
            {"Gestión de Tareas", "bi bi-list-task", "/profesor/tareas.jsp"},
            {"Gestión de Notas", "bi bi-star", "/profesor/notas.jsp"}
        });
        
        // Menú para Estudiante (rol 1)
        MENU_CONFIG.put("1", new String[][] {
            {"Dashboard", "bi bi-speedometer2", "/estudiante/index.jsp"},
            {"Mis Cursos", "bi bi-journal-text", "/estudiante/cursos.jsp"},
            {"Mis Tareas", "bi bi-list-task", "/estudiante/tareas.jsp"},
            {"Mis Notas", "bi bi-star", "/estudiante/notas.jsp"}
        });
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userRol = "";
    
        // Verificar si hay una sesión activa
        if (session != null && session.getAttribute("userRol") != null) {
            userRol = session.getAttribute("userRol").toString();
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
    
        // Obtener los elementos del menú para el rol del usuario
        String[][] menuItems = MENU_CONFIG.get(userRol);
        if (menuItems == null || menuItems.length == 0) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso no autorizado para este rol");
            return;
        }
    
        // Obtener la ruta solicitada
        String pathInfo = request.getPathInfo();
        String requestURI = request.getRequestURI();

        // Log only once per request
        if (pathInfo != null && !pathInfo.equals("/index.jsp")) {
            System.out.println("[DashboardServlet] Path solicitado: " + pathInfo);
            System.out.println("[DashboardServlet] URI solicitada: " + requestURI);
        }

        // Página por defecto para el rol
        String defaultPage = menuItems[0][2];
        String targetPage = null;
        boolean rutaValida = false;

        // Si no hay pathInfo o es solo una barra, cargar menú en sesión y redirigir a /dashboard/index.jsp
        if (pathInfo == null || pathInfo.equals("/")) {
            session.setAttribute("menuItems", menuItems);
            response.sendRedirect(request.getContextPath() + "/dashboard/index.jsp");
            return;
        } else if (pathInfo.equals("/index.jsp")) {
            // Si la petición es a /dashboard/index.jsp, no hacer nada, dejar que el JSP maneje la vista principal
            session.setAttribute("menuItems", menuItems);
            response.sendRedirect(request.getContextPath() + "/dashboard/index.jsp");
            return;
        } else {
            // Verificar si la ruta está en el menú del usuario
            for (String[] item : menuItems) {
                if (pathInfo.equals(item[2]) || pathInfo.equals("/index.jsp")) {
                    targetPage = item[2];
                    rutaValida = true;
                    break;
                }
            }
        }

        if (!rutaValida) {
            // Si la ruta no es válida, redirigir al dashboard principal
            response.sendRedirect(request.getContextPath() + "/dashboard" + defaultPage);
            return;
        }

        // Configurar atributos para la vista
        request.setAttribute("currentPath", targetPage);
        request.setAttribute("includePage", targetPage); // Establecer la página a incluir
        session.setAttribute("menuItems", menuItems);

        // Hacer forward al layout principal
        try {
            request.getRequestDispatcher("/dashboard/index.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("[DashboardServlet] Error al procesar la solicitud: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la solicitud");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Procesar solicitudes POST si es necesario
        doGet(request, response);
    }
}