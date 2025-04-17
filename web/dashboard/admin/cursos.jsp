<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Cursos</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet">
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
        
        .btn-success {
            background-color: var(--success-color);
            border-color: var(--success-color);
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
        
        /* Select2 specific styles */
        .select2-container--bootstrap-5 .select2-selection {
            border-radius: 8px;
            min-height: calc(1.5em + 0.75rem + 2px);
            padding: 0.6rem 1rem;
            font-size: 1rem;
            line-height: 1.5;
            border: 1px solid rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        
        .select2-container--bootstrap-5 .select2-selection--multiple .select2-selection__choice {
            background: linear-gradient(to right, var(--primary-color), var(--accent-color));
            border: none;
            color: white;
            padding: 0.35em 0.65em;
            margin-right: 0.5em;
            border-radius: 50px;
            box-shadow: 0 2px 5px rgba(67, 97, 238, 0.2);
        }
        
        .select2-container--bootstrap-5 .select2-selection--multiple .select2-selection__choice__remove {
            color: rgba(255, 255, 255, 0.9);
            margin-left: 0.5em;
            border-right: none;
            transition: all 0.2s ease;
        }
        
        .select2-container--bootstrap-5 .select2-selection--multiple .select2-selection__choice__remove:hover {
            background-color: transparent;
            color: white;
            transform: scale(1.2);
        }
        
        .select2-container--bootstrap-5 .select2-dropdown {
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border: none;
            padding: 0.5rem;
        }
        
        .select2-container--bootstrap-5 .select2-results__option--highlighted {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary-color);
        }
        
        .select2-container--bootstrap-5 .select2-results__option--selected {
            background-color: var(--primary-color);
            color: white;
        }
        
        .badge {
            padding: 0.5em 0.8em;
            border-radius: 50px;
            font-weight: 500;
            letter-spacing: 0.5px;
        }
        
        .bg-info {
            background: linear-gradient(to right, var(--primary-color), var(--accent-color));
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
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

        <!-- Modal para Crear/Editar Curso -->
        <div class="modal fade" id="cursoModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Nuevo Curso</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="cursoForm">
                            <input type="hidden" id="cursoId">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Código</label>
                                    <input type="text" class="form-control" id="codigo" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Nombre</label>
                                    <input type="text" class="form-control" id="nombre" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Descripción</label>
                                <textarea class="form-control" id="descripcion" rows="3"></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Profesor</label>
                                <select class="form-select" id="profesor" required>
                                    <option value="">Seleccione un profesor</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Estudiantes</label>
                                <select class="form-select" id="estudiantes" multiple>
                                    <!-- Las opciones se cargarán dinámicamente -->
                                </select>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary" onclick="guardarCurso()">Guardar</button>
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
    <!-- Select2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <script>
        let table;

        $(document).ready(function() {
            // Inicializar Select2 para profesor y estudiantes
            $('#profesor').select2({
                theme: 'bootstrap-5',
                placeholder: 'Seleccione un profesor',
                ajax: {
                    url: '${pageContext.request.contextPath}/ProfesoresController',
                    dataType: 'json',
                    processResults: function(data) {
                        return {
                            results: data.map(profesor => ({
                                id: profesor.id_profesor,
                                text: profesor.nombre
                            }))
                        };
                    }
                }
            });

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

            // Inicializar DataTable
            table = $('#cursosTable').DataTable({
                ajax: {
                    url: '${pageContext.request.contextPath}/CursosController',
                    dataSrc: ''
                },
                columns: [
                    { data: 'id_curso' },
                    { data: 'codigo' },
                    { data: 'nombre' },
                    { data: 'profesor_nombre' },
                    { 
                        data: 'estudiantes',
                        render: function(data) {
                            return `<span class="badge bg-info">${data ? data.length : 0} estudiantes</span>`;
                        }
                    },
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
                                    <button class="btn btn-sm btn-success" onclick="verEstudiantes(${row.id_curso})" title="Ver estudiantes">
                                        <i class="fas fa-users"></i>
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

        function guardarCurso() {
            const curso = {
                id_curso: $('#cursoId').val(),
                codigo: $('#codigo').val(),
                nombre: $('#nombre').val(),
                descripcion: $('#descripcion').val(),
                idProfesor: $('#profesor').val(),
                estudiantes: $('#estudiantes').val()
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/CursosController',
                type: curso.id_curso ? 'PUT' : 'POST',
                contentType: 'application/json',
                data: JSON.stringify(curso),
                success: function(response) {
                    $('#cursoModal').modal('hide');
                    table.ajax.reload();
                    mostrarMensaje('Curso guardado exitosamente', 'success');
                },
                error: function(xhr, status, error) {
                    mostrarMensaje('Error al guardar el curso: ' + error, 'danger');
                }
            });
        }

        function editarCurso(id) {
            $.get('${pageContext.request.contextPath}/CursosController?id=' + id, function(curso) {
                $('#cursoId').val(curso.id_curso);
                $('#codigo').val(curso.codigo);
                $('#nombre').val(curso.nombre);
                $('#descripcion').val(curso.descripcion);

                // Cargar profesor
                const profesorOption = new Option(curso.profesor_nombre, curso.idProfesor, true, true);
                $('#profesor').append(profesorOption).trigger('change');

                // Cargar estudiantes
                if (curso.estudiantes) {
                    const estudiantesOptions = curso.estudiantes.map(est => {
                        return new Option(est.nombre, est.id_estudiante, true, true);
                    });
                    $('#estudiantes').append(estudiantesOptions).trigger('change');
                }

                $('#modalTitle').text('Editar Curso');
                $('#cursoModal').modal('show');
            });
        }

        function eliminarCurso(id) {
            if (confirm('¿Está seguro de que desea eliminar este curso?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/CursosController?id=' + id,
                    type: 'DELETE',
                    success: function(response) {
                        table.ajax.reload();
                        mostrarMensaje('Curso eliminado exitosamente', 'success');
                    },
                    error: function(xhr, status, error) {
                        mostrarMensaje('Error al eliminar el curso: ' + error, 'danger');
                    }
                });
            }
        }

        function verEstudiantes(id) {
            $.get('${pageContext.request.contextPath}/CursosController/estudiantes?id=' + id, function(estudiantes) {
                const estudiantesList = estudiantes.map(est => 
                    `<li class="list-group-item">${est.nombre} - ${est.numero_identificacion}</li>`
                ).join('');

                const modal = $(`
                    <div class="modal fade" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Estudiantes del Curso</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <ul class="list-group">${estudiantesList}</ul>
                                </div>
                            </div>
                        </div>
                    </div>
                `);

                modal.modal('show');
            });
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

        $('#cursoModal').on('hidden.bs.modal', function() {
            $('#cursoForm')[0].reset();
            $('#cursoId').val('');
            $('#profesor').val(null).trigger('change');
            $('#estudiantes').val(null).trigger('change');
            $('#modalTitle').text('Nuevo Curso');
        });
    </script>
</body>
</html>