class SettingsConstants {
  static const availableMessage = 'Ajustes disponibles para configuración.';
  static const kioskSectionTitle = 'Modo kiosco';
  static const kioskExitButton = 'Salir de la app (PIN)';
  static const kioskPinTitle = 'Ingresa PIN de salida';
  static const kioskPinHint = 'PIN';
  static const kioskPinInvalid = 'PIN incorrecto';
  static const kioskExitSuccess = 'Modo kiosco desactivado';
  static const kioskExitFailed = 'No se pudo desactivar el modo kiosco';
  static const kioskNotPermittedMessage =
      'Kiosco limitado: configura el dispositivo como Device Owner para bloquear Home y Recientes.';

  static const kioskExitPin =
      String.fromEnvironment('KIOSK_EXIT_PIN', defaultValue: '2305');

  static const usernameLabel = 'Usuario';
  static const emailLabel = 'Correo';
  static const areaLabel = 'Área';
  static const positionLabel = 'Puesto';
  static const logoutButton = 'Cerrar sesión';
  static const emptyValue = '-';
}
