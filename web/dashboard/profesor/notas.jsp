<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Notas</title>
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        .action-buttons .btn {
            margin: 0 2px;
        }
        .course-select {
            max-width: 300px;
        }
        .grade-input {
            width: 80px;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid py-4">
        <h2 class="mb-4">Gestión de Notas</h2>

        <!-- Selector de Curso -->
        <div class="mb-4">
            <label class="form-label">Seleccionar Curso</label>
            <select class="form-select course-select" id="cursoSelect" onchange="cargarTareas()">
                <option value="">Seleccione un curso...</option>
                <!-- Los cursos se cargarán dinámicamente -->
            </select>
        </div>

        <!-- Tabla de Tareas y Notas -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table id="notasTable" class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Estudiante</th>
                                <th>Identificación</th>
                                <!-- Las columnas de tareas se agregarán dinámicamente -->
                                <th>Promedio</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Los datos se cargarán dinámicamente -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Modal para Calificar Tarea -->
        <div class="modal fade" id="calificarModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Calificar Tarea</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="calificacionForm">
                            <input type="hidden" id="tareaId">
                            <input type="hidden" id="estudianteId">
                            <div class="mb-3">
                                <label class="form-label">Estudiante</label>
                                <input type="text" class="form-control" id="nombreEstudiante" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Tarea</label>
                                <input type="text" class="form-control" id="nombreTarea" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Nota (0-100)</label>
                                <input type="number" class="form-control" id="nota" min="0" max="100" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Comentario</label>
                                <textarea class="form-control" id="comentario" rows="3"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary" onclick="guardarCalificacion()">Guardar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>

    <script>
        let table;
        let tareas = [];

        $(document).ready(function() {
            cargarCursos();
            inicializarTabla();
        });

        function inicializarTabla() {
            table = $('#notasTable').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.11.5/i18n/es-ES.json'
                },
                ordering: false
            });
        }

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
            if (!cursoId) return;

            $.get(`${pageContext.request.contextPath}/TareasController/curso/${cursoId}`, function(tareasData) {
                tareas = tareasData;
                actualizarTabla();
            });
        }

        function actualizarTabla() {
            const cursoId = $('#cursoSelect').val();
            
            // Actualizar encabezados de la tabla
            const headerRow = $('#notasTable thead tr');
            headerRow.find('th:not(:first-child):not(:last-child)').remove();
            
            tareas.forEach(tarea => {
                $('<th>').text(tarea.titulo).insertBefore(headerRow.find('th:last'));
            });

            // Cargar datos de estudiantes y notas
            $.get(`${pageContext.request.contextPath}/CursosController/estudiantes/${cursoId}`, function(estudiantes) {
                table.clear();

                estudiantes.forEach(estudiante => {
                    const row = [estudiante.nombre, estudiante.numero_identificacion];
                    
                    // Agregar celdas para cada tarea
                    tareas.forEach(tarea => {
                        row.push(crearCeldaNota(tarea, estudiante));
                    });

                    // Agregar promedio
                    row.push(calcularPromedio(estudiante.id_estudiante));
                    
                    table.row.add(row);
                });

                table.draw();
            });
        }

        function crearCeldaNota(tarea, estudiante) {
            return `
                <div class="d-flex align-items-center justify-content-between">
                    <span class="nota-valor" id="nota-${tarea.id_tarea}-${estudiante.id_estudiante}">-</span>
                    <button class="btn btn-sm btn-primary" onclick="mostrarModalCalificacion(${tarea.id_tarea}, ${estudiante.id_estudiante}, '${estudiante.nombre}', '${tarea.titulo}')">
                        <i class="fas fa-edit"></i>
                    </button>
                </div>
            `;
        }

        function mostrarModalCalificacion(tareaId, estudianteId, nombreEstudiante, nombreTarea) {
            $('#tareaId').val(tareaId);
            $('#estudianteId').val(estudianteId);
            $('#nombreEstudiante').val(nombreEstudiante);
            $('#nombreTarea').val(nombreTarea);

            // Cargar nota existente si hay
            $.get(`${pageContext.request.contextPath}/NotasController/${tareaId}/${estudianteId}`, function(nota) {
                if (nota) {
                    $('#nota').val(nota.nota);
                    $('#comentario').val(nota.comentario);
                } else {
                    $('#calificacionForm')[0].reset();
                }
                $('#calificarModal').modal('show');
            });
        }

        function guardarCalificacion() {
            const calificacion = {
                id_tarea: $('#tareaId').val(),
                id_estudiante: $('#estudianteId').val(),
                nota: $('#nota').val(),
                comentario: $('#comentario').val(),
                fecha_evaluacion: new Date().toISOString().split('T')[0]
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/NotasController',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(calificacion),
                success: function(response) {
                    $('#calificarModal').modal('hide');
                    actualizarNota(calificacion);
                    mostrarMensaje('Calificación guardada exitosamente', 'success');
                },
                error: function(xhr, status, error) {
                    mostrarMensaje('Error al guardar la calificación: ' + error, 'danger');
                }
            });
        }

        function actualizarNota(calificacion) {
            $(`#nota-${calificacion.id_tarea}-${calificacion.id_estudiante}`).text(calificacion.nota);
            actualizarPromedio(calificacion.id_estudiante);
        }

        function calcularPromedio(estudianteId) {
            return `<span id="promedio-${estudianteId}">-</span>`;
        }

        function actualizarPromedio(estudianteId) {
            $.get(`${pageContext.request.contextPath}/NotasController/promedio/${estudianteId}`, function(promedio) {
                $(`#promedio-${estudianteId}`).text(promedio.toFixed(2));
            });
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