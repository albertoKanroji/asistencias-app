# Registro Asistencia

Aplicacion oficial de Terminales Portuarias del Pacifico para registro y monitoreo de movimientos de personal.

## Stack

- Flutter (Dart)
- GetX (routing, bindings, state)
- Dio (cliente HTTP + interceptor de auth)
- Shared Preferences (sesion local)
- mobile_scanner (lectura QR)

## Funcionalidades Principales

- Login con backend y manejo de sesion.
- Home con tabs:
	- Escaner
	- Monitoreo
	- Contratistas
	- Ajustes
- Escaner:
	- Escaneo continuo de QR (sin cerrar modal por cada lectura).
	- Lista de personas escaneadas.
	- Badge por persona:
		- `Salida` (verde)
		- `Regreso` (rojo)
	- Si todos son `Regreso`, confirma entrada sin pedir motivo.
	- Confirmacion final con envio al backend.
- Monitoreo:
	- Tabs: `Pendientes`, `Salidas`, `Entradas`.
	- Filtros, limpiar filtros, paginacion/infinite scroll.
	- Boton flotante de recarga por tab.

## Estructura

La app esta organizada por modulos en `lib/app/modules/`.

- `auth`
- `home`
- `scanner`
- `monitoring`
- `contractors`
- `settings`
- `startup`

Nucleo comun en `lib/app/core/`:

- `network/` (client, interceptor, endpoints)
- `services/`
- `bindings/`
- `config/`

## Entornos (API)

Configurado en `lib/app/core/config/api_config.dart` con `APP_ENV`:

- `local` -> `http://localhost:7253/`
- `prod` -> `https://cm-backend.tpp.com.mx`

Ejemplos:

```bash
flutter run --dart-define=APP_ENV=local
flutter run --dart-define=APP_ENV=prod
```

## Ejecutar Proyecto

```bash
flutter pub get
flutter run --dart-define=APP_ENV=prod
```

## Build APK

Produccion:

```bash
flutter build apk --release --dart-define=APP_ENV=prod
```

Local:

```bash
flutter build apk --release --dart-define=APP_ENV=local
```

Salida del APK:

`build/app/outputs/flutter-apk/app-release.apk`

## Comandos Utiles

```bash
flutter analyze
flutter test
```

## Notas

- El beep de escaneo en Android usa implementacion nativa para mejor compatibilidad en dispositivos Zebra TC15, con fallback a `SystemSound`.
- El envio final del scanner espera respuesta del backend antes de mostrar exito.
