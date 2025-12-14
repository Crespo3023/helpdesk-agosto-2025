# Manual de Usuario - Sistema HelpDesk

## Tabla de Contenidos
1. [Introducción](#introducción)
2. [Cómo Iniciar Sesión](#cómo-iniciar-sesión)
3. [Cómo Crear un Ticket](#cómo-crear-un-ticket)
4. [Cómo Ver y Actualizar Tickets](#cómo-ver-y-actualizar-tickets)
5. [Funcionalidades por Rol](#funcionalidades-por-rol)

---

## Introducción

El Sistema HelpDesk es una aplicación web diseñada para gestionar tickets de soporte técnico. Permite a los usuarios reportar problemas (tickets con comentarios), a los agentes dar seguimiento y a los administradores supervisar todo el proceso y los usuarios registrados.

---

## Cómo Iniciar Sesión

1. Accede a la página principal del sistema en tu navegador web (por defecto: `http://127.0.0.1:5000`)
2. Serás redirigido automáticamente a la página de inicio de sesión (Login)
3. Ingresa tus credenciales:
   - **Email**: Tu correo electrónico registrado (Ya existen unos correos predeterminados)
   - **Contraseña**: Tu contraseña
4. Haz clic en el botón **"Login"**
5. Si las credenciales son correctas, serás redirigido al dashboard principal


## Cómo Crear un Ticket

### Para todos los usuarios (USER, AGENT, ADMIN):

1. Desde el dashboard principal, haz clic en el botón **"Tickets"** y te dirigira a la pagina donde daras click a **"New ticket** navega a la sección o formulario de crear ticket.

2. Completa el formulario con la siguiente información:
   - **Título**: Un resumen breve del problema (máximo 200 caracteres)
   - **Descripción**: Detalla el problema con toda la información relevante.
   - **Prioridad**: Selecciona el nivel de urgencia:
     - **LOW** (Baja): Problemas menores que no afectan operaciones críticas.
     - **MEDIUM** (Media): Problemas que requieren atención pero no son urgentes.
     - **HIGH** (Alta): Problemas críticos que requieren atención inmediata.
3. Haz clic en **"Create"**
4. El ticket será creado con estado **"OPEN"** y podrás verlo en tu lista de tickets.

## Cómo Ver y Actualizar Tickets

### Ver Tickets

1. Desde el dashboard, accede a la sección **"Tickets"**
2. Verás una lista de tickets según tu rol:
   - **USER**: Solo tus propios tickets
   - **AGENT**: Todos los tickets del sistema
   - **ADMIN**: Todos los tickets del sistema

### Ver Detalles de un Ticket

1. En la lista de tickets, haz clic en el boton de **Edit** del ticket que deseas ver
2. Se mostrará la información completa:
   - Título y descripción
   - Estado actual (OPEN, IN_PROGRESS, RESOLVED)
   - Prioridad (LOW, MEDIUM, HIGH)
   - Creador del ticket
   - Agente asignado (si aplica)
   - Fecha de creación y última actualización
   - Comentarios asociados
   - Añadir un comentario

### Actualizar un Ticket (AGENT y ADMIN)

1. Abre el ticket que deseas actualizar en el boton de **Edit**
2. Modifica los siguientes campos según sea necesario:
   - **Estado**: Cambia entre OPEN, IN_PROGRESS, RESOLVED
   - **Asignación**: Asigna el ticket a un agente disponible
3. Haz clic en **"Update Ticket"**

### Agregar Comentarios

1. En la vista de detalles del ticket, localiza la sección de comentarios
2. Escribe tu comentario en el campo de texto
3. Haz clic en **"Add Comment"**
4. El comentario se guardará con tu nombre de usuario y la fecha/hora actual

## Funcionalidades por Rol

### Usuario (USER)

**Permisos**:
- ✅ Crear nuevos tickets.
- ✅ Editar sus propios tickets.
- ✅ Ver únicamente sus propios tickets.
- ✅ Agregar comentarios a sus tickets.
- ❌ No puede ver tickets de otros usuarios.
- ❌ No puede acceder a la lista de usuarios.
- ❌ No puede actualizar el estado o prioridad de otros tickets que no sean propios del usuario.

**Vista del Dashboard**:
- Botón de que te dirije Lista de tickets creados por el usuario.
- Opcion de ver los usuarios registrados (Solo con permisos de Admin).
- Opción de cerrar sesión

---

### Agente (AGENT)

**Permisos**:
- ✅ Ver todos los tickets del sistema
- ✅ Crear nuevos tickets
- ✅ Actualizar estado de tickets (OPEN → IN_PROGRESS → RESOLVED)
- ✅ Cambiar prioridad de tickets
- ✅ Agregar comentarios a cualquier ticket
- ✅ Asignarse tickets o asignarlos a otros agentes
- ❌ No puede acceder a la lista de usuarios
- ❌ No puede cambiar roles de usuarios

**Vista del Dashboard**:
- Lista completa de todos los tickets
- Filtros por estado y prioridad
- Botón para crear nuevo ticket
- Acceso a actualizar tickets
- Opción de cerrar sesión

---

### Administrador (ADMIN)

**Permisos**:
- ✅ Ver todos los tickets del sistema
- ✅ Crear nuevos tickets
- ✅ Actualizar cualquier ticket (estado, prioridad, asignación)
- ✅ Agregar comentarios a cualquier ticket
- ✅ Asignar tickets a agentes
- ✅ **Acceder a la lista de usuarios**
- ✅ **Cambiar roles de usuarios** (USER / AGENT / ADMIN)
- ✅ **Crear nuevos usuarios**
- ✅ Supervisión completa del sistema

**Vista del Dashboard**:
- Lista completa de todos los tickets
- Filtrado por Title, priority, and status.
- Botón para crear nuevo ticket
- **Sección "Users"** para gestión de usuarios
- Opción de cerrar sesión (logout)

**Gestión de Usuarios** (exclusivo ADMIN):
1. Accede a la sección **"Users"** desde el menú principal (dashboard)
2. Verás la lista completa de usuarios registrados con:
   - Nombre
   - Email
   - Rol actual
   - Fecha de creación
3. Para cambiar el rol de un usuario:
   - Haz clic en el botón de **Editar** junto al usuario
   - Selecciona el nuevo rol (USER, AGENT, ADMIN)
   - Confirma el cambio


## Estados de Tickets

| Estado          | Descripción                                   
|-----------------|-----------------------------------------------
| **OPEN**        | Ticket recién creado, pendiente de atención   
| **IN_PROGRESS** | Ticket en proceso de resolución por un agente 
| **RESOLVED**    | Ticket resuelto, el problema  ha sido solucionado.

## Niveles de Prioridad

| Prioridad  | Descripción | Uso Recomendado 
|------------|-------------|-----------------
| **LOW**    | Baja        | Consultas generales, problemas menores 
| **MEDIUM** | Media       | Problemas que afectan productividad pero tienen workarounds 
| **HIGH**   | Alta        | Problemas críticos que bloquean operaciones 


## Consejos y Mejores Prácticas

1. **Al crear tickets**:
   - Usa títulos descriptivos y concisos
   - Incluye toda la información relevante en la descripción
   - Selecciona la prioridad apropiada

2. **Para agentes**:
   - Actualiza el estado de los tickets según avances
   - Deja comentarios explicando las acciones tomadas
   - Asigna tickets de manera equitativa
   - Atiende segun el estado de prioridad

3. **Para administradores**:
   - Revisa la carga de trabajo administrada a cada agente.
   - Asegúrate de que los tickets HIGH priority reciban atención inmediata.
   - Mantén la lista de usuarios actualizada.



## Cerrar Sesión

1. Haz clic en el botón **"Logout"** en la esquina superior derecha.
2. Serás redirigido a la página de inicio de sesión.
3. Tu sesión se cerrará de forma segura y aparecera un mensaje flash confirmando el logout.



