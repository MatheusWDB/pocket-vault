import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @authFailed.
  ///
  /// In pt, this message translates to:
  /// **'Autenticação falhou'**
  String get authFailed;

  /// No description provided for @authCancelled.
  ///
  /// In pt, this message translates to:
  /// **'Autenticação cancelada pelo usuário'**
  String get authCancelled;

  /// No description provided for @biometryUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Biometria não disponível neste dispositivo'**
  String get biometryUnavailable;

  /// No description provided for @operationCancelled.
  ///
  /// In pt, this message translates to:
  /// **'Operação cancelada pelo usuário'**
  String get operationCancelled;

  /// No description provided for @errorBackupGenerate.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao gerar arquivo de backup'**
  String get errorBackupGenerate;

  /// No description provided for @errorBackupSave.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao salvar o backup no dispositivo'**
  String get errorBackupSave;

  /// No description provided for @errorBackupShare.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao compartilhar o backup'**
  String get errorBackupShare;

  /// No description provided for @errorBackupImport.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao importar o arquivo de backup'**
  String get errorBackupImport;

  /// No description provided for @errorBackupRestore.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao restaurar o backup'**
  String get errorBackupRestore;

  /// No description provided for @categoryNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Categoria não encontrada'**
  String get categoryNotFound;

  /// No description provided for @errorCategorySave.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao salvar a categoria'**
  String get errorCategorySave;

  /// No description provided for @errorDeleteCategoryLinked.
  ///
  /// In pt, this message translates to:
  /// **'Não é possível excluir uma categoria com transações vinculadas'**
  String get errorDeleteCategoryLinked;

  /// No description provided for @notFound.
  ///
  /// In pt, this message translates to:
  /// **'não encontrado'**
  String get notFound;

  /// No description provided for @errorInsert.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao inserir'**
  String get errorInsert;

  /// No description provided for @errorUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao atualizar'**
  String get errorUpdate;

  /// No description provided for @errorDelete.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao excluir'**
  String get errorDelete;

  /// No description provided for @errorFetch.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao buscar'**
  String get errorFetch;

  /// No description provided for @tagNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Tag não encontrada'**
  String get tagNotFound;

  /// No description provided for @errorTagSave.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao salvar a tag'**
  String get errorTagSave;

  /// No description provided for @errorTagDelete.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao excluir a tag'**
  String get errorTagDelete;

  /// No description provided for @transactionNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Transação não encontrada'**
  String get transactionNotFound;

  /// No description provided for @errorTransactionSave.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao salvar a transação'**
  String get errorTransactionSave;

  /// No description provided for @errorTransactionDelete.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao excluir a transação'**
  String get errorTransactionDelete;

  /// No description provided for @langPtBr.
  ///
  /// In pt, this message translates to:
  /// **'Português (Brasil)'**
  String get langPtBr;

  /// No description provided for @langEnUs.
  ///
  /// In pt, this message translates to:
  /// **'English (USA)'**
  String get langEnUs;

  /// No description provided for @currEuro.
  ///
  /// In pt, this message translates to:
  /// **'Euro (Europa)'**
  String get currEuro;

  /// No description provided for @currPound.
  ///
  /// In pt, this message translates to:
  /// **'Pound (UK)'**
  String get currPound;

  /// No description provided for @currYen.
  ///
  /// In pt, this message translates to:
  /// **'Yen (Japan)'**
  String get currYen;

  /// No description provided for @system.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get system;

  /// No description provided for @light.
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get dark;

  /// No description provided for @category.
  ///
  /// In pt, this message translates to:
  /// **'Categoria'**
  String get category;

  /// No description provided for @tag.
  ///
  /// In pt, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @pocketVault.
  ///
  /// In pt, this message translates to:
  /// **'PocketVault'**
  String get pocketVault;

  /// No description provided for @transaction.
  ///
  /// In pt, this message translates to:
  /// **'Transação'**
  String get transaction;

  /// No description provided for @linkTransactionTag.
  ///
  /// In pt, this message translates to:
  /// **'Vínculo transação-tag'**
  String get linkTransactionTag;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Sua soberania financeira começa aqui.'**
  String get onboardingSubtitle;

  /// No description provided for @invalidBackupNoCategories.
  ///
  /// In pt, this message translates to:
  /// **'Backup inválido: sem categorias'**
  String get invalidBackupNoCategories;

  /// No description provided for @invalidBackupNoTransactions.
  ///
  /// In pt, this message translates to:
  /// **'Backup inválido: sem transações'**
  String get invalidBackupNoTransactions;

  /// No description provided for @dbDeletedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Banco de dados deletado com sucesso!'**
  String get dbDeletedSuccess;

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Soberania Financeira'**
  String get appTitle;

  /// No description provided for @unlockApp.
  ///
  /// In pt, this message translates to:
  /// **'Desbloquear aplicativo'**
  String get unlockApp;

  /// No description provided for @all.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @selectPeriod.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar Período'**
  String get selectPeriod;

  /// No description provided for @clearFilter.
  ///
  /// In pt, this message translates to:
  /// **'Limpar Filtro'**
  String get clearFilter;

  /// No description provided for @confirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @summary.
  ///
  /// In pt, this message translates to:
  /// **'Resumo'**
  String get summary;

  /// No description provided for @transactions.
  ///
  /// In pt, this message translates to:
  /// **'Transações'**
  String get transactions;

  /// No description provided for @budgets.
  ///
  /// In pt, this message translates to:
  /// **'Orçamentos'**
  String get budgets;

  /// No description provided for @report.
  ///
  /// In pt, this message translates to:
  /// **'Relatório'**
  String get report;

  /// No description provided for @confirmImport.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar importação'**
  String get confirmImport;

  /// No description provided for @importWarning.
  ///
  /// In pt, this message translates to:
  /// **'Isso substituirá todos os dados atuais pelo backup selecionado. Essa ação não pode ser desfeita.'**
  String get importWarning;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @backupSaveSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Backup salvo com sucesso'**
  String get backupSaveSuccess;

  /// No description provided for @backupShareSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Backup compartilhado com sucesso'**
  String get backupShareSuccess;

  /// No description provided for @backupImportSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Backup importado com sucesso'**
  String get backupImportSuccess;

  /// No description provided for @download.
  ///
  /// In pt, this message translates to:
  /// **'Baixar'**
  String get download;

  /// No description provided for @share.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar'**
  String get share;

  /// No description provided for @chooseFile.
  ///
  /// In pt, this message translates to:
  /// **'Escolher arquivo'**
  String get chooseFile;

  /// No description provided for @searchFolder.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar pasta'**
  String get searchFolder;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In pt, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @currency.
  ///
  /// In pt, this message translates to:
  /// **'Moeda'**
  String get currency;

  /// No description provided for @biometry.
  ///
  /// In pt, this message translates to:
  /// **'Biometria'**
  String get biometry;

  /// No description provided for @dataSecurity.
  ///
  /// In pt, this message translates to:
  /// **'Segurança dos Dados'**
  String get dataSecurity;

  /// No description provided for @storageInfo.
  ///
  /// In pt, this message translates to:
  /// **'O \"PocketVault\" guarda tudo localmente. Use as opções abaixo para não perder seus dados.'**
  String get storageInfo;

  /// No description provided for @downloadBackup.
  ///
  /// In pt, this message translates to:
  /// **'Baixar backup'**
  String get downloadBackup;

  /// No description provided for @exportData.
  ///
  /// In pt, this message translates to:
  /// **'Exportar seus dados'**
  String get exportData;

  /// No description provided for @loadBackup.
  ///
  /// In pt, this message translates to:
  /// **'Carregar backup'**
  String get loadBackup;

  /// No description provided for @replaceCurrentData.
  ///
  /// In pt, this message translates to:
  /// **'Substituir dados atuais'**
  String get replaceCurrentData;

  /// No description provided for @noBackupPerformed.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum backup realizado'**
  String get noBackupPerformed;

  /// No description provided for @lastBackup.
  ///
  /// In pt, this message translates to:
  /// **'Último backup: {date}'**
  String lastBackup(Object date);

  /// No description provided for @clearDatabase.
  ///
  /// In pt, this message translates to:
  /// **'Limpar Banco de Dados'**
  String get clearDatabase;

  /// No description provided for @eraseAllData.
  ///
  /// In pt, this message translates to:
  /// **'Isso apagará todos os dados'**
  String get eraseAllData;

  /// No description provided for @resetDatabaseQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Resetar Banco?'**
  String get resetDatabaseQuestion;

  /// No description provided for @resetWarning.
  ///
  /// In pt, this message translates to:
  /// **'Isso apagará TODAS as transações e categorias.'**
  String get resetWarning;

  /// No description provided for @dbResetSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Banco de dados resetado! Reinicie o app se necessário.'**
  String get dbResetSuccess;

  /// No description provided for @dbResetError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao resetar o banco de dados'**
  String get dbResetError;

  /// No description provided for @valueGreaterThanZero.
  ///
  /// In pt, this message translates to:
  /// **'O valor deve ser maior que zero'**
  String get valueGreaterThanZero;

  /// No description provided for @insertTitle.
  ///
  /// In pt, this message translates to:
  /// **'Insira um título'**
  String get insertTitle;

  /// No description provided for @chooseColor.
  ///
  /// In pt, this message translates to:
  /// **'Escolher cor'**
  String get chooseColor;

  /// No description provided for @reset.
  ///
  /// In pt, this message translates to:
  /// **'Redefinir'**
  String get reset;

  /// No description provided for @defineCategory.
  ///
  /// In pt, this message translates to:
  /// **'Defina uma categoria'**
  String get defineCategory;

  /// No description provided for @onlyNumbers.
  ///
  /// In pt, this message translates to:
  /// **'Somente números'**
  String get onlyNumbers;

  /// No description provided for @editTransaction.
  ///
  /// In pt, this message translates to:
  /// **'Editar Transação'**
  String get editTransaction;

  /// No description provided for @newTransaction.
  ///
  /// In pt, this message translates to:
  /// **'Nova Transação'**
  String get newTransaction;

  /// No description provided for @value.
  ///
  /// In pt, this message translates to:
  /// **'Valor'**
  String get value;

  /// No description provided for @expense.
  ///
  /// In pt, this message translates to:
  /// **'Despesa'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In pt, this message translates to:
  /// **'Receita'**
  String get income;

  /// No description provided for @title.
  ///
  /// In pt, this message translates to:
  /// **'Título'**
  String get title;

  /// No description provided for @examplePurchase.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Compras 01/01/2026'**
  String get examplePurchase;

  /// No description provided for @transactionDate.
  ///
  /// In pt, this message translates to:
  /// **'Data da Transação'**
  String get transactionDate;

  /// No description provided for @description.
  ///
  /// In pt, this message translates to:
  /// **'Descrição'**
  String get description;

  /// No description provided for @exampleDescription.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Compras do mês pago no cartão'**
  String get exampleDescription;

  /// No description provided for @noCategoryFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma categoria encontrada'**
  String get noCategoryFound;

  /// No description provided for @exampleMarket.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Mercado'**
  String get exampleMarket;

  /// No description provided for @categoryColor.
  ///
  /// In pt, this message translates to:
  /// **'Cor de Categoria'**
  String get categoryColor;

  /// No description provided for @installments.
  ///
  /// In pt, this message translates to:
  /// **'Parcelas'**
  String get installments;

  /// No description provided for @exampleInstallments.
  ///
  /// In pt, this message translates to:
  /// **'Ex: 12'**
  String get exampleInstallments;

  /// No description provided for @tags.
  ///
  /// In pt, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @add.
  ///
  /// In pt, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @tagPlaceholder.
  ///
  /// In pt, this message translates to:
  /// **'Tag {number}...'**
  String tagPlaceholder(Object number);

  /// No description provided for @recurrentTransaction.
  ///
  /// In pt, this message translates to:
  /// **'Transação Recorrente'**
  String get recurrentTransaction;

  /// No description provided for @details.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes'**
  String get details;

  /// No description provided for @date.
  ///
  /// In pt, this message translates to:
  /// **'Data'**
  String get date;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// No description provided for @selectCategory.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma categoria'**
  String get selectCategory;

  /// No description provided for @defineLimit.
  ///
  /// In pt, this message translates to:
  /// **'Defina um limite'**
  String get defineLimit;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @budgetProgress.
  ///
  /// In pt, this message translates to:
  /// **'Progresso do orçamento'**
  String get budgetProgress;

  /// No description provided for @budgetWarning.
  ///
  /// In pt, this message translates to:
  /// **'Atenção: {percentage}% do teto atingido.'**
  String budgetWarning(Object percentage);

  /// No description provided for @budgetExceeded.
  ///
  /// In pt, this message translates to:
  /// **'Atenção: Teto estourado em {percentage}%.'**
  String budgetExceeded(Object percentage);

  /// No description provided for @spentOfLimit.
  ///
  /// In pt, this message translates to:
  /// **'{spentText} de {limitText}'**
  String spentOfLimit(Object spentText, Object limitText);

  /// No description provided for @allCategoriesHaveLimit.
  ///
  /// In pt, this message translates to:
  /// **'Todas as categorias já possuem limite'**
  String get allCategoriesHaveLimit;

  /// No description provided for @newLimit.
  ///
  /// In pt, this message translates to:
  /// **'Novo Limite'**
  String get newLimit;

  /// No description provided for @totalBalance.
  ///
  /// In pt, this message translates to:
  /// **'Saldo Total'**
  String get totalBalance;

  /// No description provided for @entries.
  ///
  /// In pt, this message translates to:
  /// **'Entradas'**
  String get entries;

  /// No description provided for @outputs.
  ///
  /// In pt, this message translates to:
  /// **'Saídas'**
  String get outputs;

  /// No description provided for @history.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get history;

  /// No description provided for @noTransactionsInPeriod.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma transação no período'**
  String get noTransactionsInPeriod;

  /// No description provided for @totalSpent.
  ///
  /// In pt, this message translates to:
  /// **'TOTAL GASTO'**
  String get totalSpent;

  /// No description provided for @generatePdf.
  ///
  /// In pt, this message translates to:
  /// **'Gerar PDF'**
  String get generatePdf;

  /// No description provided for @filterByNameOrTag.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar por nome ou tag...'**
  String get filterByNameOrTag;

  /// No description provided for @today.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In pt, this message translates to:
  /// **'Ontem'**
  String get yesterday;

  /// No description provided for @visualBudgetAnalysis.
  ///
  /// In pt, this message translates to:
  /// **'Análise Visual de Orçamentos'**
  String get visualBudgetAnalysis;

  /// No description provided for @transactionHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico de Transações'**
  String get transactionHistory;

  /// No description provided for @personalFinancialSovereignty.
  ///
  /// In pt, this message translates to:
  /// **'Soberania Financeira Pessoal'**
  String get personalFinancialSovereignty;

  /// No description provided for @monthlyReport.
  ///
  /// In pt, this message translates to:
  /// **'RELATÓRIO MENSAL'**
  String get monthlyReport;

  /// No description provided for @offlineDataProcessing.
  ///
  /// In pt, this message translates to:
  /// **'Dados processados 100% offline'**
  String get offlineDataProcessing;

  /// No description provided for @pdfFooter.
  ///
  /// In pt, this message translates to:
  /// **'Página {pageNumber} de {pagesCount}  •  PocketVault  •  {date}'**
  String pdfFooter(Object pageNumber, Object pagesCount, Object date);

  /// No description provided for @monthlyBalance.
  ///
  /// In pt, this message translates to:
  /// **'SALDO DO MÊS'**
  String get monthlyBalance;

  /// No description provided for @budgetAlerts.
  ///
  /// In pt, this message translates to:
  /// **'Alertas de Orçamento'**
  String get budgetAlerts;

  /// No description provided for @limitExceededBy.
  ///
  /// In pt, this message translates to:
  /// **'Limite excedido em {pct}'**
  String limitExceededBy(Object pct);

  /// No description provided for @limitReached.
  ///
  /// In pt, this message translates to:
  /// **'Limite atingido'**
  String get limitReached;

  /// No description provided for @limitPercentageReached.
  ///
  /// In pt, this message translates to:
  /// **'{pct} do limite atingido'**
  String limitPercentageReached(Object pct);

  /// No description provided for @spentOverLimit.
  ///
  /// In pt, this message translates to:
  /// **'{spent} / {limit}'**
  String spentOverLimit(Object spent, Object limit);

  /// No description provided for @budgetControl.
  ///
  /// In pt, this message translates to:
  /// **'Controle de Orçamentos'**
  String get budgetControl;

  /// No description provided for @noBudgetsConfigured.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum orçamento configurado.'**
  String get noBudgetsConfigured;

  /// No description provided for @detailedStatement.
  ///
  /// In pt, this message translates to:
  /// **'Extrato Detalhado'**
  String get detailedStatement;

  /// No description provided for @transactionValue.
  ///
  /// In pt, this message translates to:
  /// **'{sign} {value}'**
  String transactionValue(Object sign, Object value);

  /// No description provided for @editScopeQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Deseja editar somente esta transação ou esta e todas as futuras?'**
  String get editScopeQuestion;

  /// No description provided for @editScopeOnlyThis.
  ///
  /// In pt, this message translates to:
  /// **'Somente esta'**
  String get editScopeOnlyThis;

  /// No description provided for @editScopeThisAndFuture.
  ///
  /// In pt, this message translates to:
  /// **'Esta e as futuras'**
  String get editScopeThisAndFuture;

  /// No description provided for @installmentLabel.
  ///
  /// In pt, this message translates to:
  /// **'Parcela: {current}/{total}'**
  String installmentLabel(Object current, Object total);

  /// No description provided for @defineColor.
  ///
  /// In pt, this message translates to:
  /// **'Definir Cor'**
  String get defineColor;

  /// No description provided for @deleteConfirmation.
  ///
  /// In pt, this message translates to:
  /// **'Deseja excluir \"{title}\"?'**
  String deleteConfirmation(Object title);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
