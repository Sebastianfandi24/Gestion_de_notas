<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Profesores</title>
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
                        <form id="profesorForm">
                            <input type="hidden" id="profesorId">
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
                                    <label class="form-label">Grado Académico</label>
                                    <select class="form-select" id="gradoAcademico">
                                        <option value="Licenciatura">Licenciatura</option>
                                        <option value="Maestría">Maestría</option>
                                        <option value="Doctorado">Doctorado</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Especialización</label>
                                    <input type="text" class="form-control" id="especializacion">
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Fecha de Contratación</label>
                                    <input type="date" class="form-control" id="fechaContratacion">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Estado</label>
                                    <select class="form-select" id="estado">
                                        <option value="Activo">Activo</option>
                                        <option value="Baja">Baja</option>
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
                        <button type="button" class="btn btn-primary" onclick="guardarProfesor()">Guardar</button>
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
        let profesoresData = []; // Variable para almacenar los datos obtenidos
        const logPrefix = "[ProfesoresJSP]";
        
        // Función para registro en consola
        function log(level, message, data) {
            const timestamp = new Date().toISOString();
            
            switch (level) {
                case 'info':
                    console.info(`${timestamp} ${logPrefix} INFO: ${message}`, data || '');
                    break;
                case 'warn':
                    console.warn(`${timestamp} ${logPrefix} WARN: ${message}`, data || '');
                    break;
                case 'error':
                    console.error(`${timestamp} ${logPrefix} ERROR: ${message}`, data || '');
                    break;
                default:
                    console.log(`${timestamp} ${logPrefix} ${message}`, data || '');
            }
        }

        // Función para verificar la conexión al servidor
        function verificarConexion() {
            log('info', 'Verificando conexión con el servidor...');
            
            fetch('${pageContext.request.contextPath}/ProfesoresController', {
                method: 'HEAD'
            })
            .then(response => {
                if (response.ok) {
                    log('info', `Conexión exitosa al servidor. Status: ${response.status}`);
                } else {
                    log('error', `Problemas con la conexión al servidor. Status: ${response.status}`);
                    mostrarMensaje(`Hay problemas de conexión con el servidor. Código: ${response.status}`, 'danger');
                }
            })
            .catch(error => {
                log('error', 'Error al verificar la conexión con el servidor', error);
                mostrarMensaje('No se puede conectar con el servidor. Verifique su conexión a internet.', 'danger');
            });
        }

        // Función para cargar datos directamente sin usar DataTables para AJAX
        function cargarDatosProfesores() {
            const serverUrl = "${pageContext.request.contextPath}/ProfesoresController";
            log('info', `Cargando datos de profesores desde: ${serverUrl}`);
            
            $.ajax({
                url: serverUrl,
                type: 'GET',
                contentType: 'application/json',
                success: function(data) {
                    log('info', 'Datos recibidos correctamente:', data);
                    profesoresData = data;
                    inicializarTabla(profesoresData);
                },
                error: function(xhr, status, error) {
                    log('error', 'Error al obtener datos de profesores:', { status, error });
                    log('error', 'Detalles de la respuesta:', { 
                        status: xhr.status, 
                        statusText: xhr.statusText,
                        responseText: xhr.responseText,
                        url: serverUrl
                    });
                    
                    let mensajeError = `Error al cargar datos: ${error}. URL: ${serverUrl}`;
                    mostrarMensaje(mensajeError, 'danger');
                }
            });
        }

        // Función para inicializar la tabla con datos ya cargados
        function inicializarTabla(datos) {
            log('info', 'Inicializando DataTable con datos precargados...');
            try {
                table = $('#profesoresTable').DataTable({
                    data: datos,
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
                    },
                    processing: true,
                    drawCallback: function() {
                        log('info', 'DataTable dibujada correctamente');
                    },
                    initComplete: function() {
                        log('info', 'DataTable inicializada completamente');
                    }
                });
                
                log('info', 'DataTable creada exitosamente');
            } catch (error) {
                log('error', 'Error al crear DataTable:', error);
                mostrarMensaje('Error al inicializar la tabla de profesores: ' + error.message, 'danger');
            }
        }

        $(document).ready(function() {
            log('info', 'Página de profesores iniciada');
            verificarConexion();
            cargarDatosProfesores(); // Cargar datos y después inicializar la tabla
        });

        function guardarProfesor() {
            log('info', 'Iniciando guardar profesor...');
            const profesor = {
                id_profesor: $('#profesorId').val() || null,
                id_usu: $('#usuarioId').val() || null,
                nombre: $('#nombre').val(),
                correo: $('#correo').val(),
                fecha_nacimiento: $('#fechaNacimiento').val(),
                telefono: $('#telefono').val(),
                grado_academico: $('#gradoAcademico').val(),
                especializacion: $('#especializacion').val(),
                fecha_contratacion: $('#fechaContratacion').val(),
                estado: $('#estado').val(),
                direccion: $('#direccion').val()
            };

            log('info', 'Datos del profesor a guardar:', profesor);

            $.ajax({
                url: '${pageContext.request.contextPath}/ProfesoresController',
                type: profesor.id_profesor ? 'PUT' : 'POST',
                contentType: 'application/json',
                data: JSON.stringify(profesor),
                beforeSend: function() {
                    log('info', `Enviando petición ${profesor.id_profesor ? 'PUT' : 'POST'} al servidor...`);
                },
                success: function(response) {
                    log('info', 'Respuesta exitosa:', response);
                    $('#profesorModal').modal('hide');
                    // Recargar datos en lugar de usar table.ajax.reload()
                    cargarDatosProfesores();
                    mostrarMensaje('Profesor guardado exitosamente', 'success');
                },
                error: function(xhr, status, error) {
                    log('error', 'Error en la solicitud guardarProfesor:', { status, error });
                    log('error', 'Respuesta del servidor:', xhr.responseText);
                    
                    let mensajeError = 'Error al guardar el profesor: ' + error;
                    
                    try {
                        if (xhr.responseText) {
                            const jsonResponse = JSON.parse(xhr.responseText);
                            if (jsonResponse.error) {
                                mensajeError += '. Detalle: ' + jsonResponse.error;
                            }
                        }
                    } catch (e) {
                        log('warn', 'No se pudo parsear la respuesta como JSON', e);
                    }
                    
                    mostrarMensaje(mensajeError, 'danger');
                }
            });
        }

        function editarProfesor(id) {
            log('info', 'Editando profesor ID:', id);
            $.ajax({
                url: '${pageContext.request.contextPath}/ProfesoresController?id=' + id,
                type: 'GET',
                beforeSend: function() {
                    log('info', `Solicitando datos del profesor ID: ${id}`);
                },
                success: function(profesor) {
                    log('info', 'Datos del profesor recibidos:', profesor);
                    $('#profesorId').val(profesor.id_profesor);
                    $('#usuarioId').val(profesor.id_usu);
                    $('#nombre').val(profesor.nombre);
                    $('#correo').val(profesor.correo);
                    $('#fechaNacimiento').val(profesor.fecha_nacimiento);
                    $('#telefono').val(profesor.telefono);
                    $('#gradoAcademico').val(profesor.grado_academico);
                    $('#especializacion').val(profesor.especializacion);
                    $('#fechaContratacion').val(profesor.fecha_contratacion);
                    $('#estado').val(profesor.estado);
                    $('#direccion').val(profesor.direccion);
                    
                    $('#modalTitle').text('Editar Profesor');
                    $('#profesorModal').modal('show');
                },
                error: function(xhr, status, error) {
                    log('error', 'Error al obtener datos del profesor:', { status, error });
                    log('error', 'Respuesta del servidor:', xhr.responseText);
                    
                    let mensajeError = 'Error al cargar datos del profesor: ' + error;
                    
                    try {
                        if (xhr.responseText) {
                            const jsonResponse = JSON.parse(xhr.responseText);
                            if (jsonResponse.error) {
                                mensajeError += '. Detalle: ' + jsonResponse.error;
                            }
                        }
                    } catch (e) {
                        log('warn', 'No se pudo parsear la respuesta como JSON', e);
                    }
                    
                    mostrarMensaje(mensajeError, 'danger');
                }
            });
        }

        function eliminarProfesor(id) {
            if (confirm('¿Está seguro de que desea eliminar este profesor?')) {
                log('info', 'Eliminando profesor ID:', id);
                $.ajax({
                    url: '${pageContext.request.contextPath}/ProfesoresController?id=' + id,
                    type: 'DELETE',
                    beforeSend: function() {
                        log('info', `Solicitando eliminación del profesor ID: ${id}`);
                    },
                    success: function(response) {
                        log('info', 'Respuesta de eliminación:', response);
                        // Recargar datos en lugar de usar table.ajax.reload()
                        cargarDatosProfesores();
                        mostrarMensaje('Profesor eliminado exitosamente', 'success');
                    },
                    error: function(xhr, status, error) {
                        log('error', 'Error al eliminar profesor:', { status, error });
                        log('error', 'Respuesta del servidor:', xhr.responseText);
                        
                        let mensajeError = 'Error al eliminar el profesor: ' + error;
                        
                        try {
                            if (xhr.responseText) {
                                const jsonResponse = JSON.parse(xhr.responseText);
                                if (jsonResponse.error) {
                                    mensajeError += '. Detalle: ' + jsonResponse.error;
                                }
                            }
                        } catch (e) {
                            log('warn', 'No se pudo parsear la respuesta como JSON', e);
                        }
                        
                        mostrarMensaje(mensajeError, 'danger');
                    }
                });
            }
        }

        function mostrarMensaje(mensaje, tipo) {
            log(tipo === 'success' ? 'info' : 'warn', 'Mostrando mensaje: ' + mensaje);
            const icon = tipo === 'success' ? 'check-circle' : 'exclamation-circle';
            const alertDiv = $(`<div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
                <i class="fas fa-${icon} me-2"></i>${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>`);
            
            $('.container-fluid').prepend(alertDiv);
            setTimeout(() => alertDiv.alert('close'), 5000);
        }

        $('#profesorModal').on('hidden.bs.modal', function() {
            log('info', 'Modal de profesor cerrado');
            $('#profesorForm')[0].reset();
            $('#profesorId').val('');
            $('#usuarioId').val('');
            $('#modalTitle').text('Nuevo Profesor');
        });

        // Adicionar un campo oculto para el ID de usuario en el modal
        $(document).ready(function() {
            if ($('#usuarioId').length === 0) {
                $('<input>').attr({
                    type: 'hidden',
                    id: 'usuarioId',
                    name: 'usuarioId'
                }).appendTo('#profesorForm');
            }
        });
    </script>
</body>
</html>