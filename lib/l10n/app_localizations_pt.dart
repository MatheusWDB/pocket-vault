// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get authFailed => 'Autenticação falhou';

  @override
  String get authCancelled => 'Autenticação cancelada pelo usuário';

  @override
  String get biometryUnavailable =>
      'Biometria não disponível neste dispositivo';

  @override
  String get operationCancelled => 'Operação cancelada pelo usuário';

  @override
  String get errorBackupGenerate => 'Erro ao gerar arquivo de backup';

  @override
  String get errorBackupSave => 'Erro ao salvar o backup no dispositivo';

  @override
  String get errorBackupShare => 'Erro ao compartilhar o backup';

  @override
  String get errorBackupImport => 'Erro ao importar o arquivo de backup';

  @override
  String get errorBackupRestore => 'Erro ao restaurar o backup';

  @override
  String get categoryNotFound => 'Categoria não encontrada';

  @override
  String get errorCategorySave => 'Erro ao salvar a categoria';

  @override
  String get errorDeleteCategoryLinked =>
      'Não é possível excluir uma categoria com transações vinculadas';

  @override
  String get notFound => 'não encontrado';

  @override
  String get errorInsert => 'Erro ao inserir';

  @override
  String get errorUpdate => 'Erro ao atualizar';

  @override
  String get errorDelete => 'Erro ao excluir';

  @override
  String get errorFetch => 'Erro ao buscar';

  @override
  String get tagNotFound => 'Tag não encontrada';

  @override
  String get errorTagSave => 'Erro ao salvar a tag';

  @override
  String get errorTagDelete => 'Erro ao excluir a tag';

  @override
  String get transactionNotFound => 'Transação não encontrada';

  @override
  String get errorTransactionSave => 'Erro ao salvar a transação';

  @override
  String get errorTransactionDelete => 'Erro ao excluir a transação';

  @override
  String get langPtBr => 'Português (Brasil)';

  @override
  String get langEnUs => 'English (USA)';

  @override
  String get currEuro => 'Euro (Europa)';

  @override
  String get currPound => 'Pound (UK)';

  @override
  String get currYen => 'Yen (Japan)';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get category => 'Categoria';

  @override
  String get tag => 'Tag';

  @override
  String get pocketVault => 'PocketVault';

  @override
  String get transaction => 'Transação';

  @override
  String get linkTransactionTag => 'Vínculo transação-tag';

  @override
  String get onboardingSubtitle => 'Sua soberania financeira começa aqui.';

  @override
  String get invalidBackupNoCategories => 'Backup inválido: sem categorias';

  @override
  String get invalidBackupNoTransactions => 'Backup inválido: sem transações';

  @override
  String get dbDeletedSuccess => 'Banco de dados deletado com sucesso!';

  @override
  String get appTitle => 'Soberania Financeira';

  @override
  String get unlockApp => 'Desbloquear aplicativo';

  @override
  String get all => 'Todos';

  @override
  String get selectPeriod => 'Selecionar Período';

  @override
  String get clearFilter => 'Limpar Filtro';

  @override
  String get confirm => 'Confirmar';

  @override
  String get summary => 'Resumo';

  @override
  String get transactions => 'Transações';

  @override
  String get budgets => 'Orçamentos';

  @override
  String get report => 'Relatório';

  @override
  String get confirmImport => 'Confirmar importação';

  @override
  String get importWarning =>
      'Isso substituirá todos os dados atuais pelo backup selecionado. Essa ação não pode ser desfeita.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get backupSaveSuccess => 'Backup salvo com sucesso';

  @override
  String get backupShareSuccess => 'Backup compartilhado com sucesso';

  @override
  String get backupImportSuccess => 'Backup importado com sucesso';

  @override
  String get download => 'Baixar';

  @override
  String get share => 'Compartilhar';

  @override
  String get chooseFile => 'Escolher arquivo';

  @override
  String get searchFolder => 'Pesquisar pasta';

  @override
  String get settings => 'Configurações';

  @override
  String get theme => 'Tema';

  @override
  String get currency => 'Moeda';

  @override
  String get biometry => 'Biometria';

  @override
  String get dataSecurity => 'Segurança dos Dados';

  @override
  String get storageInfo =>
      'O \"PocketVault\" guarda tudo localmente. Use as opções abaixo para não perder seus dados.';

  @override
  String get downloadBackup => 'Baixar backup';

  @override
  String get exportData => 'Exportar seus dados';

  @override
  String get loadBackup => 'Carregar backup';

  @override
  String get replaceCurrentData => 'Substituir dados atuais';

  @override
  String get noBackupPerformed => 'Nenhum backup realizado';

  @override
  String lastBackup(Object date) {
    return 'Último backup: $date';
  }

  @override
  String get clearDatabase => 'Limpar Banco de Dados';

  @override
  String get eraseAllData => 'Isso apagará todos os dados';

  @override
  String get resetDatabaseQuestion => 'Resetar Banco?';

  @override
  String get resetWarning => 'Isso apagará TODAS as transações e categorias.';

  @override
  String get dbResetSuccess =>
      'Banco de dados resetado! Reinicie o app se necessário.';

  @override
  String get dbResetError => 'Erro ao resetar o banco de dados';

  @override
  String get valueGreaterThanZero => 'O valor deve ser maior que zero';

  @override
  String get insertTitle => 'Insira um título';

  @override
  String get chooseColor => 'Escolher cor';

  @override
  String get reset => 'Redefinir';

  @override
  String get defineCategory => 'Defina uma categoria';

  @override
  String get onlyNumbers => 'Somente números';

  @override
  String get editTransaction => 'Editar Transação';

  @override
  String get newTransaction => 'Nova Transação';

  @override
  String get value => 'Valor';

  @override
  String get expense => 'Despesa';

  @override
  String get income => 'Receita';

  @override
  String get title => 'Título';

  @override
  String get examplePurchase => 'Ex: Compras 01/01/2026';

  @override
  String get transactionDate => 'Data da Transação';

  @override
  String get description => 'Descrição';

  @override
  String get exampleDescription => 'Ex: Compras do mês pago no cartão';

  @override
  String get noCategoryFound => 'Nenhuma categoria encontrada';

  @override
  String get exampleMarket => 'Ex: Mercado';

  @override
  String get categoryColor => 'Cor de Categoria';

  @override
  String get installments => 'Parcelas';

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
  String get recurrentTransaction => 'Transação Recorrente';

  @override
  String get details => 'Detalhes';

  @override
  String get date => 'Data';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get selectCategory => 'Selecione uma categoria';

  @override
  String get defineLimit => 'Defina um limite';

  @override
  String get save => 'Salvar';

  @override
  String get budgetProgress => 'Progresso do orçamento';

  @override
  String budgetWarning(Object percentage) {
    return 'Atenção: $percentage% do teto atingido.';
  }

  @override
  String budgetExceeded(Object percentage) {
    return 'Atenção: Teto estourado em $percentage%.';
  }

  @override
  String spentOfLimit(Object spentText, Object limitText) {
    return '$spentText de $limitText';
  }

  @override
  String get allCategoriesHaveLimit => 'Todas as categorias já possuem limite';

  @override
  String get newLimit => 'Novo Limite';

  @override
  String get totalBalance => 'Saldo Total';

  @override
  String get entries => 'Entradas';

  @override
  String get outputs => 'Saídas';

  @override
  String get history => 'Histórico';

  @override
  String get noTransactionsInPeriod => 'Nenhuma transação no período';

  @override
  String get totalSpent => 'TOTAL GASTO';

  @override
  String get generatePdf => 'Gerar PDF';

  @override
  String get filterByNameOrTag => 'Filtrar por nome ou tag...';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get visualBudgetAnalysis => 'Análise Visual de Orçamentos';

  @override
  String get transactionHistory => 'Histórico de Transações';

  @override
  String get personalFinancialSovereignty => 'Soberania Financeira Pessoal';

  @override
  String get monthlyReport => 'RELATÓRIO MENSAL';

  @override
  String get offlineDataProcessing => 'Dados processados 100% offline';

  @override
  String pdfFooter(Object pageNumber, Object pagesCount, Object date) {
    return 'Página $pageNumber de $pagesCount  •  PocketVault  •  $date';
  }

  @override
  String get monthlyBalance => 'SALDO DO MÊS';

  @override
  String get budgetAlerts => 'Alertas de Orçamento';

  @override
  String limitExceededBy(Object pct) {
    return 'Limite excedido em $pct';
  }

  @override
  String get limitReached => 'Limite atingido';

  @override
  String limitPercentageReached(Object pct) {
    return '$pct do limite atingido';
  }

  @override
  String spentOverLimit(Object spent, Object limit) {
    return '$spent / $limit';
  }

  @override
  String get budgetControl => 'Controle de Orçamentos';

  @override
  String get noBudgetsConfigured => 'Nenhum orçamento configurado.';

  @override
  String get detailedStatement => 'Extrato Detalhado';

  @override
  String transactionValue(Object sign, Object value) {
    return '$sign $value';
  }

  @override
  String get editScopeQuestion =>
      'Deseja editar somente esta transação ou esta e todas as futuras?';

  @override
  String get editScopeOnlyThis => 'Somente esta';

  @override
  String get editScopeThisAndFuture => 'Esta e as futuras';

  @override
  String installmentLabel(Object current, Object total) {
    return 'Parcela: $current/$total';
  }

  @override
  String get defineColor => 'Definir Cor';

  @override
  String deleteConfirmation(Object title) {
    return 'Deseja excluir \"$title\"?';
  }
}
