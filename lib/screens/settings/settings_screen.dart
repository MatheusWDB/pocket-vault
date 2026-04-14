import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/enums/theme_mode_enum.dart';
import 'package:pocket_vault/exceptions/backup_exception.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/navigation/route_observer.dart';
import 'package:pocket_vault/providers/backup_provider.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/tag_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/settings/widgets/settings_dropdown_tile.dart';
import 'package:pocket_vault/screens/settings/widgets/settings_section.dart';
import 'package:pocket_vault/screens/settings/widgets/settings_switch_tile.dart';
import 'package:pocket_vault/services/backup_service.dart';
import 'package:pocket_vault/theme/app_theme.dart';
import 'package:pocket_vault/utils/app_alerts.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';

class BottomSheetAction {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const BottomSheetAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with RouteAware {
  Future<bool?> _showConfirmImportDialog(
    BuildContext context,
    AppLocalizations t,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.confirmImport),
        content: Text(t.importWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.confirm),
          ),
        ],
      ),
    );
  }

  void _closeBottomSheet() {
    if (mounted) Navigator.of(context).maybePop();
  }

  void _save(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
    AppLocalizations t,
  ) async {
    _closeBottomSheet();

    try {
      await backupService.saveBackup();

      if (!context.mounted) return;
      ref.read(preferencesProvider.notifier).setLastBackup(DateTime.now());
      AppAlerts.success(context, message: t.backupSaveSuccess);
    } on BackupException catch (e) {
      if (!context.mounted) return;
      switch (e) {
        case BackupCancelledException():
          return;
        case BackupSaveException():
          AppAlerts.error(context, e: e);
        case BackupGenerationException():
          AppAlerts.error(context, e: e);
        case BackupShareException():
        case BackupImportException():
        case BackupRestoreException():
        case BackupInvalidNoCategoriesException():
        case BackupInvalidNoTransactionsException():
      }
    }
  }

  void _share(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
    AppLocalizations t,
  ) async {
    _closeBottomSheet();

    try {
      await backupService.shareBackup();

      if (!context.mounted) return;
      ref.read(preferencesProvider.notifier).setLastBackup(DateTime.now());
      AppAlerts.success(context, message: t.backupShareSuccess);
    } on BackupException catch (e) {
      if (!context.mounted) return;
      switch (e) {
        case BackupCancelledException():
          return;
        case BackupSaveException():
        case BackupGenerationException():
          AppAlerts.error(context, e: e);
        case BackupShareException():
          AppAlerts.error(context, e: e);
        case BackupImportException():
        case BackupRestoreException():
        case BackupInvalidNoCategoriesException():
        case BackupInvalidNoTransactionsException():
      }
    }
  }

  void _searchFolder(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
    AppLocalizations t,
  ) async {
    _closeBottomSheet();

    try {
      final backup = await backupService.importBackup();

      if (!context.mounted) return;
      final confirm = await _showConfirmImportDialog(context, t);
      if (confirm != true) return;

      if (!context.mounted) return;
      await backupService.replaceAll(backup);

      ref.invalidate(categoryListProvider);
      ref.invalidate(transactionListProvider);
      ref.invalidate(tagListProvider);

      if (!context.mounted) return;
      AppAlerts.success(context, message: t.backupImportSuccess);
    } on BackupException catch (e) {
      if (!context.mounted) return;
      switch (e) {
        case BackupCancelledException():
          return;
        case BackupSaveException():
        case BackupGenerationException():
        case BackupShareException():
        case BackupImportException():
          AppAlerts.error(context, e: e);
        case BackupRestoreException():
        case BackupInvalidNoCategoriesException():
        case BackupInvalidNoTransactionsException():
      }
    }
  }

  void _modalBottomSheet(
    BuildContext context,
    List<BottomSheetAction> actions,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final action in actions)
              ListTile(
                leading: Icon(action.icon),
                title: Text(action.title),
                subtitle: action.subtitle != null
                    ? Text(action.subtitle!)
                    : null,
                onTap: action.onTap,
              ),
          ],
        ),
      ),
    );
  }

  void _showBackupActions(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
    AppLocalizations t,
  ) {
    _modalBottomSheet(context, [
      BottomSheetAction(
        icon: LucideIcons.folderDown,
        title: t.download,
        onTap: () => _save(context, ref, backupService, t),
      ),
      BottomSheetAction(
        icon: LucideIcons.share2,
        title: t.share,
        onTap: () => _share(context, ref, backupService, t),
      ),
    ]);
  }

  void _showImportActions(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
    AppLocalizations t,
  ) {
    _modalBottomSheet(context, [
      BottomSheetAction(
        icon: LucideIcons.search,
        title: t.chooseFile,
        subtitle: t.searchFolder,
        onTap: () => _searchFolder(context, ref, backupService, t),
      ),
    ]);
  }

  void _return(BuildContext context) {
    Navigator.pop(context);
  }

  void _onPressedDeleteForever(AppLocalizations t) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.resetDatabaseQuestion),
        content: Text(t.resetWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.confirm, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final service = ref.read(transactionServiceProvider);
      // DEPOIS
      try {
        await service.resetDatabase();
        ref.invalidate(transactionListProvider);
        if (!mounted) return;
        AppAlerts.success(context, message: t.dbResetSuccess);
      } catch (_) {
        if (!mounted) return;
        AppAlerts.error(context, message: t.dbResetError);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    ref
        .read(preferencesProvider.notifier)
        .setLastScreen(AppScreenEnum.settings);
  }

  @override
  void didPush() {
    ref
        .read(preferencesProvider.notifier)
        .setLastScreen(AppScreenEnum.settings);
  }

  @override
  void didPop() {
    ref.read(preferencesProvider.notifier).setLastScreen(AppScreenEnum.home);
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final t = AppLocalizations.of(context)!;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final prefs = ref.watch(preferencesProvider);
    final prefsNotifier = ref.read(preferencesProvider.notifier);
    final backupService = ref.read(backupServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _return(context),
          icon: const Icon(LucideIcons.chevronLeft),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              spacing: 15,
              children: [
                Column(
                  spacing: 15,
                  children: [
                    SettingsDropdownTile<AppThemeModeEnum>(
                      title: t.theme,
                      value: prefs.themeMode,
                      values: AppThemeModeEnum.values,
                      label: (theme) => theme.displayName(t),
                      onChanged: prefsNotifier.setTheme,
                    ),

                    SettingsDropdownTile<CurrencySymbolEnum>(
                      title: t.currency,
                      value: prefs.currencySymbol,
                      values: CurrencySymbolEnum.values,
                      label: (c) => c.code,
                      onChanged: prefsNotifier.setCurrencySymbol,
                    ),

                    SettingsSwitchTile(
                      title: t.biometry,
                      value: prefs.isBiometricEnabled,
                      onChanged: prefsNotifier.setBiometricEnabled,
                    ),
                  ],
                ),
                SettingsSection(
                  title: t.dataSecurity,
                  children: [
                    Text(t.storageInfo),

                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            dense: true,
                            leading: const Icon(LucideIcons.download),
                            title: Text(t.downloadBackup),
                            subtitle: Text(t.exportData),
                            onTap: () => _showBackupActions(
                              context,
                              ref,
                              backupService,
                              t,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            dense: true,
                            leading: const Icon(LucideIcons.upload),
                            title: Text(t.loadBackup),
                            subtitle: Text(t.replaceCurrentData),
                            onTap: () => _showImportActions(
                              context,
                              ref,
                              backupService,
                              t,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      prefs.lastBackupAt == null
                          ? t.noBackupPerformed
                          : t.lastBackup(
                              prefs.lastBackupAt!.toDateTime(myLocale),
                            ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: appColors.warning),
                  title: Text(t.clearDatabase),
                  subtitle: Text(t.eraseAllData),
                  trailing: Icon(LucideIcons.chevronRight),
                  onTap: () => _onPressedDeleteForever(t),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
