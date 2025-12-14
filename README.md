# 🎫 El Sistema HelpDesk

Es un Sistema web de gestión de tickets con roles de usuario (Admin, Agent, User).

## 📋 Descripción

Aplicación web que permite a los usuarios crear tickets de soporte, a los de rol de agentes gestionarlos, y a los admin supervisar todo el sistema. 
Incluye funcionalidades de asignación de tickets, comentarios, control de acceso por roles y un filtrado de busqueda de tickets (para una mayor eficiencia).

## 🛠️ Tecnologías Usadas

- **Backend**: Python 3.8+, Flask 3.0
- **Base de Datos**: MariaDB/MySQL
- **Frontend**: HTML5, Jinja2, Bootstrap 3, CSS, javascript
- **Autenticación**: Flask-Login
- **Seguridad**: Werkzeug (password hashing)

## ⚡ Instalación Rápida

### 1. Clonar el proyecto
```bash
cd helpdesk_app
```

### 2. Crear entorno virtual
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# o
venv\Scripts\activate  # Windows
```

### 3. Instalar dependencias
```bash
pip install -r requirements.txt
```

### 4. Crear base de datos
```bash
mysql -u root -p
CREATE DATABASE helpdesk_db;
exit;
```

### 5. Ejecutar script SQL
```bash
mysql -u root -p helpdesk_db < db_init.sql
```

### 6. Configurar variables de entorno

Crear archivo `.env` en la raíz del proyecto con las siguientes variables:

```env
# Flask Configuration
SECRET_KEY=tu_clave_secreta_muy_segura_cambiar_en_produccion
FLASK_ENV=development

# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=tu_password_mysql #si tienes una
DB_NAME=helpdesk_db
```

**Variables requeridas:**

| Variable       |                              Descripción                                 |           Ejemplo            | Requerida 
|----------------|--------------------------------------------------------------------------|------------------------------|-------
| `SECRET_KEY`   | Clave secreta para Flask (sesiones y cookies). **Cambiar en producción** | `mi_clave_super_secreta_123` |   Sí  
| `FLASK_ENV`    | Entorno de Flask: `development` o `production`                           | `development`                |   Sí  
| `DB_HOST`      | Host del servidor MariaDB/MySQL                                          | `localhost`                  |   Sí  
| `DB_PORT`      | Puerto del servidor de base de datos                                     | `3306`                       |   Sí  
| `DB_USER`      | Usuario de la base de datos                                              | `root / helpdesk_user`       |   Sí  
| `DB_PASSWORD`  | Contraseña del usuario de base de datos                                  | `tu_password`                |   Sí  
| `DB_NAME`      | Nombre de la base de datos                                               | `helpdesk_db`                |   Sí  

** Importante:** 
- Nunca subir el archivo `.env` en Git (ya incluido en `.gitignore`)
- Usar una `SECRET_KEY` fuerte y aleatoria en producción (mínimo 32 caracteres)
- Cambiar las credenciales por defecto después de la instalación

### 7. Ejecutar la aplicación
```bash
python app.py
(Abrir la terminal del app.py y correr el comando 'flask run')
```

Accede a: `http://127.0.0.1:5000`

## 👤 Usuario por Defecto

- **Email**: `admin@example.com`
- **Password**: `Perfect@password1` 
- **IMPORTANTE**: Cambiar la contraseña después del primer login y actualizar el hash de tu nuevo password

## 📂 Estructura del Proyecto

```
helpdesk_app/
├── app.py              # Aplicación principal
├── config.py           # Configuración
├── db_init.sql         # Script de base de datos
├── .env                # Variables de entorno (NO versionar)
├── static/             # CSS y archivos estáticos
│   └── css/
├── templates/          # Plantillas HTML
└── docs/               # Documentación
    ├── manual_usuario.md
    ├── manual_tecnico.md
    └── er_diagram.png
```

## 🔐 Roles del Sistema

| Rol       | Permisos 
|-----------|---------------------------------------------------
| **USER**  | Crear, ver y editar sus propios tickets
| **AGENT** | Ver todos los tickets, actualizar estado o asignar a otro agent
| **ADMIN** | Control total sobre la gestión de usuarios y tickets

## 📖 Documentación

Para más detalles, consulta:
- [Manual de Usuario](docs/manual_usuario.md)
- [Manual Técnico](docs/manual_tecnico.md)

## Si deseas Contribuir

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request
