import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/components/build_marquee_text.dart';
import 'package:pocket_vault/screens/transaction_details/transaction_details_screen.dart';
import 'package:pocket_vault/theme/app_theme.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class TransactionTile extends ConsumerWidget {
  final Transaction transaction;

  const TransactionTile({required this.transaction, super.key});

  void _onTapTransaction(BuildContext context, WidgetRef ref) {
    final preferencesNotifier = ref.read(preferencesProvider.notifier);

    preferencesNotifier.setLastTransactionDetailId(transaction.id);
    preferencesNotifier.setLastScreen(AppScreenEnum.details);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TransactionDetailsScreen(transaction: transaction),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencySymbol = ref.watch(preferencesProvider).currencySymbol;
    final currentTab = ref.read(preferencesProvider).lastTab;
    final isIncome = transaction.amount > 0;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return ListTile(
      leading: currentTab == AppTabEnum.dashboard
          ? CircleAvatar(
              backgroundColor: (isIncome
                  ? appColors.incomeBg
                  : appColors.expenseBg),
              radius: 18.0,
              child: Icon(
                isIncome ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                color: isIncome ? appColors.income : appColors.expense,
                size: 18.0,
              ),
            )
          : null,
      title: BuildMarqueeText(
        text: transaction.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(transaction.category.name.toString()),
      trailing: Text(
        transaction.amount.toCurrency(
          code: currencySymbol.code,
          locale: currencySymbol.locale,
        ),
        style: TextStyle(
          color: isIncome ? appColors.income : appColors.expense,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      onTap: () => _onTapTransaction(context, ref),
    );
  }
}
