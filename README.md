# Cor Falles

**Cor Falles** es una aplicación multiplataforma desarrollada con **Flutter** orientada a la **consulta, organización y difusión de eventos relacionados con las Fallas de Valencia**.

El proyecto nace como respuesta a la dispersión de la información fallera entre distintas páginas web, redes sociales y medios, proponiendo una **agenda digital centralizada**, visual y accesible tanto en **web** como en **móvil**.

La versión actual corresponde a un **MVP funcional**, centrado en validar la navegación principal, la autenticación de usuarios, la persistencia local, la consulta de eventos y la gestión básica de contenido.

---

## Características principales

- Autenticación de usuarios con inicio de sesión y registro.
- Persistencia local de sesión, usuarios y eventos.
- Consulta de eventos desde distintas vistas:
  - inicio
  - calendario
  - mapa interactivo
  - detalle de evento
- Mapa interactivo con geolocalización de eventos.
- Creación, edición y eliminación lógica de eventos para usuarios autorizados.
- Interfaz responsive adaptada a escritorio y móvil.

---

## Tecnologías utilizadas

- **Flutter** como framework principal multiplataforma.
- **Dart** como lenguaje de desarrollo.
- **shared_preferences** para persistencia local de datos.
- **flutter_map** + **OpenStreetMap** para la integración cartográfica.
- **table_calendar** para la visualización de eventos por fecha.
- **file_picker** para la selección de imágenes personalizadas.

---

## Estructura del proyecto

La carpeta `lib/` sigue una organización modular por responsabilidades:

```text
lib/
├── models/      # Modelos de datos principales
├── pages/       # Pantallas de la aplicación
├── provider/    # Gestión de estado, autenticación y eventos
├── routes/      # Navegación interna
├── utils/       # Utilidades visuales y de apoyo
└── widgets/     # Componentes reutilizables
```

Además, la carpeta `assets/` contiene los recursos gráficos e imágenes de eventos utilizados por la aplicación.

---

## Usuarios de prueba

La aplicación incluye usuarios precargados para facilitar las pruebas:

### Usuario administrador / organizador
- **Email:** `admin@corfalles.app`
- **Usuario:** `admin`
- **Contraseña:** `admin`

### Usuario demo
- **Email:** `demo@corfalles.app`
- **Usuario:** `demo`
- **Contraseña:** `123456`

El usuario con rol de organizador puede crear, editar y eliminar eventos, mientras que el usuario demo está pensado para navegación y consulta general.

---

## Requisitos previos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK
- Visual Studio Code o Android Studio
- Un dispositivo Android, emulador o navegador compatible con Flutter Web

---

## Instalación y ejecución

### 1. Clonar o copiar el proyecto
Sitúate en la carpeta raíz del proyecto.

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Ejecutar la aplicación

#### En navegador
```bash
flutter run -d chrome
```

#### En dispositivo o emulador Android
```bash
flutter run
```

---

## Flujo principal de uso

Una vez iniciada la aplicación, el flujo general del sistema es el siguiente:

1. Acceso desde la pantalla de bienvenida.
2. Inicio de sesión o registro de usuario.
3. Navegación principal entre:
   - Inicio
   - Eventos
   - Mapa
   - Ajustes
4. Consulta de eventos mediante calendario, búsqueda o mapa.
5. Acceso al detalle de cada evento.
6. Gestión de eventos por parte de usuarios autorizados.

---

## Estado actual del proyecto

La versión actual de **Cor Falles** corresponde a un **MVP funcional**, centrado en validar la propuesta principal del sistema:

- autenticación de usuarios
- persistencia local
- gestión de eventos
- integración cartográfica
- adaptación responsive

Aunque inicialmente se contempló una arquitectura más completa con backend y base de datos relacional, la demo final se orientó a una solución más ligera y fácil de desplegar para pruebas académicas y demostración funcional.

---

## Posibles mejoras futuras

Entre las ampliaciones planteadas para futuras versiones se encuentran:

- backend remoto y base de datos centralizada
- sincronización entre instalaciones
- sistema de notificaciones
- comentarios y valoraciones
- despliegue público de la versión web
- administración más avanzada de contenido

---

## Autor

**Drakes Alejandro Carvajal Aparicio**  
Proyecto Intermodular de **Desarrollo de Aplicaciones Multiplataforma (DAM)**  
IES Serra Perenxisa

---

## Licencia

Este proyecto ha sido desarrollado con fines académicos.
