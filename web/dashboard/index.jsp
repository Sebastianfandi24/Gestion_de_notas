<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema Académico</title>
    <!-- Bootstrap 5 CSS y otros recursos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, #e3eafc 0%, #d1e7dd 100%);
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        .sidebar .nav-link {
            color: #fff;
            background-color: #0d6efd;
            font-weight: 500;
            border-radius: 10px;
            margin: 0.5rem 1rem;
            padding: 0.8rem 1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: flex-start; /* Asegura que el contenido (icono + texto) empiece desde la izquierda */
            overflow: hidden; /* Evita que el texto se desborde si es muy largo */
            text-overflow: ellipsis; /* Añade puntos suspensivos si el texto no cabe */
            white-space: nowrap; /* Evita que el texto salte a la siguiente línea */
        }
        .sidebar .nav-link:hover {
            background-color: rgba(13, 110, 253, 0.8); /* Ajustado hover para fondo azul */
            color: #fff; /* Mantenido blanco en hover */
            transform: translateX(5px);
        }
        .sidebar .nav-link.active {
            background-color: #0a58ca; /* Ligeramente más oscuro para estado activo */
            color: #fff;
        }
        .main-content {
            padding: 2rem;
        }
        .content-frame {
            width: 100%;
            height: calc(100vh - 80px);
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }
        .user-info {
            background: rgba(255,255,255,0.9);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .system-title {
            font-size: 1.5rem;
            font-weight: bold;
            color: #0d6efd;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row g-0">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-3 sidebar">
                <div class="d-flex flex-column h-100">
                    <div class="user-info mt-4">
                        <div class="system-title">Sistema Académico</div>
                        <p class="mb-0 text-muted">
                            <i class="bi bi-person-circle me-2"></i>
                            Rol: <span>
                                <c:choose>
                                    <c:when test="${sessionScope.userRol == '3'}">Administrador</c:when>
                                    <c:when test="${sessionScope.userRol == '2'}">Profesor</c:when>
                                    <c:when test="${sessionScope.userRol == '1'}">Estudiante</c:when>
                                    <c:otherwise>Desconocido</c:otherwise>
                                </c:choose>
                            </span>
                        </p>
                    </div>
                    <!-- Menú generado desde el servlet, ahora obtenido de sessionScope -->
                    <nav class="nav flex-column flex-grow-1">
                        <c:if test="${empty sessionScope.menuItems}">
                            <!-- Si no hay menú en la sesión, redireccionar a dashboard para cargarlo -->
                            <c:redirect url="${pageContext.request.contextPath}/dashboard/" />
                        </c:if>
                        
                        <c:forEach var="item" items="${sessionScope.menuItems}">
                            <!-- Enlaces actualizados para trabajar correctamente con el servlet -->
                            <a class="nav-link ${currentPath == item[2] ? 'active' : ''}" 
                               href="${pageContext.request.contextPath}/dashboard${item[2]}"
                               data-page="${item[2]}">
                                <i class="${item[1]} me-2"></i>
                                ${item[0]}
                            </a>
                        </c:forEach>
                    </nav>
                    <div class="mt-auto mb-4">
                        <a href="${pageContext.request.contextPath}/login?action=logout" class="btn btn-outline-danger w-100">
                            <i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión
                        </a>
                    </div>
                </div>
            </div>

            <!-- Contenido principal -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Panel de contenido dinámico -->
                <div id="content-container" class="content-frame">
                    <div class="d-flex justify-content-center align-items-center h-100">
                        <div class="text-center">
                            <h2>Bienvenido al Sistema Académico</h2>
                            <p class="lead">Cargando contenido...</p>
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Cargando...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS y Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
    
    <!-- Script para manejar la navegación mediante AJAX -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const contentContainer = document.getElementById('content-container');
            
            // Función para cargar contenido mediante AJAX
            function loadContent(url) {
                // Mostrar indicador de carga
                contentContainer.innerHTML = `
                    <div class="d-flex justify-content-center align-items-center h-100">
                        <div class="text-center">
                            <h2>Cargando contenido...</h2>
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Cargando...</span>
                            </div>
                        </div>
                    </div>
                `;
                
                console.log("Cargando URL:", url);
                
                fetch(url)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Error en la respuesta del servidor');
                        }
                        return response.text();
                    })
                    .then(html => {
                        console.log("Respuesta recibida, longitud:", html.length);
                        
                        // Extraer solo la parte relevante según el tipo de página
                        if (url.includes('profesores.jsp') || 
                            url.includes('cursos.jsp') || 
                            url.includes('estudiantes.jsp') || 
                            url.includes('actividades.jsp')) {
                            
                            // Para páginas de gestión, extraer solo el container-fluid
                            const containerStart = html.indexOf('<div class="container-fluid');
                            const scriptStart = html.lastIndexOf('<script');
                            
                            if (containerStart !== -1 && scriptStart !== -1) {
                                // Extraer el contenedor principal y los scripts
                                const mainContent = html.substring(containerStart, scriptStart);
                                const scriptsContent = html.substring(scriptStart);
                                
                                contentContainer.innerHTML = mainContent;
                                
                                // Añadir los scripts manualmente
                                const scriptEndIndex = scriptsContent.indexOf('</body>');
                                if (scriptEndIndex !== -1) {
                                    const scripts = scriptsContent.substring(0, scriptEndIndex);
                                    
                                    // Crear un div temporal para extraer los scripts
                                    const tempDiv = document.createElement('div');
                                    tempDiv.innerHTML = scripts;
                                    
                                    // Añadir cada script al documento
                                    const scriptElements = tempDiv.querySelectorAll('script');
                                    scriptElements.forEach(script => {
                                        const newScript = document.createElement('script');
                                        
                                        // Copiar atributos
                                        Array.from(script.attributes).forEach(attr => {
                                            newScript.setAttribute(attr.name, attr.value);
                                        });
                                        
                                        // Copiar contenido interno
                                        newScript.textContent = script.textContent;
                                        document.body.appendChild(newScript);
                                    });
                                }
                            } else {
                                // Si no se encuentra el formato esperado, usar el cuerpo completo
                                contentContainer.innerHTML = extractContentFromPage(html);
                            }
                        } else if (url.includes('admin/index.jsp')) {
                            // Para la página principal de administrador
                            contentContainer.innerHTML = `
                                <div class="container-fluid py-4">
                                    ${extractMainContentFromAdminPage(html)}
                                </div>
                            `;
                        } else {
                            // Para otras páginas
                            contentContainer.innerHTML = extractContentFromPage(html);
                        }
                        
                        console.log("Contenido cargado en el contenedor");
                    })
                    .catch(error => {
                        console.error('Error al cargar contenido:', error);
                        contentContainer.innerHTML = `
                            <div class="alert alert-danger">
                                Error al cargar el contenido: ${error.message}. 
                                Por favor, inténtelo de nuevo.
                            </div>
                        `;
                    });
                
                // Actualizar clase activa en el menú
                const menuItems = document.querySelectorAll('.nav-link');
                menuItems.forEach(item => {
                    if (item.getAttribute('href') === url) {
                        item.classList.add('active');
                    } else {
                        item.classList.remove('active');
                    }
                });
                
                return false;
            }
            
            // Función para extraer contenido de admin/index.jsp
            function extractMainContentFromAdminPage(html) {
                // Buscar el contenido dentro del div "container-fluid py-4"
                const startTag = '<div class="container-fluid py-4">';
                const endTag = '</div>\n\n    <script';
                
                let startPos = html.indexOf(startTag) + startTag.length;
                let endPos = html.indexOf(endTag);
                
                if (startPos !== -1 && endPos !== -1) {
                    return html.substring(startPos, endPos);
                }
                
                // Si no encontramos las etiquetas específicas, intentamos extraer el contenido del body
                return html.replace(/^[\s\S]*<body[^>]*>([\s\S]*)<\/body>[\s\S]*$/i, '$1');
            }
            
            // Función para extraer contenido de otras páginas
            function extractContentFromPage(html) {
                // Recortar todo antes de <body> y después de </body>
                return html.replace(/^[\s\S]*<body[^>]*>([\s\S]*)<\/body>[\s\S]*$/i, '$1');
            }
            
            // Añadir manejadores de evento a todos los enlaces del menú
            const menuLinks = document.querySelectorAll('.sidebar .nav-link');
            menuLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const url = this.getAttribute('href');
                    loadContent(url);
                });
            });
            
            // Cargar página inicial según el rol del usuario
            const userRole = '${sessionScope.userRol}';
            let initialPage = '';
            
            if (userRole === '3') initialPage = '${pageContext.request.contextPath}/dashboard/admin/index.jsp';
            else if (userRole === '2') initialPage = '${pageContext.request.contextPath}/dashboard/profesor/index.jsp';
            else if (userRole === '1') initialPage = '${pageContext.request.contextPath}/dashboard/estudiante/index.jsp';
            
            if (initialPage) {
                loadContent(initialPage);
            } else {
                // Si no hay rol definido, simplemente cargar la primera opción del menú
                const firstMenuItem = document.querySelector('.sidebar .nav-link');
                if (firstMenuItem) {
                    loadContent(firstMenuItem.getAttribute('href'));
                }
            }
        });
    </script>
</body>
</html>
``` 