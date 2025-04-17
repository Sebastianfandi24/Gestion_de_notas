<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Actividades</title>
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
        
        .role-checkbox {
            margin-right: 10px;
        }
        
        .form-check {
            margin-bottom: 0.75rem;
            transition: all 0.2s ease;
        }
        
        .form-check:hover {
            transform: translateX(3px);
        }
        
        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
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
                            <th>Nombre</th>
                            <th>Enlace</th>
                            <th>Roles Asignados</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Los datos se cargarán dinámicamente -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal para Crear/Editar Actividad -->
        <div class="modal fade" id="actividadModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Nueva Actividad</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="actividadForm">
                            <input type="hidden" id="actividadId">
                            <div class="mb-3">
                                <label class="form-label">Nombre</label>
                                <input type="text" class="form-control" id="nombre" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Enlace</label>
                                <input type="text" class="form-control" id="enlace" required>
                                <small class="text-muted">Ejemplo: /dashboard/admin/profesores.jsp</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Roles con Acceso</label>
                                <div id="rolesContainer" class="d-flex flex-wrap gap-3">
                                    <!-- Los roles se cargarán dinámicamente -->
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary" onclick="guardarActividad()">Guardar</button>
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
        let roles = [];

        $(document).ready(function() {
            // Cargar roles
            cargarRoles();

            // Inicializar DataTable
            table = $('#actividadesTable').DataTable({
                ajax: {
                    url: '${pageContext.request.contextPath}/ActividadesController',
                    dataSrc: ''
                },
                columns: [
                    { data: 'id_actividad' },
                    { data: 'nombre' },
                    { data: 'enlace' },
                    { 
                        data: 'roles',
                        render: function(data) {
                            return data.map(rol => 
                                `<span class="badge bg-info me-1">${rol.nombre}</span>`
                            ).join('');
                        }
                    },
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

        function cargarRoles() {
            $.get('${pageContext.request.contextPath}/RolesController', function(data) {
                roles = data;
                actualizarRolesEnModal();
            });
        }

        function actualizarRolesEnModal() {
            const container = $('#rolesContainer');
            container.empty();

            roles.forEach(rol => {
                container.append(`
                    <div class="form-check">
                        <input class="form-check-input role-checkbox" type="checkbox" 
                               value="${rol.id_rol}" id="rol_${rol.id_rol}">
                        <label class="form-check-label" for="rol_${rol.id_rol}">
                            ${rol.nombre}
                        </label>
                    </div>
                `);
            });
        }

        function guardarActividad() {
            const rolesSeleccionados = $('.role-checkbox:checked').map(function() {
                return parseInt($(this).val());
            }).get();

            const actividad = {
                id_actividad: $('#actividadId').val(),
                nombre: $('#nombre').val(),
                enlace: $('#enlace').val(),
                roles: rolesSeleccionados
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/ActividadesController',
                type: actividad.id_actividad ? 'PUT' : 'POST',
                contentType: 'application/json',
                data: JSON.stringify(actividad),
                success: function(response) {
                    $('#actividadModal').modal('hide');
                    table.ajax.reload();
                    mostrarMensaje('Actividad guardada exitosamente', 'success');
                },
                error: function(xhr, status, error) {
                    mostrarMensaje('Error al guardar la actividad: ' + error, 'danger');
                }
            });
        }

        function editarActividad(id) {
            $.get('${pageContext.request.contextPath}/ActividadesController?id=' + id, function(actividad) {
                $('#actividadId').val(actividad.id_actividad);
                $('#nombre').val(actividad.nombre);
                $('#enlace').val(actividad.enlace);

                // Marcar roles asignados
                $('.role-checkbox').prop('checked', false);
                actividad.roles.forEach(rol => {
                    $(`#rol_${rol.id_rol}`).prop('checked', true);
                });

                $('#modalTitle').text('Editar Actividad');
                $('#actividadModal').modal('show');
            });
        }

        function eliminarActividad(id) {
            if (confirm('¿Está seguro de que desea eliminar esta actividad?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/ActividadesController?id=' + id,
                    type: 'DELETE',
                    success: function(response) {
                        table.ajax.reload();
                        mostrarMensaje('Actividad eliminada exitosamente', 'success');
                    },
                    error: function(xhr, status, error) {
                        mostrarMensaje('Error al eliminar la actividad: ' + error, 'danger');
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

        $('#actividadModal').on('hidden.bs.modal', function() {
            $('#actividadForm')[0].reset();
            $('#actividadId').val('');
            $('.role-checkbox').prop('checked', false);
            $('#modalTitle').text('Nueva Actividad');
        });
    </script>
</body>
</html>