<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Administrador | Sistema Académico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .dashboard-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .card-icon {
            font-size: 2rem;
            color: #0d6efd;
        }
        .card-title {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        .card-value {
            font-size: 2rem;
            font-weight: bold;
            color: #1b4f72;
        }
        .nav-tabs .nav-link {
            color: #6c757d;
            border: none;
            padding: 1rem 1.5rem;
            font-weight: 500;
        }
        .nav-tabs .nav-link.active {
            color: #0d6efd;
            border-bottom: 2px solid #0d6efd;
            background: none;
        }
        .recent-activity {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-top: 2rem;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }
        .activity-item {
            padding: 1rem;
            border-bottom: 1px solid #e9ecef;
            transition: background-color 0.3s ease;
        }
        .activity-item:hover {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid py-4">
        <!-- Tarjetas de estadísticas -->
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

        <!-- Navegación por pestañas -->
        <ul class="nav nav-tabs mb-4">
            <li class="nav-item">
                <a class="nav-link active" href="#">Resumen</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="loadContent('cursos.jsp')">Cursos</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="loadContent('actividades.jsp')">Actividades</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="loadContent('profesores.jsp')">Profesores</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="loadContent('estudiantes.jsp')">Estudiantes</a>
            </li>
        </ul>

        <!-- Contenido principal -->
        <div class="row">
            <!-- Actividades Recientes -->
            <div class="col-lg-6">
                <div class="recent-activity">
                    <h5 class="mb-4">Actividades Recientes</h5>
                    <div class="activity-item">
                        <h6 class="mb-1">Actividad 1</h6>
                    </div>
                    <div class="activity-item">
                        <h6 class="mb-1">Actividad 2</h6>
                    </div>
                    <div class="activity-item">
                        <h6 class="mb-1">Actividad 3</h6>
                    </div>
                </div>
            </div>

            <!-- Cursos Recientes -->
            <div class="col-lg-6">
                <div class="recent-activity">
                    <h5 class="mb-4">Cursos Recientes</h5>
                    <div class="activity-item">
                        <h6 class="mb-1">Actividad 1</h6>
                    </div>
                    <div class="activity-item">
                        <h6 class="mb-1">Actividad 2</h6>
                    </div>
                    <div class="activity-item">
                        <h6 class="mb-1">Actividad 3</h6>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>