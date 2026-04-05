import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/enums/theme_mode_enum.dart';
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
  Future<bool?> _showConfirmImportDialog(BuildContext context) =>
      showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('t.confirmImport'),
          content: Text('t.confirmImportMessage'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('t.cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('t.confirm'),
            ),
          ],
        ),
      );

  Future<void> _runAction({
    required BuildContext context,
    required Future<void> Function() action,
    required String successMessage,
    required String errorMessage,
    bool closeModal = true,
  }) async {
    try {
      await action();

      if (!context.mounted) return;

      AlertInfo.show(
        context: context,
        text: successMessage,
        typeInfo: TypeInfo.success,
      );
    } catch (e) {
      if (!context.mounted) return;

      AlertInfo.show(
        context: context,
        text: errorMessage,
        typeInfo: TypeInfo.error,
      );
    }

    if (closeModal && context.mounted) {
      Navigator.of(context).maybePop();
    }
  }

  void _saveToFolder(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
  ) {
    _runAction(
      context: context,
      action: () async {
        await backupService.saveBackupToAppFolder();
        ref.read(preferencesProvider.notifier).setLastBackup(DateTime.now());
      },
      successMessage: 't.backupDownloaded',
      errorMessage: 't.backupDownloadError',
    );
  }

  void _share(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
  ) {
    _runAction(
      context: context,
      action: () async {
        await backupService.shareBackup();
        ref.read(preferencesProvider.notifier).setLastBackup(DateTime.now());
      },
      successMessage: 't.backupShared',
      errorMessage: 't.backupShareError',
    );
  }

  void _savedLocally(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
  ) async {
    final backup = await backupService.importFromAppFolder();

    if (!context.mounted) return;

    if (backup == null) {
      AlertInfo.show(
        context: context,
        text: 't.backupLocalNotFound',
        typeInfo: TypeInfo.warning,
      );
      return;
    }

    final confirm = await _showConfirmImportDialog(context);
    if (confirm != true) return;

    if (!context.mounted) return;
    await _runAction(
      context: context,
      action: () async {
        await backupService.replaceAll(backup);

        ref.invalidate(categoryListProvider);
        ref.invalidate(transactionListProvider);
        ref.invalidate(tagListProvider);
      },
      successMessage: 't.backupRestored',
      errorMessage: 't.backupImportError',
    );
  }

  void _searchFolder(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
  ) async {
    final backup = await backupService.importBackup();
    if (backup == null) return;

    if (!context.mounted) return;

    final confirm = await _showConfirmImportDialog(context);
    if (confirm != true) return;

    if (!context.mounted) return;
    await _runAction(
      context: context,
      action: () async {
        await backupService.replaceAll(backup);

        ref.invalidate(categoryListProvider);
        ref.invalidate(transactionListProvider);
        ref.invalidate(tagListProvider);
      },
      successMessage: 't.backupImported',
      errorMessage: 't.fileImportError',
    );
  }

  void _modalBottomSheet(
    BuildContext context,
    List<BottomSheetAction> actions,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
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
        );
      },
    );
  }

  void _showBackupActions(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
  ) {
    _modalBottomSheet(context, [
      BottomSheetAction(
        icon: LucideIcons.folderDown,
        title: 't.appBackupUsage',
        onTap: () => _saveToFolder(context, ref, backupService),
      ),
      BottomSheetAction(
        icon: LucideIcons.share2,
        title: 't.share',
        onTap: () => _share(context, ref, backupService),
      ),
    ]);
  }

  void _showImportActions(
    BuildContext context,
    WidgetRef ref,
    BackupService backupService,
  ) {
    _modalBottomSheet(context, [
      BottomSheetAction(
        icon: LucideIcons.folderOpen,
        title: 't.appBackupUsage',
        subtitle: 't.archiveSavedLocally',
        onTap: () => _savedLocally(context, ref, backupService),
      ),
      BottomSheetAction(
        icon: LucideIcons.search,
        title: 't.chooseFile',
        subtitle: 't.searchInAnotherFolder',
        onTap: () => _searchFolder(context, ref, backupService),
      ),
    ]);
  }

  void _return(BuildContext context) {
    Navigator.pop(context);
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
    final prefs = ref.watch(preferencesProvider);
    final prefsNotifier = ref.read(preferencesProvider.notifier);
    final backupService = ref.read(backupServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
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
                      title: 'Tema',
                      value: prefs.themeMode,
                      values: AppThemeModeEnum.values,
                      label: (t) => t.displayName,
                      onChanged: prefsNotifier.setTheme,
                    ),

                    SettingsDropdownTile<CurrencySymbolEnum>(
                      title: 'Moeda',
                      value: prefs.currencySymbol,
                      values: CurrencySymbolEnum.values,
                      label: (c) => c.code,
                      onChanged: prefsNotifier.setCurrencySymbol,
                    ),

                    SettingsSwitchTile(
                      title: 'Biometria',
                      value: prefs.isBiometricEnabled,
                      onChanged: prefsNotifier.setBiometricEnabled,
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Segurança dos Dados',
                  children: [
                    const Text(
                      'O "PocketVault" guarda tudo localmente. '
                      'Use as opções abaixo para não perder seus dados.',
                    ),

                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            dense: true,
                            leading: const Icon(LucideIcons.download),
                            title: const Text('Baixar backup'),
                            subtitle: const Text('Exportar seus dados'),
                            onTap: () =>
                                _showBackupActions(context, ref, backupService),
                          ),
                          const Divider(),
                          ListTile(
                            dense: true,
                            leading: const Icon(LucideIcons.upload),
                            title: const Text('Carregar backup'),
                            subtitle: const Text('Substituir dados atuais'),
                            onTap: () =>
                                _showImportActions(context, ref, backupService),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      prefs.lastBackupAt == null
                          ? 'Nenhum backup realizado'
                          : 'Último backup: ${DateFormat('dd/MM/yyyy HH:mm').format(prefs.lastBackupAt!)}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
