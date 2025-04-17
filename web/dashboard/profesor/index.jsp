<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Profesor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Sistema Académico</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#" onclick="cargarMisCursos()">Mis Cursos</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="mostrarFormularioTarea()">Nueva Tarea</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="cargarTareasPendientes()">Calificar Tareas</a>
                    </li>
                </ul>
                <form class="d-flex" action="/logout" method="post">
                    <button class="btn btn-outline-light" type="submit">Cerrar Sesión</button>
                </form>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div id="contenido"></div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const idProfesor = <%= session.getAttribute("idUsuario") %>;

        function cargarMisCursos() {
            fetch(`/profesor/cursos/mis-cursos?id_profesor=${idProfesor}`)
                .then(response => response.json())
                .then(cursos => {
                    let html = '<h2>Mis Cursos</h2><div class="row">';
                    cursos.forEach(curso => {
                        html += `
                            <div class="col-md-4 mb-4">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">${curso.nombre}</h5>
                                        <h6 class="card-subtitle mb-2 text-muted">Código: ${curso.codigo}</h6>
                                        <p class="card-text">${curso.descripcion}</p>
                                        <button class="btn btn-primary" onclick="verTareasCurso(${curso.id_curso})">Ver Tareas</button>
                                    </div>
                                </div>
                            </div>`;
                    });
                    html += '</div>';
                    document.getElementById('contenido').innerHTML = html;
                })
                .catch(error => console.error('Error:', error));
        }

        function verTareasCurso(idCurso) {
            fetch(`/profesor/tareas/por-curso?id_curso=${idCurso}`)
                .then(response => response.json())
                .then(tareas => {
                    let html = '<h3>Tareas del Curso</h3><div class="table-responsive"><table class="table">';
                    html += `
                        <thead>
                            <tr>
                                <th>Título</th>
                                <th>Descripción</th>
                                <th>Fecha Asignación</th>
                                <th>Fecha Entrega</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>`;
                    tareas.forEach(tarea => {
                        html += `
                            <tr>
                                <td>${tarea.titulo}</td>
                                <td>${tarea.descripcion}</td>
                                <td>${new Date(tarea.fecha_asignacion).toLocaleDateString()}</td>
                                <td>${new Date(tarea.fecha_entrega).toLocaleDateString()}</td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="calificarTarea(${tarea.id_tarea})">Calificar</button>
                                </td>
                            </tr>`;
                    });
                    html += '</tbody></table></div>';
                    document.getElementById('contenido').innerHTML = html;
                })
                .catch(error => console.error('Error:', error));
        }

        function mostrarFormularioTarea() {
            fetch(`/profesor/cursos/mis-cursos?id_profesor=${idProfesor}`)
                .then(response => response.json())
                .then(cursos => {
                    let html = `
                        <h2>Nueva Tarea</h2>
                        <form onsubmit="crearTarea(event)" class="needs-validation" novalidate>
                            <div class="mb-3">
                                <label class="form-label">Curso</label>
                                <select class="form-select" name="id_curso" required>
                                    <option value="">Seleccione un curso</option>
                                    ${cursos.map(curso => `<option value="${curso.id_curso}">${curso.nombre}</option>`).join('')}
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Título</label>
                                <input type="text" class="form-control" name="titulo" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Descripción</label>
                                <textarea class="form-control" name="descripcion" required></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Fecha de Entrega</label>
                                <input type="date" class="form-control" name="fecha_entrega" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Crear Tarea</button>
                        </form>`;
                    document.getElementById('contenido').innerHTML = html;
                })
                .catch(error => console.error('Error:', error));
        }

        function crearTarea(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            const data = Object.fromEntries(formData);
            data.fecha_asignacion = new Date().toISOString().split('T')[0];

            fetch('/profesor/tareas', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(data)
            })
            .then(response => response.json())
            .then(result => {
                alert('Tarea creada exitosamente');
                cargarMisCursos();
            })
            .catch(error => console.error('Error:', error));
        }

        function calificarTarea(idTarea) {
            const nota = prompt('Ingrese la nota (0-100):', '');
            const comentario = prompt('Ingrese un comentario:', '');
            
            if (nota !== null && comentario !== null) {
                const data = {
                    id_tarea: idTarea,
                    nota: nota,
                    comentario: comentario
                };

                fetch('/profesor/tareas/calificar', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams(data)
                })
                .then(response => response.json())
                .then(result => {
                    alert('Tarea calificada exitosamente');
                })
                .catch(error => console.error('Error:', error));
            }
        }

        // Cargar mis cursos al iniciar
        cargarMisCursos();
    </script>
</body>
</html>