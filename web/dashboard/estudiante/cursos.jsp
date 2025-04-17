<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Cursos - Estudiante</title>
    <style>
        .course-card {
            transition: transform 0.2s;
        }
        .course-card:hover {
            transform: translateY(-5px);
        }
        .task-list {
            max-height: 200px;
            overflow-y: auto;
        }
        .grade-badge {
            font-size: 1.2rem;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid py-4">
        <h2 class="mb-4">Mis Cursos</h2>

        <!-- Vista de Cursos en Cards -->
        <div class="row" id="cursosContainer">
            <!-- Los cursos se cargarán dinámicamente aquí -->
        </div>

        <!-- Modal para Ver Detalles del Curso -->
        <div class="modal fade" id="cursoDetalleModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="cursoNombre"></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Información del Curso</h6>
                                <p><strong>Código:</strong> <span id="cursoCodigo"></span></p>
                                <p><strong>Profesor:</strong> <span id="cursoProfesor"></span></p>
                                <p><strong>Descripción:</strong></p>
                                <p id="cursoDescripcion"></p>
                            </div>
                            <div class="col-md-6">
                                <h6>Mi Progreso</h6>
                                <div class="text-center mb-3">
                                    <span class="badge bg-primary grade-badge" id="cursoPromedio">-</span>
                                    <p class="text-muted">Promedio Actual</p>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <h6>Tareas Pendientes</h6>
                        <div class="list-group task-list" id="tareasPendientes">
                            <!-- Las tareas se cargarán dinámicamente -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal para Ver Tarea -->
        <div class="modal fade" id="tareaModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="tareaTitulo"></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Descripción</label>
                            <p id="tareaDescripcion"></p>
                        </div>
                        <div class="row mb-3">
                            <div class="col-6">
                                <label class="form-label">Fecha de Asignación</label>
                                <p id="tareaFechaAsignacion"></p>
                            </div>
                            <div class="col-6">
                                <label class="form-label">Fecha de Entrega</label>
                                <p id="tareaFechaEntrega"></p>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Estado</label>
                            <p id="tareaEstado"></p>
                        </div>
                        <div class="mb-3" id="notaContainer" style="display: none;">
                            <label class="form-label">Calificación</label>
                            <div class="d-flex align-items-center">
                                <h3 class="mb-0 me-2" id="tareaNota"></h3>
                                <small class="text-muted" id="tareaComentario"></small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            cargarCursos();
        });

        function cargarCursos() {
            $.get('${pageContext.request.contextPath}/CursosController/estudiante/${sessionScope.userId}', function(cursos) {
                const container = $('#cursosContainer');
                container.empty();

                cursos.forEach(curso => {
                    container.append(crearTarjetaCurso(curso));
                });
            });
        }

        function crearTarjetaCurso(curso) {
            return `
                <div class="col-md-4 mb-4">
                    <div class="card course-card h-100">
                        <div class="card-body">
                            <h5 class="card-title">${curso.nombre}</h5>
                            <h6 class="card-subtitle mb-2 text-muted">${curso.codigo}</h6>
                            <p class="card-text">${curso.descripcion || 'Sin descripción'}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted">Profesor: ${curso.profesor_nombre}</small>
                                <button class="btn btn-primary btn-sm" onclick="verDetalleCurso(${curso.id_curso})">
                                    <i class="fas fa-info-circle"></i> Ver Detalles
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        }

        function verDetalleCurso(cursoId) {
            $.get(`${pageContext.request.contextPath}/CursosController/${cursoId}`, function(curso) {
                $('#cursoNombre').text(curso.nombre);
                $('#cursoCodigo').text(curso.codigo);
                $('#cursoProfesor').text(curso.profesor_nombre);
                $('#cursoDescripcion').text(curso.descripcion);

                // Cargar promedio
                $.get(`${pageContext.request.contextPath}/NotasController/promedio/estudiante/${sessionScope.userId}/curso/${cursoId}`, function(promedio) {
                    $('#cursoPromedio').text(promedio.toFixed(2));
                });

                // Cargar tareas pendientes
                $.get(`${pageContext.request.contextPath}/TareasController/pendientes/estudiante/${sessionScope.userId}/curso/${cursoId}`, function(tareas) {
                    const tareasList = $('#tareasPendientes');
                    tareasList.empty();

                    if (tareas.length === 0) {
                        tareasList.append('<p class="text-muted text-center">No hay tareas pendientes</p>');
                    } else {
                        tareas.forEach(tarea => {
                            const fechaEntrega = new Date(tarea.fecha_entrega).toLocaleDateString('es-ES');
                            tareasList.append(`
                                <a href="#" class="list-group-item list-group-item-action" onclick="verTarea(${tarea.id_tarea})">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-1">${tarea.titulo}</h6>
                                        <small class="text-danger">Entrega: ${fechaEntrega}</small>
                                    </div>
                                    <small class="text-muted">${tarea.descripcion.substring(0, 100)}...</small>
                                </a>
                            `);
                        });
                    }
                });

                $('#cursoDetalleModal').modal('show');
            });
        }

        function verTarea(tareaId) {
            $.get(`${pageContext.request.contextPath}/TareasController/${tareaId}`, function(tarea) {
                $('#tareaTitulo').text(tarea.titulo);
                $('#tareaDescripcion').text(tarea.descripcion);
                $('#tareaFechaAsignacion').text(new Date(tarea.fecha_asignacion).toLocaleDateString('es-ES'));
                $('#tareaFechaEntrega').text(new Date(tarea.fecha_entrega).toLocaleDateString('es-ES'));

                // Verificar si hay nota
                $.get(`${pageContext.request.contextPath}/NotasController/tarea/${tareaId}/estudiante/${sessionScope.userId}`, function(nota) {
                    if (nota) {
                        $('#tareaEstado').html('<span class="badge bg-success">Calificado</span>');
                        $('#tareaNota').text(nota.nota);
                        $('#tareaComentario').text(nota.comentario);
                        $('#notaContainer').show();
                    } else {
                        $('#tareaEstado').html('<span class="badge bg-warning">Pendiente</span>');
                        $('#notaContainer').hide();
                    }
                });

                $('#cursoDetalleModal').modal('hide');
                $('#tareaModal').modal('show');
            });
        }

        $('#tareaModal').on('hidden.bs.modal', function() {
            $('#cursoDetalleModal').modal('show');
        });
    </script>
</body>
</html>