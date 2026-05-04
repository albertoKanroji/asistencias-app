class ScannerConstants {
  static const readyMessage = 'Escáner listo para registrar asistencia.';
  static const scannerServiceError = 'No se pudo obtener al empleado por CURP';
  static const registerServiceError = 'No se pudo registrar la entrada múltiple';

  static const noResultsTitle = 'Sin resultados';
  static const noEmployeeByCurp = 'No se encontró empleado con ese CURP.';
  static const errorTitle = 'Error';
  static const duplicateTitle = 'Duplicado';
  static const duplicateEmployee = 'Esta persona ya está en la lista.';
  static const personAddedTitle = 'Persona agregada';

  static const requiredFieldTitle = 'Campo requerido';
  static const requiredExitReason = 'Debes capturar la razón de salida.';
  static const savedTitle = 'Registro guardado';
  static const savedMessage = 'Asistencia registrada correctamente.';

  static const lastQrPrefix = 'Último QR:';
  static const noQrValue = '-';
  static const openScannerButton = 'Abrir escáner';
  static const confirmDepartureButton = 'Confirmar salida';
  static const confirmEntryButton = 'Confirmar entrada';
  static const scannedPeoplePrefix = 'Personas escaneadas';

  static const employeeTitle = 'Empleado';
  static const driverLabel = 'Chofer';
  static const badgeExit = 'Salida';
  static const badgeReturn = 'Regreso';
  static const selectDriverHint =
      'Puedes marcar una sola persona como chofer (opcional para salida).';
  static const deleteTooltip = 'Eliminar';

  static const exitReasonTitle = 'Mensaje de salida';
  static const exitReasonHint = 'Escribe el mensaje...';
  static const exitReasonSelectLabel = 'Motivo';
  static const exitReasonOtherOption = 'Otro';
  static const exitReasonChooseOption = 'Selecciona un motivo';
  static const exitReasonOptions = <String>[
    'Carga de gasolina',
    'CFE',
    'BC 25 - Puente rio',
    'BC 24 - TT24 - SB 03',
    'BC 23 - TT23 - SB 02',
    'SB10',
    'Lazaro Cardenas - Paqueteria',
    'Aduana - Asipona',
    'Llenado de pipa, garza de agua',
    exitReasonOtherOption,
  ];
  static const confirmButton = 'Guardar';

  static const noLabel = 'No';
  static const yesLabel = 'Sí';

  static const removeCompanionTitle = 'Eliminar persona';
  static const removeCompanionMessage =
      '¿Seguro que deseas eliminar a esta persona de la lista?';

  static const scannerSheetTitle = 'Escáner QR';
  static const closeButton = 'Cerrar';
  static const unknownInitial = '?';

  static const cameraStartDelayMs = 120;
  static const cameraSheetHeightFactor = 0.75;
}
