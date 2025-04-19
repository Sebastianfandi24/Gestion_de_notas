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
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, #e3eafc 0%, #d1e7dd 100%);
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            z-index: 1000;
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
            justify-content: flex-start;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .sidebar .nav-link:hover {
            background-color: rgba(13, 110, 253, 0.8);
            color: #fff;
            transform: translateX(5px);
        }
        .sidebar .nav-link.active {
            background-color: #0a58ca;
            color: #fff;
        }
        .main-content {
            padding: 2rem;
            min-height: 100vh;
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
        
        /* Estilos para el contenido principal */
        .content-container {
            width: 100%;
            padding: 1.5rem;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
            min-height: calc(100vh - 8rem);
        }
        
        /* Estilos para página de bienvenida */
        .welcome-container {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            min-height: 60vh;
        }
        
        .welcome-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: #0d6efd;
        }
        
        .welcome-subtitle {
            font-size: 1.25rem;
            color: #6c757d;
            margin-bottom: 2rem;
        }
        
        /* Estilos para las tarjetas del dashboard */
        .dashboard-card {
            background-color: #fff;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.08);
            height: 100%;
            transition: all 0.3s ease;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.75rem 1.5rem rgba(0, 0, 0, 0.12);
        }
        
        .dashboard-card .card-title {
            color: #6c757d;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }
        
        .dashboard-card .card-value {
            color: #212529;
            font-size: 2rem;
            font-weight: 700;
        }
        
        .dashboard-card .card-icon {
            font-size: 2.5rem;
            opacity: 0.8;
            color: #0d6efd;
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
                    <!-- Menú generado desde el servlet -->
                    <nav class="nav flex-column flex-grow-1">
                        <c:if test="${empty sessionScope.menuItems}">
                            <!-- Si no hay menú en la sesión, redireccionar a dashboard para cargarlo -->
                            <c:redirect url="${pageContext.request.contextPath}/dashboard/" />
                        </c:if>
                        
                        <c:forEach var="item" items="${sessionScope.menuItems}">
                            <a class="nav-link menu-link ${currentPath == item[2] ? 'active' : ''}" 
                               href="${pageContext.request.contextPath}/dashboard${item[2]}">
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
                <div class="content-container">
                    <c:choose>
                        <c:when test="${not empty includePage}">
                            <c:set var="pageToInclude" value="${includePage}" scope="request" />
                            <% 
                                String pageToInclude = (String) request.getAttribute("pageToInclude");
                                System.out.println("[JSP] Mostrando página: " + pageToInclude);
                            %>
                            
                            <!-- CONTENIDO PARA DASHBOARD ADMINISTRADOR -->
                            <c:if test="${includePage == '/admin/index.jsp'}">
                                <!-- Contenido del dashboard de administrador -->
                                <div class="row g-4 mb-4">
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Cursos Activos</div>
                                                    <div class="card-value">3</div>
                                                </div>
                                                <i class="bi bi-journal-text card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Usuarios activos</div>
                                                    <div class="card-value">0</div>
                                                </div>
                                                <i class="bi bi-people card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Profesores Activos</div>
                                                    <div class="card-value">N/A</div>
                                                </div>
                                                <i class="bi bi-person-badge card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Actividades Activos</div>
                                                    <div class="card-value">0</div>
                                                </div>
                                                <i class="bi bi-list-check card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${includePage == '/admin/profesores.jsp'}">
                                <!-- Contenido de gestión de profesores -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Gestión de Profesores</h2>
                                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#profesorModal">
                                        <i class="fas fa-plus-circle me-2"></i> Nuevo Profesor
                                    </button>
                                </div>

                                <!-- Tabla de Profesores -->
                                <div class="card">
                                    <div class="card-body">
                                        <table id="profesoresTable" class="table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Nombre</th>
                                                    <th>Correo</th>
                                                    <th>Especialización</th>
                                                    <th>Estado</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Los datos se cargarán dinámicamente -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                                <!-- Modal para Crear/Editar Profesor -->
                                <div class="modal fade" id="profesorModal" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="modalTitle">Nuevo Profesor</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <!-- Formulario de profesor -->
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                <button type="button" class="btn btn-primary" onclick="guardarProfesor()">Guardar</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${includePage == '/admin/estudiantes.jsp'}">
                                <!-- Contenido de gestión de estudiantes -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Gestión de Estudiantes</h2>
                                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#estudianteModal">
                                        <i class="fas fa-plus-circle me-2"></i> Nuevo Estudiante
                                    </button>
                                </div>

                                <!-- Tabla de Estudiantes -->
                                <div class="card">
                                    <div class="card-body">
                                        <table id="estudiantesTable" class="table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Nombre</th>
                                                    <th>Correo</th>
                                                    <th>Identificación</th>
                                                    <th>Estado</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Los datos se cargarán dinámicamente -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${includePage == '/admin/cursos.jsp'}">
                                <!-- Contenido de gestión de cursos -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Gestión de Cursos</h2>
                                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#cursoModal">
                                        <i class="fas fa-plus-circle me-2"></i> Nuevo Curso
                                    </button>
                                </div>

                                <!-- Tabla de Cursos -->
                                <div class="card">
                                    <div class="card-body">
                                        <table id="cursosTable" class="table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Código</th>
                                                    <th>Nombre</th>
                                                    <th>Profesor</th>
                                                    <th>Estudiantes</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Los datos se cargarán dinámicamente -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${includePage == '/admin/actividades.jsp'}">
                                <!-- Contenido de gestión de actividades -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Gestión de Actividades</h2>
                                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#actividadModal">
                                        <i class="fas fa-plus-circle me-2"></i> Nueva Actividad
                                    </button>
                                </div>

                                <!-- Tabla de Actividades -->
                                <div class="card">
                                    <div class="card-body">
                                        <table id="actividadesTable" class="table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Título</th>
                                                    <th>Curso</th>
                                                    <th>Fecha Creación</th>
                                                    <th>Fecha Entrega</th>
                                                    <th>Estado</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Los datos se cargarán dinámicamente -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </c:if>
                            
                            <!-- CONTENIDO PARA DASHBOARD ESTUDIANTE -->
                            <c:if test="${includePage == '/estudiante/index.jsp'}">
                                <!-- Contenido del dashboard de estudiante -->
                                <div class="row g-4 mb-4">
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Mis Cursos</div>
                                                    <div class="card-value">2</div>
                                                </div>
                                                <i class="bi bi-journal-text card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Tareas Pendientes</div>
                                                    <div class="card-value">3</div>
                                                </div>
                                                <i class="bi bi-list-task card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Promedio</div>
                                                    <div class="card-value">8.5</div>
                                                </div>
                                                <i class="bi bi-star card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Actividades Próximas</div>
                                                    <div class="card-value">1</div>
                                                </div>
                                                <i class="bi bi-calendar-event card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Cursos activos -->
                                <div class="card mt-4">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0">Mis Cursos Activos</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>Curso</th>
                                                        <th>Profesor</th>
                                                        <th>Progreso</th>
                                                        <th>Ver detalles</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>Matemáticas Avanzadas</td>
                                                        <td>Prof. Juan Pérez</td>
                                                        <td>
                                                            <div class="progress" style="height: 10px;">
                                                                <div class="progress-bar bg-success" role="progressbar" style="width: 75%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <a href="#" class="btn btn-sm btn-primary">Ver curso</a>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Programación Java</td>
                                                        <td>Prof. Ana García</td>
                                                        <td>
                                                            <div class="progress" style="height: 10px;">
                                                                <div class="progress-bar bg-warning" role="progressbar" style="width: 45%;" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100"></div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <a href="#" class="btn btn-sm btn-primary">Ver curso</a>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${includePage == '/estudiante/cursos.jsp'}">
                                <!-- Contenido de cursos de estudiante -->
                                <div class="row mb-4">
                                    <div class="col-12">
                                        <h2>Mis Cursos</h2>
                                        <p>Lista de cursos en los que estás matriculado</p>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 col-lg-4 mb-4">
                                        <div class="card h-100">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">Matemáticas Avanzadas</h5>
                                            </div>
                                            <div class="card-body">
                                                <p><strong>Profesor:</strong> Juan Pérez</p>
                                                <p><strong>Código:</strong> MAT101</p>
                                                <div class="mb-3">
                                                    <strong>Progreso:</strong>
                                                    <div class="progress mt-2" style="height: 10px;">
                                                        <div class="progress-bar bg-success" role="progressbar" style="width: 75%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                                <p><strong>Calificación actual:</strong> 8.5/10</p>
                                            </div>
                                            <div class="card-footer">
                                                <a href="#" class="btn btn-primary btn-sm">Ver detalles</a>
                                                <a href="#" class="btn btn-outline-primary btn-sm">Ver tareas</a>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6 col-lg-4 mb-4">
                                        <div class="card h-100">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">Programación Java</h5>
                                            </div>
                                            <div class="card-body">
                                                <p><strong>Profesor:</strong> Ana García</p>
                                                <p><strong>Código:</strong> PRG202</p>
                                                <div class="mb-3">
                                                    <strong>Progreso:</strong>
                                                    <div class="progress mt-2" style="height: 10px;">
                                                        <div class="progress-bar bg-warning" role="progressbar" style="width: 45%;" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                                <p><strong>Calificación actual:</strong> 7.8/10</p>
                                            </div>
                                            <div class="card-footer">
                                                <a href="#" class="btn btn-primary btn-sm">Ver detalles</a>
                                                <a href="#" class="btn btn-outline-primary btn-sm">Ver tareas</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${includePage == '/estudiante/tareas.jsp'}">
                                <!-- Contenido de tareas de estudiante -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Mis Tareas</h2>
                                    <div>
                                        <select class="form-select form-select-sm me-2" style="display:inline-block; width:auto;">
                                            <option value="all">Todas las tareas</option>
                                            <option value="pending">Pendientes</option>
                                            <option value="completed">Completadas</option>
                                        </select>
                                        <select class="form-select form-select-sm" style="display:inline-block; width:auto;">
                                            <option value="all">Todos los cursos</option>
                                            <option value="mat101">Matemáticas Avanzadas</option>
                                            <option value="prg202">Programación Java</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="card">
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>Título</th>
                                                        <th>Curso</th>
                                                        <th>Fecha entrega</th>
                                                        <th>Estado</th>
                                                        <th>Calificación</th>
                                                        <th>Acciones</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>Ecuaciones Diferenciales</td>
                                                        <td>Matemáticas Avanzadas</td>
                                                        <td>25/04/2025</td>
                                                        <td><span class="badge bg-warning">Pendiente</span></td>
                                                        <td>-</td>
                                                        <td>
                                                            <button class="btn btn-sm btn-primary">Entregar</button>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Algoritmos de ordenamiento</td>
                                                        <td>Programación Java</td>
                                                        <td>27/04/2025</td>
                                                        <td><span class="badge bg-warning">Pendiente</span></td>
                                                        <td>-</td>
                                                        <td>
                                                            <button class="btn btn-sm btn-primary">Entregar</button>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Matrices y determinantes</td>
                                                        <td>Matemáticas Avanzadas</td>
                                                        <td>10/04/2025</td>
                                                        <td><span class="badge bg-success">Entregado</span></td>
                                                        <td>8.5</td>
                                                        <td>
                                                            <button class="btn btn-sm btn-secondary">Ver detalles</button>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Clases y objetos</td>
                                                        <td>Programación Java</td>
                                                        <td>05/04/2025</td>
                                                        <td><span class="badge bg-success">Entregado</span></td>
                                                        <td>9.0</td>
                                                        <td>
                                                            <button class="btn btn-sm btn-secondary">Ver detalles</button>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${includePage == '/estudiante/notas.jsp'}">
                                <!-- Contenido de notas de estudiante -->
                                <div class="row mb-4">
                                    <div class="col-12">
                                        <h2>Mis Calificaciones</h2>
                                        <p>Resumen de calificaciones por curso</p>
                                    </div>
                                </div>
                                
                                <div class="card mb-4">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0">Matemáticas Avanzadas</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-bordered">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Actividad</th>
                                                        <th>Fecha</th>
                                                        <th>Calificación</th>
                                                        <th>Comentarios</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>Matrices y determinantes</td>
                                                        <td>10/04/2025</td>
                                                        <td>8.5</td>
                                                        <td>Buen trabajo en general</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Álgebra lineal</td>
                                                        <td>01/04/2025</td>
                                                        <td>7.8</td>
                                                        <td>Faltan algunos conceptos clave</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Examen parcial</td>
                                                        <td>15/03/2025</td>
                                                        <td>9.0</td>
                                                        <td>Excelente dominio del tema</td>
                                                    </tr>
                                                </tbody>
                                                <tfoot class="table-secondary">
                                                    <tr>
                                                        <th colspan="2" class="text-end">Promedio:</th>
                                                        <th>8.43</th>
                                                        <td></td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="card">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0">Programación Java</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-bordered">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Actividad</th>
                                                        <th>Fecha</th>
                                                        <th>Calificación</th>
                                                        <th>Comentarios</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>Clases y objetos</td>
                                                        <td>05/04/2025</td>
                                                        <td>9.0</td>
                                                        <td>Excelente implementación</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Estructuras de control</td>
                                                        <td>20/03/2025</td>
                                                        <td>8.5</td>
                                                        <td>Buen manejo de condicionales</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Introducción a Java</td>
                                                        <td>05/03/2025</td>
                                                        <td>7.5</td>
                                                        <td>Conceptos básicos entendidos</td>
                                                    </tr>
                                                </tbody>
                                                <tfoot class="table-secondary">
                                                    <tr>
                                                        <th colspan="2" class="text-end">Promedio:</th>
                                                        <th>8.33</th>
                                                        <td></td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <!-- CONTENIDO PARA DASHBOARD PROFESOR -->
                            <c:if test="${includePage == '/profesor/index.jsp'}">
                                <!-- Contenido del dashboard de profesor -->
                                <div class="row g-4 mb-4">
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Mis Cursos</div>
                                                    <div class="card-value">3</div>
                                                </div>
                                                <i class="bi bi-journal-text card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Estudiantes</div>
                                                    <div class="card-value">45</div>
                                                </div>
                                                <i class="bi bi-people card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Tareas Pendientes</div>
                                                    <div class="card-value">12</div>
                                                </div>
                                                <i class="bi bi-list-check card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-sm-6">
                                        <div class="dashboard-card">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <div class="card-title">Promedio General</div>
                                                    <div class="card-value">7.8</div>
                                                </div>
                                                <i class="bi bi-star card-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row mt-4">
                                    <div class="col-lg-7">
                                        <!-- Cursos activos -->
                                        <div class="card mb-4">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">Mis Cursos Activos</h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="table-responsive">
                                                    <table class="table table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th>Curso</th>
                                                                <th>Estudiantes</th>
                                                                <th>Progreso</th>
                                                                <th>Acciones</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td>Matemáticas Avanzadas</td>
                                                                <td>15</td>
                                                                <td>
                                                                    <div class="progress" style="height: 10px;">
                                                                        <div class="progress-bar bg-success" role="progressbar" style="width: 75%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <a href="#" class="btn btn-sm btn-primary">Ver curso</a>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>Álgebra Lineal</td>
                                                                <td>12</td>
                                                                <td>
                                                                    <div class="progress" style="height: 10px;">
                                                                        <div class="progress-bar bg-warning" role="progressbar" style="width: 45%;" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100"></div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <a href="#" class="btn btn-sm btn-primary">Ver curso</a>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>Cálculo Diferencial</td>
                                                                <td>18</td>
                                                                <td>
                                                                    <div class="progress" style="height: 10px;">
                                                                        <div class="progress-bar bg-info" role="progressbar" style="width: 60%;" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <a href="#" class="btn btn-sm btn-primary">Ver curso</a>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-5">
                                        <!-- Tareas pendientes de calificar -->
                                        <div class="card">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">Tareas pendientes por calificar</h5>
                                            </div>
                                            <div class="card-body">
                                                <ul class="list-group">
                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                        Ecuaciones Diferenciales
                                                        <span class="badge bg-primary rounded-pill">8</span>
                                                    </li>
                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                        Matrices y Determinantes
                                                        <span class="badge bg-primary rounded-pill">4</span>
                                                    </li>
                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                        Examen parcial de Cálculo
                                                        <span class="badge bg-primary rounded-pill">12</span>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="card-footer">
                                                <a href="#" class="btn btn-primary btn-sm">Ver todas las tareas</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${includePage == '/profesor/cursos.jsp'}">
                                <!-- Contenido de cursos de profesor -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Mis Cursos</h2>
                                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#nuevaActividadModal">
                                        <i class="fas fa-plus-circle me-2"></i> Nueva Actividad
                                    </button>
                                </div>
                                
                                <div class="row">
                                    <div class="col-lg-4 mb-4">
                                        <div class="card h-100">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">Matemáticas Avanzadas</h5>
                                            </div>
                                            <div class="card-body">
                                                <p><strong>Código:</strong> MAT101</p>
                                                <p><strong>Estudiantes:</strong> 15</p>
                                                <div class="mb-3">
                                                    <strong>Progreso:</strong>
                                                    <div class="progress mt-2" style="height: 10px;">
                                                        <div class="progress-bar bg-success" role="progressbar" style="width: 75%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                                <p><strong>Promedio del curso:</strong> 8.2/10</p>
                                            </div>
                                            <div class="card-footer">
                                                <div class="btn-group" role="group">
                                                    <a href="#" class="btn btn-outline-primary btn-sm">Ver estudiantes</a>
                                                    <a href="#" class="btn btn-outline-primary btn-sm">Ver actividades</a>
                                                    <a href="#" class="btn btn-outline-primary btn-sm">Calificaciones</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-lg-4 mb-4">
                                        <div class="card h-100">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">Álgebra Lineal</h5>
                                            </div>
                                            <div class="card-body">
                                                <p><strong>Código:</strong> MAT202</p>
                                                <p><strong>Estudiantes:</strong> 12</p>
                                                <div class="mb-3">
                                                    <strong>Progreso:</strong>
                                                    <div class="progress mt-2" style="height: 10px;">
                                                        <div class="progress-bar bg-warning" role="progressbar" style="width: 45%;" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                                <p><strong>Promedio del curso:</strong> 7.5/10</p>
                                            </div>
                                            <div class="card-footer">
                                                <div class="btn-group" role="group">
                                                    <a href="#" class="btn btn-outline-primary btn-sm">Ver estudiantes</a>
                                                    <a href="#" class="btn btn-outline-primary btn-sm">Ver actividades</a>
                                                    <a href="#" class="btn btn-outline-primary btn-sm">Calificaciones</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-lg-4 mb-4">
                                        <div class="card h-100">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">Cálculo Diferencial</h5>
                                            </div>
                                            <div class="card-body">
                                                <p><strong>Código:</strong> MAT303</p>
                                                <p><strong>Estudiantes:</strong> 18</p>
                                                <div class="mb-3">
                                                    <strong>Progreso:</strong>
                                                    <div class="progress mt-2" style="height: 10px;">
                                                        <div class="progress-bar bg-info" role="progressbar" style="width: 60%;" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                                <p><strong>Promedio del curso:</strong> 7.9/10</p>
                                            </div>
                                            <div class="card-footer">
                                                <div class="btn-group" role="group">
                                                    <a href="#" class="btn btn-outline-primary btn-sm">Ver estudiantes</a>
                                                    <a href="#" class="btn btn-outline-primary btn-sm">Ver actividades</a>
                                                    <a href="#" class="btn btn-outline-primary btn-sm">Calificaciones</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Modal para crear nueva actividad -->
                                <div class="modal fade" id="nuevaActividadModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Nueva Actividad</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form>
                                                    <div class="mb-3">
                                                        <label for="cursoSelect" class="form-label">Curso</label>
                                                        <select class="form-select" id="cursoSelect">
                                                            <option selected>Seleccionar curso</option>
                                                            <option value="mat101">Matemáticas Avanzadas</option>
                                                            <option value="mat202">Álgebra Lineal</option>
                                                            <option value="mat303">Cálculo Diferencial</option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="tituloActividad" class="form-label">Título</label>
                                                        <input type="text" class="form-control" id="tituloActividad">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="descripcionActividad" class="form-label">Descripción</label>
                                                        <textarea class="form-control" id="descripcionActividad" rows="3"></textarea>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="fechaEntrega" class="form-label">Fecha de entrega</label>
                                                        <input type="date" class="form-control" id="fechaEntrega">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="puntaje" class="form-label">Puntaje máximo</label>
                                                        <input type="number" class="form-control" id="puntaje" min="0" max="10" step="0.1" value="10">
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                <button type="button" class="btn btn-primary">Guardar actividad</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${includePage == '/profesor/tareas.jsp'}">
                                <!-- Contenido de tareas de profesor -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Gestión de Tareas</h2>
                                    <div>
                                        <select class="form-select form-select-sm me-2" style="display:inline-block; width:auto;">
                                            <option value="all">Todos los cursos</option>
                                            <option value="mat101">Matemáticas Avanzadas</option>
                                            <option value="mat202">Álgebra Lineal</option>
                                            <option value="mat303">Cálculo Diferencial</option>
                                        </select>
                                        <select class="form-select form-select-sm" style="display:inline-block; width:auto;">
                                            <option value="all">Todos los estados</option>
                                            <option value="active">Activas</option>
                                            <option value="pending">Pendientes por calificar</option>
                                            <option value="graded">Calificadas</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="card">
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>Título</th>
                                                        <th>Curso</th>
                                                        <th>Fecha entrega</th>
                                                        <th>Entregas</th>
                                                        <th>Estado</th>
                                                        <th>Acciones</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>Ecuaciones Diferenciales</td>
                                                        <td>Matemáticas Avanzadas</td>
                                                        <td>25/04/2025</td>
                                                        <td>8/15</td>
                                                        <td><span class="badge bg-info">Activa</span></td>
                                                        <td>
                                                            <div class="btn-group btn-group-sm">
                                                                <button class="btn btn-outline-primary">Ver entregas</button>
                                                                <button class="btn btn-outline-warning">Editar</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Matrices y Determinantes</td>
                                                        <td>Álgebra Lineal</td>
                                                        <td>15/04/2025</td>
                                                        <td>10/12</td>
                                                        <td><span class="badge bg-warning">Por calificar</span></td>
                                                        <td>
                                                            <div class="btn-group btn-group-sm">
                                                                <button class="btn btn-primary">Calificar</button>
                                                                <button class="btn btn-outline-warning">Editar</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Examen parcial</td>
                                                        <td>Cálculo Diferencial</td>
                                                        <td>10/04/2025</td>
                                                        <td>18/18</td>
                                                        <td><span class="badge bg-success">Calificada</span></td>
                                                        <td>
                                                            <div class="btn-group btn-group-sm">
                                                                <button class="btn btn-outline-primary">Ver calificaciones</button>
                                                                <button class="btn btn-outline-info">Estadísticas</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Límites y continuidad</td>
                                                        <td>Cálculo Diferencial</td>
                                                        <td>01/04/2025</td>
                                                        <td>15/18</td>
                                                        <td><span class="badge bg-success">Calificada</span></td>
                                                        <td>
                                                            <div class="btn-group btn-group-sm">
                                                                <button class="btn btn-outline-primary">Ver calificaciones</button>
                                                                <button class="btn btn-outline-info">Estadísticas</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${includePage == '/profesor/notas.jsp'}">
                                <!-- Contenido de notas de profesor -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Gestión de Calificaciones</h2>
                                    <div>
                                        <select class="form-select form-select-sm" id="cursoSelect" style="width:auto;">
                                            <option selected>Seleccionar curso</option>
                                            <option value="mat101">Matemáticas Avanzadas</option>
                                            <option value="mat202">Álgebra Lineal</option>
                                            <option value="mat303">Cálculo Diferencial</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="card mb-4">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0">Matemáticas Avanzadas - Calificaciones</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-bordered">
                                                <thead>
                                                    <tr>
                                                        <th rowspan="2" class="align-middle">Estudiante</th>
                                                        <th colspan="3" class="text-center">Actividades</th>
                                                        <th rowspan="2" class="align-middle">Promedio</th>
                                                    </tr>
                                                    <tr>
                                                        <th>Matrices y determinantes</th>
                                                        <th>Ecuaciones diferenciales</th>
                                                        <th>Examen parcial</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>Ana Martínez</td>
                                                        <td>8.5</td>
                                                        <td>9.0</td>
                                                        <td>9.5</td>
                                                        <td>9.0</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Carlos Sánchez</td>
                                                        <td>7.5</td>
                                                        <td>8.0</td>
                                                        <td>7.0</td>
                                                        <td>7.5</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Laura Gómez</td>
                                                        <td>9.0</td>
                                                        <td>8.5</td>
                                                        <td>8.0</td>
                                                        <td>8.5</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Roberto Fernández</td>
                                                        <td>6.5</td>
                                                        <td>7.0</td>
                                                        <td>7.5</td>
                                                        <td>7.0</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Elena Pérez</td>
                                                        <td>8.0</td>
                                                        <td>8.5</td>
                                                        <td>9.0</td>
                                                        <td>8.5</td>
                                                    </tr>
                                                </tbody>
                                                <tfoot class="table-secondary">
                                                    <tr>
                                                        <th>Promedio actividad</th>
                                                        <th>7.9</th>
                                                        <th>8.2</th>
                                                        <th>8.2</th>
                                                        <th>8.1</th>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="card-footer">
                                        <button class="btn btn-outline-primary btn-sm">Exportar a Excel</button>
                                        <button class="btn btn-outline-info btn-sm">Ver estadísticas</button>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="card">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">Estadísticas del curso</h5>
                                            </div>
                                            <div class="card-body">
                                                <ul class="list-group list-group-flush">
                                                    <li class="list-group-item d-flex justify-content-between">
                                                        <span>Promedio general:</span>
                                                        <strong>8.1 / 10</strong>
                                                    </li>
                                                    <li class="list-group-item d-flex justify-content-between">
                                                        <span>Calificación más alta:</span>
                                                        <strong>9.5 / 10</strong>
                                                    </li>
                                                    <li class="list-group-item d-flex justify-content-between">
                                                        <span>Calificación más baja:</span>
                                                        <strong>6.5 / 10</strong>
                                                    </li>
                                                    <li class="list-group-item d-flex justify-content-between">
                                                        <span>Estudiantes aprobados:</span>
                                                        <strong>15 / 15 (100%)</strong>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="card">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">Distribución de calificaciones</h5>
                                            </div>
                                            <div class="card-body">
                                                <!-- Aquí iría un gráfico de distribución de calificaciones -->
                                                <div class="text-center my-3">
                                                    <em class="text-muted">Gráfico de distribución de calificaciones</em>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <label class="form-label">9-10</label>
                                                    <div class="progress mb-2" style="height: 20px;">
                                                        <div class="progress-bar bg-success" role="progressbar" style="width: 30%;" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100">30%</div>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">8-9</label>
                                                    <div class="progress mb-2" style="height: 20px;">
                                                        <div class="progress-bar bg-primary" role="progressbar" style="width: 40%;" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100">40%</div>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">7-8</label>
                                                    <div class="progress mb-2" style="height: 20px;">
                                                        <div class="progress-bar bg-info" role="progressbar" style="width: 20%;" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">20%</div>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">6-7</label>
                                                    <div class="progress mb-2" style="height: 20px;">
                                                        <div class="progress-bar bg-warning" role="progressbar" style="width: 10%;" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100">10%</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                        </c:when>
                        <c:otherwise>
                            <div class="welcome-container">
                                <h1 class="welcome-title">Bienvenido al Sistema Académico</h1>
                                <p class="welcome-subtitle">Selecciona una opción del menú para comenzar</p>
                                <div class="mt-4">
                                    <i class="bi bi-arrow-left-circle fs-1 text-primary"></i>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle con Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    
    <!-- Scripts específicos según la página -->
    <c:if test="${includePage == '/admin/profesores.jsp'}">
        <script>
            $(document).ready(function() {
                // Inicializar DataTable para profesores
                $('#profesoresTable').DataTable({
                    ajax: {
                        url: '${pageContext.request.contextPath}/ProfesoresController',
                        dataSrc: ''
                    },
                    columns: [
                        { data: 'id_profesor' },
                        { data: 'nombre' },
                        { data: 'correo' },
                        { data: 'especializacion' },
                        { data: 'estado' },
                        {
                            data: null,
                            render: function(data, type, row) {
                                return `
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-info" onclick="editarProfesor(${row.id_profesor})" title="Editar profesor">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="eliminarProfesor(${row.id_profesor})" title="Eliminar profesor">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>`;
                            }
                        }
                    ],
                    language: {
                        url: 'https://cdn.datatables.net/plug-ins/1.11.5/i18n/es-ES.json'
                    }
                });
            });
            
            function guardarProfesor() {
                console.log("Guardando profesor...");
                // Implementar la lógica para guardar profesor
            }
            
            function editarProfesor(id) {
                console.log("Editando profesor: " + id);
                // Implementar la lógica para editar profesor
            }
            
            function eliminarProfesor(id) {
                console.log("Eliminando profesor: " + id);
                // Implementar la lógica para eliminar profesor
            }
        </script>
    </c:if>
    
    <c:if test="${includePage == '/admin/estudiantes.jsp'}">
        <script>
            $(document).ready(function() {
                // Inicializar DataTable para estudiantes
                $('#estudiantesTable').DataTable({
                    ajax: {
                        url: '${pageContext.request.contextPath}/EstudiantesController',
                        dataSrc: ''
                    },
                    columns: [
                        { data: 'id_estudiante' },
                        { data: 'nombre' },
                        { data: 'correo' },
                        { data: 'numero_identificacion' },
                        { data: 'estado' },
                        {
                            data: null,
                            render: function(data, type, row) {
                                return `
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-info" onclick="editarEstudiante(${row.id_estudiante})" title="Editar estudiante">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="eliminarEstudiante(${row.id_estudiante})" title="Eliminar estudiante">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>`;
                            }
                        }
                    ],
                    language: {
                        url: 'https://cdn.datatables.net/plug-ins/1.11.5/i18n/es-ES.json'
                    }
                });
            });
        </script>
    </c:if>
    
    <c:if test="${includePage == '/admin/cursos.jsp'}">
        <script>
            $(document).ready(function() {
                // Inicializar DataTable para cursos
                $('#cursosTable').DataTable({
                    ajax: {
                        url: '${pageContext.request.contextPath}/CursosController',
                        dataSrc: ''
                    },
                    columns: [
                        { data: 'id_curso' },
                        { data: 'codigo' },
                        { data: 'nombre' },
                        { data: 'nombreProfesor' },
                        { data: 'cantidadEstudiantes' },
                        {
                            data: null,
                            render: function(data, type, row) {
                                return `
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-info" onclick="editarCurso(${row.id_curso})" title="Editar curso">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="eliminarCurso(${row.id_curso})" title="Eliminar curso">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>`;
                            }
                        }
                    ],
                    language: {
                        url: 'https://cdn.datatables.net/plug-ins/1.11.5/i18n/es-ES.json'
                    }
                });
            });
        </script>
    </c:if>
    
    <c:if test="${includePage == '/admin/actividades.jsp'}">
        <script>
            $(document).ready(function() {
                // Inicializar DataTable para actividades
                $('#actividadesTable').DataTable({
                    ajax: {
                        url: '${pageContext.request.contextPath}/ActividadesController',
                        dataSrc: ''
                    },
                    columns: [
                        { data: 'id_actividad' },
                        { data: 'titulo' },
                        { data: 'nombreCurso' },
                        { data: 'fecha_creacion' },
                        { data: 'fecha_entrega' },
                        { data: 'estado' },
                        {
                            data: null,
                            render: function(data, type, row) {
                                return `
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-info" onclick="editarActividad(${row.id_actividad})" title="Editar actividad">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="eliminarActividad(${row.id_actividad})" title="Eliminar actividad">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>`;
                            }
                        }
                    ],
                    language: {
                        url: 'https://cdn.datatables.net/plug-ins/1.11.5/i18n/es-ES.json'
                    }
                });
            });
        </script>
    </c:if>
</body>
</html>