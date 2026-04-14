// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authFailed => 'Authentication failed';

  @override
  String get authCancelled => 'Authentication cancelled by user';

  @override
  String get biometryUnavailable => 'Biometrics unavailable on this device';

  @override
  String get operationCancelled => 'Operation cancelled by user';

  @override
  String get errorBackupGenerate => 'Error generating backup file';

  @override
  String get errorBackupSave => 'Error saving backup to device';

  @override
  String get errorBackupShare => 'Error sharing backup';

  @override
  String get errorBackupImport => 'Error importing backup file';

  @override
  String get errorBackupRestore => 'Error restoring backup';

  @override
  String get categoryNotFound => 'Category not found';

  @override
  String get errorCategorySave => 'Error saving category';

  @override
  String get errorDeleteCategoryLinked =>
      'Cannot delete a category with linked transactions';

  @override
  String get notFound => 'not found';

  @override
  String get errorInsert => 'Error inserting';

  @override
  String get errorUpdate => 'Error updating';

  @override
  String get errorDelete => 'Error deleting';

  @override
  String get errorFetch => 'Error fetching';

  @override
  String get tagNotFound => 'Tag not found';

  @override
  String get errorTagSave => 'Error saving tag';

  @override
  String get errorTagDelete => 'Error deleting tag';

  @override
  String get transactionNotFound => 'Transaction not found';

  @override
  String get errorTransactionSave => 'Error saving transaction';

  @override
  String get errorTransactionDelete => 'Error deleting transaction';

  @override
  String get langPtBr => 'Portuguese (Brazil)';

  @override
  String get langEnUs => 'English (USA)';

  @override
  String get currEuro => 'Euro (Europe)';

  @override
  String get currPound => 'Pound (UK)';

  @override
  String get currYen => 'Yen (Japan)';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get category => 'Category';

  @override
  String get tag => 'Tag';

  @override
  String get pocketVault => 'PocketVault';

  @override
  String get transaction => 'Transaction';

  @override
  String get linkTransactionTag => 'Transaction-tag link';

  @override
  String get onboardingSubtitle => 'Your financial sovereignty starts here.';

  @override
  String get invalidBackupNoCategories => 'Invalid backup: no categories';

  @override
  String get invalidBackupNoTransactions => 'Invalid backup: no transactions';

  @override
  String get dbDeletedSuccess => 'Database deleted successfully!';

  @override
  String get appTitle => 'Financial Sovereignty';

  @override
  String get unlockApp => 'Unlock application';

  @override
  String get all => 'All';

  @override
  String get selectPeriod => 'Select Period';

  @override
  String get clearFilter => 'Clear Filter';

  @override
  String get confirm => 'Confirm';

  @override
  String get summary => 'Summary';

  @override
  String get transactions => 'Transactions';

  @override
  String get budgets => 'Budgets';

  @override
  String get report => 'Report';

  @override
  String get confirmImport => 'Confirm import';

  @override
  String get importWarning =>
      'This will replace all current data with the selected backup. This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get backupSaveSuccess => 'Backup saved successfully';

  @override
  String get backupShareSuccess => 'Backup shared successfully';

  @override
  String get backupImportSuccess => 'Backup imported successfully';

  @override
  String get download => 'Download';

  @override
  String get share => 'Share';

  @override
  String get chooseFile => 'Choose file';

  @override
  String get searchFolder => 'Search folder';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get currency => 'Currency';

  @override
  String get biometry => 'Biometrics';

  @override
  String get dataSecurity => 'Data Security';

  @override
  String get storageInfo =>
      '\"PocketVault\" stores everything locally. Use the options below to avoid losing your data.';

  @override
  String get downloadBackup => 'Download backup';

  @override
  String get exportData => 'Export your data';

  @override
  String get loadBackup => 'Load backup';

  @override
  String get replaceCurrentData => 'Replace current data';

  @override
  String get noBackupPerformed => 'No backup performed';

  @override
  String lastBackup(Object date) {
    return 'Last backup: $date';
  }

  @override
  String get clearDatabase => 'Clear Database';

  @override
  String get eraseAllData => 'This will erase all data';

  @override
  String get resetDatabaseQuestion => 'Reset Database?';

  @override
  String get resetWarning => 'This will erase ALL transactions and categories.';

  @override
  String get dbResetSuccess => 'Database reset! Restart the app if necessary.';

  @override
  String get dbResetError => 'Error resetting the database';

  @override
  String get valueGreaterThanZero => 'Value must be greater than zero';

  @override
  String get insertTitle => 'Enter a title';

  @override
  String get chooseColor => 'Choose color';

  @override
  String get reset => 'Reset';

  @override
  String get defineCategory => 'Define a category';

  @override
  String get onlyNumbers => 'Numbers only';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get value => 'Value';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get title => 'Title';

  @override
  String get examplePurchase => 'Ex: Shopping 01/01/2026';

  @override
  String get transactionDate => 'Transaction Date';

  @override
  String get description => 'Description';

  @override
  String get exampleDescription => 'Ex: Monthly groceries paid by card';

  @override
  String get noCategoryFound => 'No category found';

  @override
  String get exampleMarket => 'Ex: Market';

  @override
  String get categoryColor => 'Category Color';

  @override
  String get installments => 'Installments';

  @override
  String get exampleInstallments => 'Ex: 12';

  @override
  String get tags => 'Tags';

  @override
  String get add => 'Add';

  @override
  String tagPlaceholder(Object number) {
    return 'Tag $number...';
  }

  @override
  String get recurrentTransaction => 'Recurrent Transaction';

  @override
  String get details => 'Details';

  @override
  String get date => 'Date';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get selectCategory => 'Select a category';

  @override
  String get defineLimit => 'Set Limit';

  @override
  String get save => 'Save';

  @override
  String get budgetProgress => 'Budget progress';

  @override
  String budgetWarning(Object percentage) {
    return 'Warning: $percentage% of the limit reached.';
  }

  @override
  String budgetExceeded(Object percentage) {
    return 'Warning: Limit exceeded by $percentage%.';
  }

  @override
  String spentOfLimit(Object spentText, Object limitText) {
    return '$spentText of $limitText';
  }

  @override
  String get allCategoriesHaveLimit => 'All categories already have a limit';

  @override
  String get newLimit => 'New Limit';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get entries => 'Incomes';

  @override
  String get outputs => 'Expenses';

  @override
  String get history => 'History';

  @override
  String get noTransactionsInPeriod => 'No transactions in the period';

  @override
  String get totalSpent => 'TOTAL SPENT';

  @override
  String get generatePdf => 'Generate PDF';

  @override
  String get filterByNameOrTag => 'Filter by name or tag...';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get visualBudgetAnalysis => 'Visual Budget Analysis';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get personalFinancialSovereignty => 'Personal Financial Sovereignty';

  @override
  String get monthlyReport => 'MONTHLY REPORT';

  @override
  String get offlineDataProcessing => 'Data processed 100% offline';

  @override
  String pdfFooter(Object pageNumber, Object pagesCount, Object date) {
    return 'Page $pageNumber of $pagesCount  •  PocketVault  •  $date';
  }

  @override
  String get monthlyBalance => 'MONTHLY BALANCE';

  @override
  String get budgetAlerts => 'Budget Alerts';

  @override
  String limitExceededBy(Object pct) {
    return 'Limit exceeded by $pct';
  }

  @override
  String get limitReached => 'Limit reached';

  @override
  String limitPercentageReached(Object pct) {
    return '$pct of limit reached';
  }

  @override
  String spentOverLimit(Object spent, Object limit) {
    return '$spent / $limit';
  }

  @override
  String get budgetControl => 'Budget Control';

  @override
  String get noBudgetsConfigured => 'No budgets configured.';

  @override
  String get detailedStatement => 'Detailed Statement';

  @override
  String transactionValue(Object sign, Object value) {
    return '$sign $value';
  }
}
