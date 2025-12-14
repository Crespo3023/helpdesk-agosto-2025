# Manual Técnico - Sistema HelpDesk

## Tabla de Contenidos
1. [Arquitectura del Sistema](#arquitectura-del-sistema)
2. [Modelo de Datos](#modelo-de-datos)
3. [Instalación](#instalación)
4. [Configuración](#configuración)
5. [Endpoints y Rutas](#endpoints-y-rutas)
6. [Seguridad](#seguridad)

---

## Arquitectura del Sistema

### Stack Tecnológico

**Back-end**:
- **Framework**: Flask (Python)
- **Base de Datos**: MariaDB
- **ORM**: PyMySQL / MySQL Connector
- **Autenticación**: Flask-Login con sesiones
- **Hash de Contraseñas**: Werkzeug (bcrypt)

**Front-end**:
- **Motor de Templates**: Jinja2
- **CSS Framework**: Bootstrap 3
- **Estilos Personalizados**: CSS custom

**Estructura del Proyecto**:
```
FINAL_PROJECT_FULL_STACK/
│
├── helpdesk_app/               # Carpeta principal de la aplicación
│   ├── __pycache__/           # Cache de Python (generado)
│   ├── docs/                  # Documentación
│   │   ├── manual_usuario.md
│   │   ├── manual_tecnico.md
│   │   └── er_diagram.png
│   │
│   ├── static/                # Archivos estáticos
│   │   └── css/
│   │       ├── bootstrap3.min.css
│   │       ├── custom.css
│   │       └── login.css
│   │
│   ├── templates/             # Templates HTML (Jinja2)
│   │   ├── base.html
│   │   ├── dashboard.html
│   │   ├── login.html
│   │   ├── ticket_detail.html
│   │   ├── ticket_new.html
│   │   ├── tickets_list.html
│   │   └── users_list.html
│   │
│   ├── venv/                 # Entorno virtual de Python
│   ├── .env                  # Variables de entorno (NO subir esta info de forma publica)
│   ├── .gitignore            # Exclusiones de Git
│   ├── app.py                # Aplicación principal Flask
│   ├── config.py             # Configuración de la aplicación
│   ├── db_init.sql           # Script de inicialización de BD
│   ├── generate_hash.py      # Utilidad para generar hashes
│   ├── requirements.txt      # Dependencias del proyecto
│   └── test_db.py            # Script de prueba de conexión
```

### Flujo de la Aplicación

```
Usuario (Navegador)
        ↓
    app.py (Flask)
        ↓
    ├─→ Rutas de autenticación (/login, /logout)
    ├─→ Rutas de tickets (/tickets, /ticket/new, /ticket/<id>)
    ├─→ Rutas de usuarios (/users) [solo ADMIN]
    └─→ Dashboard (/)
        ↓
    Templates (Jinja2)
        ↓
    MariaDB (base de datos)
```

---

## Modelo de Datos

### Diagrama Entidad-Relación

Ver archivo: `screenshots/docs/er_diagram.png`

### Descripción de Tablas

#### Tabla: `users`

Almacena la información de todos los usuarios del sistema.

| Campo          | Tipo         |         Descripción            | Restricciones 
|----------------|--------------|--------------------------------|---------------
| `id`           | INT          | Identificador único            | PRIMARY KEY, AUTO_INCREMENT 
| `name`         | VARCHAR(100) | Nombre completo del usuario    | NOT NULL 
| `email`        | VARCHAR(150) | Correo electrónico             | NOT NULL, UNIQUE 
| `password_hash`| VARCHAR(255) | Hash de la contraseña (bcrypt) | NOT NULL 
| `role`         | ENUM         | Rol del usuario                |'ADMIN', 'AGENT', 'USER',DEFAULT 'USER'
| `created_at`   | DATETIME     | Fecha de creación              | NOT NULL, DEFAULT CURRENT_TIMESTAMP 

**Índices**:
- Primary Key: `id`
- Unique: `email`

---

#### Tabla: `tickets`

Almacena todos los tickets de soporte del sistema.

| Campo       | Tipo       | Descripción                       | Restricciones 
|-------------|------------|-----------------------------------|-----------------------------------------|
| `id`        |INT         | Identificador único del ticket    | PRIMARY KEY, AUTO_INCREMENT 
| `title`     |VARCHAR(200)| Título del ticket                 | NOT NULL 
|`description`|TEXT        | Descripción detallada del problema| NOT NULL
|`status`     |ENUM        |Estado del ticket                  |'OPEN','IN_PROGRESS','RESOLVED',DFLT'OPEN'
| `priority`  |ENUM        | Prioridad del ticket              |'LOW', 'MEDIUM', 'HIGH', DFLT 'MEDIUM' 
|`created_at` |DATETIME    | Fecha de creación                 |NOT NULL, DFLT CURRENT_TIMESTAMP 
|`updated_at` |DATETIME    | Fecha de última actualización     |NOT NULL,DFLT CURRENT_TIMESTAMP ON UPDATE
|`created_by` | INT        | ID del usuario que creó el ticket | NOT NULL, FOREIGN KEY -> users(id) 
|`assigned_to`| INT        | ID del agente asignado            | NULL, FOREIGN KEY -> users(id) 

**Relaciones**:
- `created_by` -> `users.id` 
- `assigned_to` -> `users.id` 

**Índices**:
- Primary Key: `id`
- Foreign Keys: `created_by`, `assigned_to`

---

#### Tabla: `ticket_comments`

Almacena los comentarios asociados a cada ticket.

| Campo        | Tipo     | Descripción                           | Restricciones |
|--------------|----------|---------------------------------------|---------------
| `id`         | INT      | Identificador único del comentario    | PRIMARY KEY, AUTO_INCREMENT 
| `ticket_id`  | INT      | ID del ticket asociado                | NOT NULL, FOREIGN KEY -> tickets(id) 
| `user_id`    | INT      | ID del usuario que hizo el comentario | NOT NULL, FOREIGN KEY -> users(id) 
| `comment`    | TEXT     | Contenido del comentario              | NOT NULL 
| `created_at` | DATETIME | Fecha de creación                     | NOT NULL, DEFAULT CURRENT_TIMESTAMP 

**Relaciones**:
- `ticket_id` -> `tickets.id` (Muchos a Uno)
- `user_id` -> `users.id` (Muchos a Uno)

**Índices**:
- Primary Key: `id`
- Foreign Keys: `ticket_id`, `user_id`



### Relaciones del Modelo

```
users (1) ------- crea ------> (N) tickets
users (1) ------- asignado ------> (N) tickets
users (1) ------- comenta ------> (N) ticket_comments
tickets(1)------- tiene ------> (N) ticket_comments
```

**Cardinalidad**:
- Un usuario puede crear múltiples tickets 
- Un usuario (agente) puede tener asignados múltiples tickets 
- Un ticket puede tener múltiples comentarios 
- Un usuario puede hacer múltiples comentarios 



## Instalación

### Requisitos Previos

- **Python**: versión 3.8 o superior
- **MariaDB/MySQL**: versión 10.x o superior
- **pip**: gestor de paquetes de Python
    -Flask
    -pymysql
    -python-dotenv
    -Werkzeug
    -pytest

### Paso 1: Clonar el Repositorio

```bash
# Si el proyecto está en un repositorio Git
git clone <url-del-repositorio>
cd FINAL_PROJECT_FULL_STACK/helpdesk_app

# O simplemente navega a la carpeta del proyecto
cd helpdesk_app
```

### Paso 2: Crear el Entorno Virtual

```bash
# Crear entorno virtual
python -m venv venv

# Activar entorno virtual
# En Windows:
venv\Scripts\activate

# En Linux/Mac:
source venv/bin/activate
```

### Paso 3: Instalar Dependencias

```bash
pip install -r requirements.txt
```

**Contenido de `requirements.txt`**:
```
Flask==3.0.0
PyMySQL==1.1.0
Flask-Login==0.6.3 (Si aun no la tienes)
python-dotenv==1.0.0
Werkzeug==3.0.0
pytest
```

### Paso 4: Crear la Base de Datos

1. Accede a MariaDB/MySQL:

```bash
mysql -u root -p
```

2. Crea la base de datos:

```sql
CREATE DATABASE helpdesk_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. Sal del cliente MySQL:

```sql
exit;
```

### Paso 5: Ejecutar el Script SQL

Ejecuta el script de inicialización que crea las tablas:

```bash
mysql -u root -p helpdesk_db < db_init.sql
```

**Contenido de `db_init.sql`**:
```sql
-- Eliminar tablas si existen (para reinstalación limpia)
DROP TABLE IF EXISTS ticket_comments;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS users;

--Crea la base de datos con el nombre deseado en este caso helpdesk_db
CREATE DATABASE helpdesk_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

--Para que tu sistema utilice la base de datos creada
USE helpdesk_db;

-- Crear tabla de usuarios
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'AGENT', 'USER') NOT NULL DEFAULT 'USER',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de tickets
CREATE TABLE tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL, 
    description TEXT NOT NULL,
    status ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED') NOT NULL DEFAULT 'OPEN',
    priority ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL DEFAULT 'MEDIUM',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NOT NULL,
    assigned_to INT NULL,
    CONSTRAINT fk_tickets_created_by FOREIGN KEY (created_by) REFERENCES users(id),
    CONSTRAINT fk_tickets_assigned_to FOREIGN KEY (assigned_to) REFERENCES users(id)
);

-- Crear tabla de comentarios
CREATE TABLE ticket_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comments_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id),
    CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insertar usuario administrador por defecto
-- Contraseña de Ejemplo: admin123 (cambiarla por una constraseña segura)
INSERT INTO users (name, email, password_hash, role) VALUES
('Administrador', 'admin@example.com', 'COLOCAR_EL_HASH_CREADO_DEL_PASSWORD', 'ADMIN');
```

**Nota**: Usa `generate_hash.py` para generar el hash de la contraseña del administrador.

### Paso 6: Configurar Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto:

```bash
touch .env
```

Edita el archivo `.env` y agrega la configuración:

```env
# Configuración de Flask
FLASK_APP=app.py
FLASK_ENV=development
SECRET_KEY=tu_clave_secreta_muy_segura_aqui_cambiar_en_produccion

# Configuración de Base de Datos
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=tu_password_mysql
DB_NAME=helpdesk_db
```

**Importante**: 
- Cambia `SECRET_KEY` por una cadena aleatoria y segura
- Cambia `DB_PASSWORD` por tu contraseña de MySQL
- **NUNCA** versiones el archivo `.env` en Git (ya debe estar en `.gitignore`)

### Paso 7: Generar Hash para el Usuario Admin

Ejecuta el script de generación de hash:

```bash
python generate_hash.py
```

Sigue las instrucciones para generar el hash de la contraseña e insértalo manualmente en la base de datos o actualiza el script `db_init.sql`.

### Paso 8: Verificar la Conexión con tu base de datos

Ejecuta el script de prueba:

```bash
python test_db.py
```

Deberías ver: `✅ ¡Conexión de la base de datos exitosa!`

De suceder lo contrario veras: `❌ Error de conexión`

### Paso 9: Ejecutar la Aplicación

```bash
python app.py
```

La aplicación estará disponible en: `http://127.0.0.1:5000`



## Configuración

### Archivo `config.py`

Este archivo centraliza la configuración de la aplicación:

```python
import os
from dotenv import load_dotenv
load_dotenv()
class Config:
    SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-key-change-this")
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_USER = os.getenv("DB_USER", "helpdesk_user")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "helpdesk_password")
    DB_NAME = os.getenv("DB_NAME", "helpdesk_db")
    
```

### Configuración de Producción

Para desplegar en producción, asegúrate de:

1. Usar una `SECRET_KEY` robusta (mínimo 32 caracteres aleatorios)
3. Usar un servidor web 
4. Habilitar HTTPS/SSL
5. Configurar firewall para el puerto de MariaDB (para mayor seguridad)


## Endpoints y Rutas

### Tabla de Endpoints Principales

| Método |         Ruta            |        Descripción         | Roles Permitidos | Autenticación 
|--------|-------------------------|----------------------------|------------------|---------------
| `GET`  | `/`                     | Dashboard principal        | Todos            | Requerida 
| `GET`  | `/login`                | Página de inicio de sesión | Público          | No 
| `POST` | `/login`                | Procesar inicio de sesión  | Público          | No 
| `GET`  | `/logout`               | Cerrar sesión              | Todos            | Requerida 
| `GET`  | `/tickets`              | Lista de tickets           | Todos            | Requerida 
| `GET`  | `/ticket/<id>`          | Detalle de un ticket       | Todos            | Requerida 
| `GET`  | `/ticket/new`           | Formulario de nuevo ticket | Todos            | Requerida 
| `POST` | `/ticket/new`           | Crear nuevo ticket         | Todos            | Requerida 
| `POST` | `/ticket/<id>/update`   | Actualizar ticket          | AGENT, ADMIN     | Requerida 
| `POST` | `/ticket/<id>/comment`  | Agregar comentario         | Todos            | Requerida 
| `GET`  | `/users`                | Lista de usuarios          | ADMIN            | Requerida 
| `POST` | `/user/<id>/change_role`| Cambiar rol de usuario     | ADMIN            | Requerida 

### Detalle de Endpoints

#### Autenticación

**`GET /login`**
- Crea/genera el formulario de inicio de sesión
- Parámetros: Ninguno
- Respuesta: Template `login.html`

**`POST /login`**
- Autentica al usuario
- Parámetros (form-data):
  - `email`: String (requerido)
  - `password`: String (requerido)
- Respuesta: 
  - Éxito: Redirect a `/` (dashboard)
  - Error: Redirect a `/login` con mensaje de error

**`GET /logout`**
- Cierra la sesión del usuario
- Respuesta: Redirect a `/login`

#### Dashboard

**`GET /`**
- Página principal después del login
- Requiere: Autenticación
- Respuesta: Template `dashboard.html` con flash comment recibiendo al usuario que hizo login



#### Tickets

**`GET /tickets`**
- Lista todos los tickets según el rol del usuario
- Requiere: Autenticación
- Filtros aplicados:
  - USER: Solo tickets propios (`created_by = user_id`)
  - AGENT/ADMIN: Todos los tickets
- Respuesta: Template `tickets_list.html`

**`GET /ticket/<id>`**
- Muestra detalles de un ticket específico
- Requiere: Autenticación
- Parámetros URL: `id` (INT)
- Validación: 
  - USER solo puede ver sus propios tickets
  - AGENT/ADMIN pueden ver cualquier ticket
- Respuesta: Template `ticket_detail.html` con información del ticket y comentarios

**`GET /ticket/new`**
- Genera el formulario para crear ticket
- Requiere: Autenticación
- Respuesta: Template `ticket_new.html`

**`POST /ticket/new`**
- Crea un nuevo ticket
- Requiere: Autenticación
- Parámetros (form-data):
  - `title`: String (requerido, max 200 caracteres)
  - `description`: Text (requerido)
  - `priority`: ENUM ('LOW', 'MEDIUM', 'HIGH')
- Respuesta:
  - Éxito: Redirect a `/tickets`
  - Error: Template `ticket_new.html` con mensaje de error

**`POST /ticket/<id>/update`**
- Actualiza un ticket existente
- Requiere: Autenticación (AGENT o ADMIN) el usuario solo puede editar sus propios tickets
- Parámetros URL: `id` (INT)
- Parámetros (form-data):
  - `status`: ENUM ('OPEN', 'IN_PROGRESS', 'RESOLVED')
  - `priority`: ENUM ('LOW', 'MEDIUM', 'HIGH')
  - `assigned_to`: INT (ID del agente) (opcional)
- Respuesta:
  - Éxito: Redirect a `tickets_list.html`

**`POST /ticket/<id>/comment`**
- Agrega un comentario a un ticket
- Requiere: Autenticación
- Parámetros URL: `id` (INT)
- Parámetros (form-data):
  - `comment`: Text (requerido)
- Respuesta: Redirect a `/ticket/<id>`



#### Usuarios (Solo ADMIN)

**`GET /users`**
- Lista todos los usuarios del sistema
- Requiere: Autenticación (ADMIN)
- Respuesta: 
  - Éxito: Template `users_list.html`

**`POST /user/<id>/user_change_role`**
- Cambia el rol de un usuario
- Requiere: Autenticación (ADMIN)
- Parámetros URL: `user_id` (INT)
- Parámetros (form-data):
  - `new_role`: ENUM ('USER', 'AGENT', 'ADMIN')
- Respuesta:
  - Éxito: Redirect a `/users`


## Seguridad

### Autenticación y Autorización

1. **Flask-Login**: Manejo de sesiones de usuario
2. **Password Hashing**: Usando `werkzeug.security.generate_password_hash()` con método scrypt
3. **Login required**: Dependiendo el rol accedera a un dashboard propio teniendo acceso limitado dependiendo su ROL

### Protección contra CSRF

- Implementar tokens CSRF en formularios (recomendado con Flask-WTF)

### Validación de Entrada

- Sanitización de datos en formularios
- Validación de tipos y longitudes
- Uso de consultas parametrizadas para prevenir SQL injection

### Variables de Entorno

- Credenciales sensibles en `.env` (no versionado)
- `.gitignore` configurado correctamente


## Solución de Problemas

### Error de Conexión a la Base de Datos

```
pymysql.err.OperationalError: (2003, "Can't connect to MySQL server")
```

**Solución**:
1. Verifica que MariaDB esté corriendo: `systemctl status mariadb`
2. Revisa las credenciales en `.env`
3. Verifica que el puerto 3306 o 3307 esté abierto (dependiendo la configuracion)
4. Verifica si la base de datos esta creada correctamente accediendo al `http://localhost/phpmyadmin`


### Error de Importación de Módulos

```
ModuleNotFoundError: No module named 'flask'
```

**Solución Importante**:
1. Activa el entorno virtual: `source venv/bin/activate`
2. Reinstala dependencias: `pip install -r requirements.txt`


## Mantenimiento

### Backup de Base de Datos

```bash
# Crear backup
mysqldump -u root -p helpdesk_db > backup_$(date +%Y%m%d).sql

# Restaurar backup
mysql -u root -p helpdesk_db < backup_20241213.sql
```

### Actualización del Sistema

1. Hacer backup de la base de datos
2. Actualizar el código
3. Actualizar dependencias: `pip install -r requirements.txt --upgrade`
4. Ejecutar migraciones si es necesario
5. Reiniciar la aplicación

**Importante tener todo actualizado**


**Faceted Search (Mejora del codigo)**:
- filtro por titulo o texto del titulo del ticket (escribiendo el nombre del ticket)
- filtro por priority 
- filtro por status

**Link del repositorio**
`https://github.com/Crespo3023/helpdesk-agosto-2025#`
