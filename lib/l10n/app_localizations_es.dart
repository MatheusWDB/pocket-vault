// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get authFailed => 'Autenticación fallida';

  @override
  String get authCancelled => 'Autenticación cancelada por el usuario';

  @override
  String get biometryUnavailable =>
      'Biometría no disponible en este dispositivo';

  @override
  String get operationCancelled => 'Operación cancelada por el usuario';

  @override
  String get errorBackupGenerate => 'Error al generar el archivo de respaldo';

  @override
  String get errorBackupSave =>
      'Error al guardar el respaldo en el dispositivo';

  @override
  String get errorBackupShare => 'Error al compartir el respaldo';

  @override
  String get errorBackupImport => 'Error al importar el archivo de respaldo';

  @override
  String get errorBackupRestore => 'Error al restaurar el respaldo';

  @override
  String get categoryNotFound => 'Categoría no encontrada';

  @override
  String get errorCategorySave => 'Error al guardar la categoría';

  @override
  String get errorDeleteCategoryLinked =>
      'No es posible eliminar una categoría con transacciones vinculadas';

  @override
  String get notFound => 'no encontrado';

  @override
  String get errorInsert => 'Error al insertar';

  @override
  String get errorUpdate => 'Error al actualizar';

  @override
  String get errorDelete => 'Error al eliminar';

  @override
  String get errorFetch => 'Error al buscar';

  @override
  String get tagNotFound => 'Etiqueta no encontrada';

  @override
  String get errorTagSave => 'Error al guardar la etiqueta';

  @override
  String get errorTagDelete => 'Error al eliminar la etiqueta';

  @override
  String get transactionNotFound => 'Transacción no encontrada';

  @override
  String get errorTransactionSave => 'Error al guardar la transacción';

  @override
  String get errorTransactionDelete => 'Error al eliminar la transacción';

  @override
  String get langPtBr => 'Portugués (Brasil)';

  @override
  String get langEnUs => 'Inglés (EE. UU.)';

  @override
  String get currEuro => 'Euro (Europa)';

  @override
  String get currPound => 'Libra (UK)';

  @override
  String get currYen => 'Yen (Japón)';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get category => 'Categoría';

  @override
  String get tag => 'Etiqueta';

  @override
  String get pocketVault => 'PocketVault';

  @override
  String get transaction => 'Transacción';

  @override
  String get linkTransactionTag => 'Vínculo transacción-etiqueta';

  @override
  String get onboardingSubtitle => 'Su soberanía financiera comienza aquí.';

  @override
  String get invalidBackupNoCategories => 'Respaldo inválido: sin categorías';

  @override
  String get invalidBackupNoTransactions =>
      'Respaldo inválido: sin transacciones';

  @override
  String get dbDeletedSuccess => '¡Base de datos eliminada con éxito!';

  @override
  String get appTitle => 'Soberanía Financiera';

  @override
  String get unlockApp => 'Desbloquear aplicación';

  @override
  String get all => 'Todos';

  @override
  String get selectPeriod => 'Seleccionar Período';

  @override
  String get clearFilter => 'Limpiar Filtro';

  @override
  String get confirm => 'Confirmar';

  @override
  String get summary => 'Resumen';

  @override
  String get transactions => 'Transacciones';

  @override
  String get budgets => 'Presupuestos';

  @override
  String get report => 'Informe';

  @override
  String get confirmImport => 'Confirmar importación';

  @override
  String get importWarning =>
      'Esto reemplazará todos los datos actuales con el respaldo seleccionado. Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get backupSaveSuccess => 'Respaldo guardado con éxito';

  @override
  String get backupShareSuccess => 'Respaldo compartido con éxito';

  @override
  String get backupImportSuccess => 'Respaldo importado con éxito';

  @override
  String get download => 'Descargar';

  @override
  String get share => 'Compartir';

  @override
  String get chooseFile => 'Elegir archivo';

  @override
  String get searchFolder => 'Buscar carpeta';

  @override
  String get settings => 'Ajustes';

  @override
  String get theme => 'Tema';

  @override
  String get currency => 'Moneda';

  @override
  String get biometry => 'Biometría';

  @override
  String get dataSecurity => 'Seguridad de Datos';

  @override
  String get storageInfo =>
      '\"PocketVault\" guarda todo localmente. Use las opciones a continuación para no perder sus datos.';

  @override
  String get downloadBackup => 'Descargar respaldo';

  @override
  String get exportData => 'Exportar sus datos';

  @override
  String get loadBackup => 'Cargar respaldo';

  @override
  String get replaceCurrentData => 'Reemplazar datos actuales';

  @override
  String get noBackupPerformed => 'Ningún respaldo realizado';

  @override
  String lastBackup(Object date) {
    return 'Último respaldo: $date';
  }

  @override
  String get clearDatabase => 'Limpiar Base de Datos';

  @override
  String get eraseAllData => 'Esto borrará todos los datos';

  @override
  String get resetDatabaseQuestion => '¿Restablecer Base de Datos?';

  @override
  String get resetWarning =>
      'Esto borrará TODAS las transacciones y categorías.';

  @override
  String get dbResetSuccess =>
      '¡Base de datos restablecida! Reinicie la aplicación si es necesario.';

  @override
  String get dbResetError => 'Error al restablecer la base de datos';

  @override
  String get valueGreaterThanZero => 'El valor debe ser mayor que cero';

  @override
  String get insertTitle => 'Ingrese un título';

  @override
  String get chooseColor => 'Elegir color';

  @override
  String get reset => 'Restablecer';

  @override
  String get defineCategory => 'Defina una categoría';

  @override
  String get onlyNumbers => 'Solo números';

  @override
  String get editTransaction => 'Editar Transacción';

  @override
  String get newTransaction => 'Nueva Transacción';

  @override
  String get value => 'Valor';

  @override
  String get expense => 'Gasto';

  @override
  String get income => 'Ingreso';

  @override
  String get title => 'Título';

  @override
  String get examplePurchase => 'Ej: Compras 01/01/2026';

  @override
  String get transactionDate => 'Fecha de Transacción';

  @override
  String get description => 'Descripción';

  @override
  String get exampleDescription => 'Ej: Compras del mes pagadas con tarjeta';

  @override
  String get noCategoryFound => 'Ninguna categoría encontrada';

  @override
  String get exampleMarket => 'Ej: Mercado';

  @override
  String get categoryColor => 'Color de Categoría';

  @override
  String get installments => 'Cuotas';

  @override
  String get exampleInstallments => 'Ej: 12';

  @override
  String get tags => 'Etiquetas';

  @override
  String get add => 'Añadir';

  @override
  String tagPlaceholder(Object number) {
    return 'Etiqueta $number...';
  }

  @override
  String get recurrentTransaction => 'Transacción Recurrente';

  @override
  String get details => 'Detalles';

  @override
  String get date => 'Fecha';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get selectCategory => 'Seleccione una categoría';

  @override
  String get defineLimit => 'Definir Límite';

  @override
  String get save => 'Guardar';

  @override
  String get budgetProgress => 'Progreso del presupuesto';

  @override
  String budgetWarning(Object percentage) {
    return 'Atención: $percentage% del límite alcanzado.';
  }

  @override
  String budgetExceeded(Object percentage) {
    return 'Atención: Límite excedido en $percentage%.';
  }

  @override
  String spentOfLimit(Object spentText, Object limitText) {
    return '$spentText de $limitText';
  }

  @override
  String get allCategoriesHaveLimit => 'Todas las categorías ya tienen límite';

  @override
  String get newLimit => 'Nuevo Límite';

  @override
  String get totalBalance => 'Saldo Total';

  @override
  String get entries => 'Entradas';

  @override
  String get outputs => 'Salidas';

  @override
  String get history => 'Historial';

  @override
  String get noTransactionsInPeriod => 'Ninguna transacción en el período';

  @override
  String get totalSpent => 'TOTAL GASTADO';

  @override
  String get generatePdf => 'Generar PDF';

  @override
  String get filterByNameOrTag => 'Filtrar por nombre o etiqueta...';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get visualBudgetAnalysis => 'Análisis Visual de Presupuestos';

  @override
  String get transactionHistory => 'Historial de Transacciones';

  @override
  String get personalFinancialSovereignty => 'Soberanía Financiera Personal';

  @override
  String get monthlyReport => 'INFORME MENSUAL';

  @override
  String get offlineDataProcessing => 'Datos procesados 100% fuera de línea';

  @override
  String pdfFooter(Object pageNumber, Object pagesCount, Object date) {
    return 'Página $pageNumber de $pagesCount  •  PocketVault  •  $date';
  }

  @override
  String get monthlyBalance => 'SALDO DEL MES';

  @override
  String get budgetAlerts => 'Alertas de Presupuesto';

  @override
  String limitExceededBy(Object pct) {
    return 'Límite excedido en $pct';
  }

  @override
  String get limitReached => 'Límite alcanzado';

  @override
  String limitPercentageReached(Object pct) {
    return '$pct del límite alcanzado';
  }

  @override
  String spentOverLimit(Object spent, Object limit) {
    return '$spent / $limit';
  }

  @override
  String get budgetControl => 'Control de Presupuestos';

  @override
  String get noBudgetsConfigured => 'Ningún presupuesto configurado.';

  @override
  String get detailedStatement => 'Estado de Cuenta Detallado';

  @override
  String transactionValue(Object sign, Object value) {
    return '$sign $value';
  }

  @override
  String get editScopeQuestion =>
      '¿Editar solo esta transacción o esta y todas las futuras?';

  @override
  String get editScopeOnlyThis => 'Solo esta';

  @override
  String get editScopeThisAndFuture => 'Esta y las futuras';

  @override
  String installmentLabel(Object current, Object total) {
    return 'Cuota: $current/$total';
  }

  @override
  String get defineColor => 'Definir Color';

  @override
  String deleteConfirmation(Object title) {
    return '¿Eliminar \"$title\"?';
  }
}
