<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Tareas</title>
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        .action-buttons .btn {
            margin: 0 2px;
        }
        .course-select {
            max-width: 300px;
        }
        .task-card {
            transition: transform 0.2s;
        }
        .task-card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Gestión de Tareas</h2>
            <div>
                <select class="form-select course-select" id="cursoSelect" onchange="cargarTareas()">
                    <option value="">Seleccione un curso...</option>
                    <!-- Los cursos se cargarán dinámicamente -->
                </select>
            </div>
        </div>

        <!-- Botón para agregar nueva tarea -->
        <div class="mb-4" id="nuevaTareaContainer" style="display: none;">
            <button class="btn btn-primary" onclick="mostrarFormularioTarea()">
                <i class="fas fa-plus"></i> Nueva Tarea
            </button>
        </div>

        <!-- Formulario de Tarea -->
        <div class="card mb-4" id="formTarea" style="display: none;">
            <div class="card-body">
                <h5 class="card-title mb-4" id="formTareaTitle">Nueva Tarea</h5>
                <form id="tareaForm">
                    <input type="hidden" id="tareaId">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Título</label>
                            <input type="text" class="form-control" id="titulo" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha de Entrega</label>
                            <input type="date" class="form-control" id="fechaEntrega" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Descripción</label>
                        <textarea class="form-control" id="descripcion" rows="3" required></textarea>
                    </div>
                    <div class="text-end">
                        <button type="button" class="btn btn-secondary" onclick="cancelarTarea()">Cancelar</button>
                        <button type="button" class="btn btn-primary" onclick="guardarTarea()">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Lista de Tareas -->
        <div class="row" id="tareasContainer">
            <!-- Las tareas se cargarán dinámicamente aquí -->
        </div>

        <!-- Modal para ver Entregas -->
        <div class="modal fade" id="entregasModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Entregas de la Tarea</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="table-responsive">
                            <table class="table table-hover" id="entregasTable">
                                <thead>
                                    <tr>
                                        <th>Estudiante</th>
                                        <th>Estado</th>
                                        <th>Fecha Entrega</th>
                                        <th>Nota</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Las entregas se cargarán dinámicamente -->
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

    <script>
        $(document).ready(function() {
            cargarCursos();
        });

        function cargarCursos() {
            $.get('${pageContext.request.contextPath}/CursosController/profesor/${sessionScope.userId}', function(cursos) {
                const select = $('#cursoSelect');
                select.find('option:not(:first)').remove();

                cursos.forEach(curso => {
                    select.append(`<option value="${curso.id_curso}">${curso.nombre} - ${curso.codigo}</option>`);
                });
            });
        }

        function cargarTareas() {
            const cursoId = $('#cursoSelect').val();
            if (!cursoId) {
                $('#nuevaTareaContainer').hide();
                $('#tareasContainer').empty();
                return;
            }

            $('#nuevaTareaContainer').show();
            
            $.get(`${pageContext.request.contextPath}/TareasController/curso/${cursoId}`, function(tareas) {
                const container = $('#tareasContainer');
                container.empty();

                tareas.forEach(tarea => {
                    container.append(crearTarjetaTarea(tarea));
                });
            });
        }

        function crearTarjetaTarea(tarea) {
            const fechaEntrega = new Date(tarea.fecha_entrega).toLocaleDateString('es-ES');
            const fechaAsignacion = new Date(tarea.fecha_asignacion).toLocaleDateString('es-ES');
            
            return `
                <div class="col-md-4 mb-4">
                    <div class="card task-card h-100">
                        <div class="card-body">
                            <h5 class="card-title">${tarea.titulo}</h5>
                            <h6 class="card-subtitle mb-2 text-muted">Entrega: ${fechaEntrega}</h6>
                            <p class="card-text">${tarea.descripcion}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted">Asignada: ${fechaAsignacion}</small>
                                <div class="btn-group">
                                    <button class="btn btn-outline-primary btn-sm" onclick="editarTarea(${tarea.id_tarea})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-outline-danger btn-sm" onclick="eliminarTarea(${tarea.id_tarea})">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                    <button class="btn btn-outline-success btn-sm" onclick="verEntregas(${tarea.id_tarea})">
                                        <i class="fas fa-list-check"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        }

        function mostrarFormularioTarea() {
            $('#formTarea').show();
            $('#tareaId').val('');
            $('#formTareaTitle').text('Nueva Tarea');
            $('#tareaForm')[0].reset();
        }

        function cancelarTarea() {
            $('#formTarea').hide();
            $('#tareaForm')[0].reset();
        }

        function guardarTarea() {
            const tarea = {
                id_tarea: $('#tareaId').val(),
                titulo: $('#titulo').val(),
                descripcion: $('#descripcion').val(),
                fecha_entrega: $('#fechaEntrega').val(),
                id_curso: $('#cursoSelect').val(),
                fecha_asignacion: new Date().toISOString().split('T')[0]
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/TareasController',
                type: tarea.id_tarea ? 'PUT' : 'POST',
                contentType: 'application/json',
                data: JSON.stringify(tarea),
                success: function() {
                    cancelarTarea();
                    cargarTareas();
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
                $('#titulo').val(tarea.titulo);
                $('#descripcion').val(tarea.descripcion);
                $('#fechaEntrega').val(tarea.fecha_entrega);
                $('#formTareaTitle').text('Editar Tarea');
                $('#formTarea').show();
            });
        }

        function eliminarTarea(tareaId) {
            if (confirm('¿Está seguro de que desea eliminar esta tarea?')) {
                $.ajax({
                    url: `${pageContext.request.contextPath}/TareasController/${tareaId}`,
                    type: 'DELETE',
                    success: function() {
                        cargarTareas();
                        mostrarMensaje('Tarea eliminada exitosamente', 'success');
                    },
                    error: function(xhr, status, error) {
                        mostrarMensaje('Error al eliminar la tarea: ' + error, 'danger');
                    }
                });
            }
        }

        function verEntregas(tareaId) {
            $.get(`${pageContext.request.contextPath}/NotasController/tarea/${tareaId}`, function(entregas) {
                const tbody = $('#entregasTable tbody');
                tbody.empty();

                entregas.forEach(entrega => {
                    tbody.append(`
                        <tr>
                            <td>${entrega.estudiante_nombre}</td>
                            <td>
                                <span class="badge bg-${entrega.nota ? 'success' : 'warning'}">
                                    ${entrega.nota ? 'Calificado' : 'Pendiente'}
                                </span>
                            </td>
                            <td>${entrega.fecha_entrega ? new Date(entrega.fecha_entrega).toLocaleDateString('es-ES') : '-'}</td>
                            <td>${entrega.nota || '-'}</td>
                            <td>
                                <button class="btn btn-primary btn-sm" onclick="calificarEntrega(${tareaId}, ${entrega.id_estudiante})">
                                    <i class="fas fa-star"></i> Calificar
                                </button>
                            </td>
                        </tr>
                    `);
                });

                $('#entregasModal').modal('show');
            });
        }

        function calificarEntrega(tareaId, estudianteId) {
            // Redirigir a la página de notas con los parámetros necesarios
            window.location.href = 'notas.jsp?tarea=' + tareaId + '&estudiante=' + estudianteId;
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