<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Cursos - Profesor</title>
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet">
    <style>
        .action-buttons .btn {
            margin: 0 2px;
        }
        .select2-container {
            width: 100% !important;
        }
        .course-card {
            transition: transform 0.2s;
        }
        .course-card:hover {
            transform: translateY(-5px);
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

        <!-- Modal para Gestionar Estudiantes -->
        <div class="modal fade" id="estudiantesModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Gestionar Estudiantes</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="estudiantesForm">
                            <input type="hidden" id="cursoId">
                            <div class="mb-3">
                                <label class="form-label">Agregar Estudiantes</label>
                                <select class="form-select" id="estudiantes" multiple>
                                    <!-- Las opciones se cargarán dinámicamente -->
                                </select>
                            </div>
                            <div class="mt-4">
                                <h6>Estudiantes Actuales</h6>
                                <div class="table-responsive">
                                    <table class="table table-hover" id="estudiantesActualesTable">
                                        <thead>
                                            <tr>
                                                <th>Nombre</th>
                                                <th>Identificación</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Los estudiantes actuales se cargarán aquí -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <button type="button" class="btn btn-primary" onclick="guardarEstudiantes()">Guardar Cambios</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal para Gestionar Tareas -->
        <div class="modal fade" id="tareasModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Gestionar Tareas</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="d-flex justify-content-between mb-3">
                            <h6>Tareas del Curso</h6>
                            <button class="btn btn-primary btn-sm" onclick="mostrarFormularioTarea()">
                                <i class="fas fa-plus"></i> Nueva Tarea
                            </button>
                        </div>
                        <div id="formTarea" style="display: none;" class="mb-4">
                            <form id="tareaForm">
                                <input type="hidden" id="tareaId">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Título</label>
                                        <input type="text" class="form-control" id="tituloTarea" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Fecha de Entrega</label>
                                        <input type="date" class="form-control" id="fechaEntrega" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Descripción</label>
                                    <textarea class="form-control" id="descripcionTarea" rows="3" required></textarea>
                                </div>
                                <div class="text-end">
                                    <button type="button" class="btn btn-secondary" onclick="cancelarTarea()">Cancelar</button>
                                    <button type="button" class="btn btn-primary" onclick="guardarTarea()">Guardar Tarea</button>
                                </div>
                            </form>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover" id="tareasTable">
                                <thead>
                                    <tr>
                                        <th>Título</th>
                                        <th>Fecha Asignación</th>
                                        <th>Fecha Entrega</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Las tareas se cargarán aquí -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    <!-- Select2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <script>
        $(document).ready(function() {
            cargarCursos();
            inicializarSelect2();
        });

        function inicializarSelect2() {
            $('#estudiantes').select2({
                theme: 'bootstrap-5',
                placeholder: 'Seleccione estudiantes',
                multiple: true,
                ajax: {
                    url: '${pageContext.request.contextPath}/EstudiantesController',
                    dataType: 'json',
                    processResults: function(data) {
                        return {
                            results: data.map(estudiante => ({
                                id: estudiante.id_estudiante,
                                text: estudiante.nombre
                            }))
                        };
                    }
                }
            });
        }

        function cargarCursos() {
            $.get('${pageContext.request.contextPath}/CursosController/profesor/${sessionScope.userId}', function(cursos) {
                const container = $('#cursosContainer');
                container.empty();

                cursos.forEach(curso => {
                    container.append(`
                        <div class="col-md-4 mb-4">
                            <div class="card course-card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">${curso.nombre}</h5>
                                    <h6 class="card-subtitle mb-2 text-muted">${curso.codigo}</h6>
                                    <p class="card-text">${curso.descripcion || 'Sin descripción'}</p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="badge bg-info">${curso.estudiantes ? curso.estudiantes.length : 0} estudiantes</span>
                                        <div class="btn-group">
                                            <button class="btn btn-outline-primary btn-sm" onclick="gestionarEstudiantes(${curso.id_curso})">
                                                <i class="fas fa-users"></i> Estudiantes
                                            </button>
                                            <button class="btn btn-outline-success btn-sm" onclick="gestionarTareas(${curso.id_curso})">
                                                <i class="fas fa-tasks"></i> Tareas
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `);
                });
            });
        }

        function gestionarEstudiantes(cursoId) {
            $('#cursoId').val(cursoId);
            cargarEstudiantesActuales(cursoId);
            $('#estudiantesModal').modal('show');
        }

        function cargarEstudiantesActuales(cursoId) {
            $.get(`${pageContext.request.contextPath}/CursosController/estudiantes/${cursoId}`, function(estudiantes) {
                const tbody = $('#estudiantesActualesTable tbody');
                tbody.empty();

                estudiantes.forEach(est => {
                    tbody.append(`
                        <tr>
                            <td>${est.nombre}</td>
                            <td>${est.numero_identificacion}</td>
                            <td><span class="badge bg-${est.estado === 'Activo' ? 'success' : 'warning'}">${est.estado}</span></td>
                            <td>
                                <button class="btn btn-danger btn-sm" onclick="eliminarEstudiante(${est.id_estudiante})">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
            });
        }

        function guardarEstudiantes() {
            const cursoId = $('#cursoId').val();
            const estudiantesIds = $('#estudiantes').val();

            $.ajax({
                url: '${pageContext.request.contextPath}/CursosController/estudiantes',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    cursoId: cursoId,
                    estudiantesIds: estudiantesIds
                }),
                success: function() {
                    $('#estudiantesModal').modal('hide');
                    cargarCursos();
                    mostrarMensaje('Estudiantes actualizados exitosamente', 'success');
                },
                error: function(xhr, status, error) {
                    mostrarMensaje('Error al actualizar estudiantes: ' + error, 'danger');
                }
            });
        }

        function gestionarTareas(cursoId) {
            $('#cursoId').val(cursoId);
            cargarTareas(cursoId);
            $('#tareasModal').modal('show');
        }

        function cargarTareas(cursoId) {
            $.get(`${pageContext.request.contextPath}/TareasController/curso/${cursoId}`, function(tareas) {
                const tbody = $('#tareasTable tbody');
                tbody.empty();

                tareas.forEach(tarea => {
                    tbody.append(`
                        <tr>
                            <td>${tarea.titulo}</td>
                            <td>${formatearFecha(tarea.fecha_asignacion)}</td>
                            <td>${formatearFecha(tarea.fecha_entrega)}</td>
                            <td>
                                <div class="btn-group">
                                    <button class="btn btn-info btn-sm" onclick="editarTarea(${tarea.id_tarea})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-danger btn-sm" onclick="eliminarTarea(${tarea.id_tarea})">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                    <button class="btn btn-success btn-sm" onclick="gestionarNotas(${tarea.id_tarea})">
                                        <i class="fas fa-star"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    `);
                });
            });
        }

        function mostrarFormularioTarea() {
            $('#formTarea').show();
            $('#tareaId').val('');
            $('#tareaForm')[0].reset();
        }

        function cancelarTarea() {
            $('#formTarea').hide();
            $('#tareaForm')[0].reset();
        }

        function guardarTarea() {
            const tarea = {
                id_tarea: $('#tareaId').val(),
                titulo: $('#tituloTarea').val(),
                descripcion: $('#descripcionTarea').val(),
                fecha_entrega: $('#fechaEntrega').val(),
                id_curso: $('#cursoId').val()
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/TareasController',
                type: tarea.id_tarea ? 'PUT' : 'POST',
                contentType: 'application/json',
                data: JSON.stringify(tarea),
                success: function() {
                    cancelarTarea();
                    cargarTareas($('#cursoId').val());
                    mostrarMensaje('Tarea guardada exitosamente', 'success');
                },
                error: function(xhr, status, error) {
                    mostrarMensaje('Error al guardar la tarea: ' + error, 'danger');
                }
            });
        }

        function editarTarea(tareaId) {
            $.get(`${pageContext.request.contextPath}/TareasController/${tareaId}`, function(tarea) {
                $('#tareaId').val(tarea.id_tarea);
                $('#tituloTarea').val(tarea.titulo);
                $('#descripcionTarea').val(tarea.descripcion);
                $('#fechaEntrega').val(tarea.fecha_entrega);
                $('#formTarea').show();
            });
        }

        function eliminarTarea(tareaId) {
            if (confirm('¿Está seguro de que desea eliminar esta tarea?')) {
                $.ajax({
                    url: `${pageContext.request.contextPath}/TareasController/${tareaId}`,
                    type: 'DELETE',
                    success: function() {
                        cargarTareas($('#cursoId').val());
                        mostrarMensaje('Tarea eliminada exitosamente', 'success');
                    },
                    error: function(xhr, status, error) {
                        mostrarMensaje('Error al eliminar la tarea: ' + error, 'danger');
                    }
                });
            }
        }

        function formatearFecha(fecha) {
            return new Date(fecha).toLocaleDateString('es-ES');
        }

        function mostrarMensaje(mensaje, tipo) {
            const alertDiv = $(`<div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
                ${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>`);
            
            $('.container-fluid').prepend(alertDiv);
            setTimeout(() => alertDiv.alert('close'), 5000);
        }
    </script>
</body>
</html>