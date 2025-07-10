# To-Do List App

Esta es una aplicación de lista de tareas (To-Do List) desarrollada con Flutter y Supabase. Permite a los usuarios registrarse, iniciar sesión y gestionar sus tareas diarias de una manera sencilla y eficiente.

## Características

- **Autenticación de Usuarios:** Sistema completo de registro e inicio de sesión.
- **Gestión de Tareas:** Los usuarios pueden crear, ver, editar y eliminar sus tareas.
- **Interfaz de Usuario Intuitiva:** Un diseño limpio y fácil de usar para una experiencia de usuario fluida.
- **Persistencia de Datos:** Las tareas se guardan en una base de datos de Supabase, lo que permite el acceso desde cualquier dispositivo.

## Tecnologías Utilizadas

- **Framework:** Flutter
- **Backend como Servicio (BaaS):** Supabase
- **Gestión de Estado:** GetX

## Estructura del Proyecto

El proyecto sigue una estructura organizada para separar las responsabilidades y facilitar el mantenimiento:

```plaintext
lib/
├── Login.dart                 # Pantalla de inicio de sesión
├── components/                # Widgets reutilizables
│   └── drawable.dart
├── constants.dart             # Constantes de la aplicación
├── controller/                # Lógica de negocio y gestión de estado
│   ├── auth_service.dart      # Servicio de autenticación (login/registro)
│   ├── task_controller.dart   # Controlador para la gestión de tareas
│   └── user_controller.dart   # Controlador para la gestión de datos del usuario
├── formulario_editar_tareas.dart # Formulario para editar tareas existentes
├── formulario_registro.dart   # Pantalla de registro de nuevos usuarios
├── formulario_tareas.dart     # Formulario para crear nuevas tareas
├── index.dart                 # Pantalla principal después del login (posiblemente la lista de tareas)
├── lista_tareas.dart          # Widget que muestra la lista de tareas
└── main.dart                  # Punto de entrada de la aplicación y configuración de rutas
```


## Base de Datos

Este proyecto utiliza la tabla nativa de usuarios proporcionada por Supabase (`auth.users`) para la gestión de usuarios.

No es necesario verificar el correo electrónico para que los usuarios puedan iniciar sesión inmediatamente después del registro.

La base de datos incluye una tabla `tareas` con el siguiente esquema:

- `id` (int8): Clave primaria, autoincremental.
- `estatus` (boolean): Estado de la tarea.
- `titulo` (text): Título de la tarea.
- `contenido` (text): Contenido o descripción de la tarea.
- `created_at` (timestamptz): Marca de tiempo de creación, por defecto la hora actual.
- `fk_user` (uuid): Clave foránea que referencia a `auth.users(id)`, con eliminación en cascada.

Se incluye un archivo `supabase_schema.sql` con la definición de las tablas necesarias para la aplicación, que puede ser importado directamente en Supabase.

Para importar el esquema:

1. Accede a tu proyecto en Supabase.
2. Ve a la sección SQL Editor.
3. Carga y ejecuta el archivo `supabase_schema.sql`.

Esto creará las tablas necesarias para que la aplicación funcione correctamente.

```
lib/
├── Login.dart                 # Pantalla de inicio de sesión
├── components/                # Widgets reutilizables
│   └── drawable.dart
├── constants.dart             # Constantes de la aplicación
├── controller/                # Lógica de negocio y gestión de estado
│   ├── auth_service.dart      # Servicio de autenticación (login/registro)
│   ├── task_controller.dart   # Controlador para la gestión de tareas
│   └── user_controller.dart   # Controlador para la gestión de datos del usuario
├── formulario_editar_tareas.dart # Formulario para editar tareas existentes
├── formulario_registro.dart   # Pantalla de registro de nuevos usuarios
├── formulario_tareas.dart     # Formulario para crear nuevas tareas
├── index.dart                 # Pantalla principal después del login (posiblemente la lista de tareas)
├── lista_tareas.dart          # Widget que muestra la lista de tareas
└── main.dart                  # Punto de entrada de la aplicación y configuración de rutas
```

## Configuración y Puesta en Marcha

1. **Clonar el repositorio:**
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   ```

2. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

3. **Configurar Supabase:**
   - Crea un proyecto en [Supabase](https://supabase.com/).
   - Ve a la configuración del proyecto y obtén tu `URL` y tu `anon key`.
   - Reemplaza estos valores en el archivo `main.dart` donde se inicializa Supabase.

4. **Ejecutar la aplicación:**
   ```bash
   flutter run
   ```