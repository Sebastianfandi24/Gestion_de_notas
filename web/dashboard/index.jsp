<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema Académico</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome para iconos -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
        }
        .sidebar .nav-link {
            color: #fff;
            padding: 0.5rem 1rem;
            margin: 0.2rem 0;
        }
        .sidebar .nav-link:hover {
            background-color: #495057;
        }
        .sidebar .nav-link.active {
            background-color: #0d6efd;
        }
        .main-content {
            padding: 20px;
        }
        .content-frame {
            width: 100%;
            height: calc(100vh - 100px);
            border: none;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0 sidebar">
                <div class="d-flex flex-column">
                    <div class="p-3 text-white">
                        <h5>Sistema Académico</h5>
                        <p class="mb-0" id="userRole">Rol: ${sessionScope.userRole}</p>
                    </div>
                    <!-- El menú se cargará dinámicamente según el rol -->
                    <nav class="nav flex-column" id="sidebarMenu">
                        <!-- El contenido del menú se cargará mediante JavaScript -->
                    </nav>
                </div>
            </div>

            <!-- Contenido principal -->
            <div class="col-md-9 col-lg-10 main-content">
                <iframe id="contentFrame" class="content-frame" src="" title="Contenido"></iframe>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS y Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

    <script>
        // Configuración del menú según el rol
        const menuConfig = {
            'Administrador': [
                { title: 'Gestión de Profesores', icon: 'fas fa-chalkboard-teacher', url: 'admin/profesores.jsp' },
                { title: 'Gestión de Estudiantes', icon: 'fas fa-user-graduate', url: 'admin/estudiantes.jsp' },
                { title: 'Gestión de Cursos', icon: 'fas fa-book', url: 'admin/cursos.jsp' },
                { title: 'Gestión de Actividades', icon: 'fas fa-tasks', url: 'admin/actividades.jsp' }
            ],
            'Profesor': [
                { title: 'Mis Cursos', icon: 'fas fa-book', url: 'profesor/cursos.jsp' },
                { title: 'Gestión de Tareas', icon: 'fas fa-tasks', url: 'profesor/tareas.jsp' },
                { title: 'Gestión de Notas', icon: 'fas fa-star', url: 'profesor/notas.jsp' }
            ],
            'Estudiante': [
                { title: 'Mis Cursos', icon: 'fas fa-book', url: 'estudiante/cursos.jsp' },
                { title: 'Mis Tareas', icon: 'fas fa-tasks', url: 'estudiante/tareas.jsp' },
                { title: 'Mis Notas', icon: 'fas fa-star', url: 'estudiante/notas.jsp' }
            ]
        };

        // Función para cargar el menú según el rol
        function loadMenu() {
            const userRole = document.getElementById('userRole').textContent.split(': ')[1];
            const menuItems = menuConfig[userRole] || [];
            const sidebarMenu = document.getElementById('sidebarMenu');
            
            sidebarMenu.innerHTML = menuItems.map(item => `
                <a class="nav-link" href="#" onclick="loadContent('${item.url}')">
                    <i class="${item.icon} me-2"></i>
                    ${item.title}
                </a>
            `).join('');

            // Cargar el primer contenido por defecto
            if (menuItems.length > 0) {
                loadContent(menuItems[0].url);
            }
        }

        // Función para cargar contenido en el iframe
        function loadContent(url) {
            document.getElementById('contentFrame').src = url;
            // Actualizar clase active en el menú
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('onclick').includes(url)) {
                    link.classList.add('active');
                }
            });
        }

        // Cargar el menú cuando se carga la página
        window.onload = loadMenu;
    </script>
</body>
</html>