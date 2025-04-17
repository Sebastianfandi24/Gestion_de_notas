<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Administrador</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Sistema Académico</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="mostrarProfesores()">Profesores</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="mostrarEstudiantes()">Estudiantes</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="mostrarCursos()">Cursos</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="mostrarActividades()">Actividades</a>
                    </li>
                </ul>
                <form class="d-flex" action="${pageContext.request.contextPath}/login?action=logout" method="get">
                    <button class="btn btn-outline-light" type="submit">Cerrar Sesión</button>
                </form>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <iframe id="contentFrame" src="" style="width: 100%; height: 80vh; border: none;"></iframe>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function loadContent(page) {
            document.getElementById('contentFrame').src = page;
        }

        function mostrarProfesores() {
            loadContent('profesores.jsp');
        }

        function mostrarEstudiantes() {
            loadContent('estudiantes.jsp');
        }

        function mostrarCursos() {
            loadContent('cursos.jsp');
        }

        function mostrarActividades() {
            loadContent('actividades.jsp');
        }

        // Cargar Profesores por defecto al iniciar
        document.addEventListener('DOMContentLoaded', () => {
            mostrarProfesores(); // O la página que quieras cargar por defecto
        });
    </script>
</body>
</html>