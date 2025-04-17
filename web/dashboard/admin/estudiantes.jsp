<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Estudiantes</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --accent-color: #4895ef;
            --success-color: #4cc9f0;
            --info-color: #4361ee;
            --warning-color: #f72585;
            --danger-color: #e63946;
            --light-color: #f8f9fa;
            --dark-color: #212529;
        }
        
        body {
            background-color: #f0f2f5;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }
        
        .container-fluid {
            padding-top: 2rem;
            padding-bottom: 2rem;
        }
        
        h2 {
            color: var(--dark-color);
            font-weight: 600;
            margin-bottom: 1.5rem;
            position: relative;
            padding-bottom: 0.5rem;
        }
        
        h2:after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            height: 3px;
            width: 60px;
            background: linear-gradient(to right, var(--primary-color), var(--accent-color));
        }
        
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            margin-bottom: 2rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        .table {
            border-radius: 8px;
            overflow: hidden;
        }
        
        .table thead th {
            background: linear-gradient(to right, var(--primary-color), var(--accent-color));
            color: white;
            border: none;
            padding: 15px 10px;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
        
        .table tbody tr {
            transition: all 0.2s ease;
        }
        
        .table tbody tr:hover {
            background-color: rgba(67, 97, 238, 0.05);
            transform: scale(1.01);
        }
        
        .action-buttons .btn {
            margin: 0 3px;
            padding: 0.4rem 0.75rem;
            border-radius: 50px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .action-buttons .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        .btn-info {
            background-color: var(--info-color);
            border-color: var(--info-color);
            color: white;
        }
        
        .btn-danger {
            background-color: var(--danger-color);
            border-color: var(--danger-color);
        }
        
        .btn-primary {
            background: linear-gradient(to right, var(--primary-color), var(--accent-color));
            border: none;
            box-shadow: 0 4px 15px rgba(67, 97, 238, 0.3);
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: linear-gradient(to right, var(--accent-color), var(--primary-color));
            box-shadow: 0 6px 20px rgba(67, 97, 238, 0.4);
            transform: translateY(-2px);
        }
        
        .modal-content {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .modal-header {
            background: linear-gradient(to right, var(--primary-color), var(--accent-color));
            color: white;
            border: none;
            padding: 1.5rem;
        }
        
        .modal-title {
            color: white;
            font-weight: 600;
        }
        
        .modal-header .btn-close {
            filter: invert(1) grayscale(100%) brightness(200%);
            opacity: 0.8;
            transition: opacity 0.3s ease;
        }
        
        .modal-header .btn-close:hover {
            opacity: 1;
        }
        
        .modal-body {
            padding: 1.5rem;
        }
        
        .modal-footer {
            border-top: 1px solid rgba(0, 0, 0, 0.05);
            padding: 1.25rem 1.5rem;
        }
        
        .modal-footer .btn {
            min-width: 120px;
            border-radius: 50px;
            font-weight: 500;
            padding: 0.6rem 1.5rem;
        }
        
        .form-control, .form-select {
            border-radius: 8px;
            padding: 0.6rem 1rem;
            border: 1px solid rgba(0, 0, 0, 0.1);
            background-color: #f8f9fa;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
            background-color: white;
        }
        
        .form-label {
            font-weight: 500;
            color: var(--dark-color);
            margin-bottom: 0.5rem;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            padding: 1rem 1.5rem;
            margin-top: 1.5rem;
            animation: slideDown 0.4s ease-out;
        }
        
        @keyframes slideDown {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .alert-success {
            background-color: rgba(76, 201, 240, 0.15);
            color: var(--success-color);
        }
        
        .alert-danger {
            background-color: rgba(230, 57, 70, 0.15);
            color: var(--danger-color);
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
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
                            <th>Número de Identificación</th>
                            <th>Estado</th>
                            <th>Promedio</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Los datos se cargarán dinámicamente -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal para Crear/Editar Estudiante -->
        <div class="modal fade" id="estudianteModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Nuevo Estudiante</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="estudianteForm">
                            <input type="hidden" id="estudianteId">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Nombre</label>
                                    <input type="text" class="form-control" id="nombre" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Correo</label>
                                    <input type="email" class="form-control" id="correo" required>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Fecha de Nacimiento</label>
                                    <input type="date" class="form-control" id="fechaNacimiento">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Teléfono</label>
                                    <input type="tel" class="form-control" id="telefono">
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Número de Identificación</label>
                                    <input type="text" class="form-control" id="numeroIdentificacion" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Estado</label>
                                    <select class="form-select" id="estado">
                                        <option value="Activo">Activo</option>
                                        <option value="Inactivo">Inactivo</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Dirección</label>
                                <textarea class="form-control" id="direccion" rows="2"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary" onclick="guardarEstudiante()">Guardar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>

    <script>
        let table;

        $(document).ready(function() {
            // Inicializar DataTable
            table = $('#estudiantesTable').DataTable({
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
                    { data: 'promedio_academico' },
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

        function guardarEstudiante() {
            const estudiante = {
                id_estudiante: $('#estudianteId').val(),
                nombre: $('#nombre').val(),
                correo: $('#correo').val(),
                fecha_nacimiento: $('#fechaNacimiento').val(),
                telefono: $('#telefono').val(),
                numero_identificacion: $('#numeroIdentificacion').val(),
                estado: $('#estado').val(),
                direccion: $('#direccion').val()
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/EstudiantesController',
                type: estudiante.id_estudiante ? 'PUT' : 'POST',
                contentType: 'application/json',
                data: JSON.stringify(estudiante),
                success: function(response) {
                    $('#estudianteModal').modal('hide');
                    table.ajax.reload();
                    mostrarMensaje('Estudiante guardado exitosamente', 'success');
                },
                error: function(xhr, status, error) {
                    mostrarMensaje('Error al guardar el estudiante: ' + error, 'danger');
                }
            });
        }

        function editarEstudiante(id) {
            $.get('${pageContext.request.contextPath}/EstudiantesController?id=' + id, function(estudiante) {
                $('#estudianteId').val(estudiante.id_estudiante);
                $('#nombre').val(estudiante.nombre);
                $('#correo').val(estudiante.correo);
                $('#fechaNacimiento').val(estudiante.fecha_nacimiento);
                $('#telefono').val(estudiante.telefono);
                $('#numeroIdentificacion').val(estudiante.numero_identificacion);
                $('#estado').val(estudiante.estado);
                $('#direccion').val(estudiante.direccion);
                
                $('#modalTitle').text('Editar Estudiante');
                $('#estudianteModal').modal('show');
            });
        }

        function eliminarEstudiante(id) {
            if (confirm('¿Está seguro de que desea eliminar este estudiante?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/EstudiantesController?id=' + id,
                    type: 'DELETE',
                    success: function(response) {
                        table.ajax.reload();
                        mostrarMensaje('Estudiante eliminado exitosamente', 'success');
                    },
                    error: function(xhr, status, error) {
                        mostrarMensaje('Error al eliminar el estudiante: ' + error, 'danger');
                    }
                });
            }
        }

        function mostrarMensaje(mensaje, tipo) {
            const icon = tipo === 'success' ? 'check-circle' : 'exclamation-circle';
            const alertDiv = $(`<div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
                <i class="fas fa-${icon} me-2"></i>${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>`);
            
            $('.container-fluid').prepend(alertDiv);
            setTimeout(() => alertDiv.alert('close'), 5000);
        }

        $('#estudianteModal').on('hidden.bs.modal', function() {
            $('#estudianteForm')[0].reset();
            $('#estudianteId').val('');
            $('#modalTitle').text('Nuevo Estudiante');
        });
    </script>
</body>
</html>