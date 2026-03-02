import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class TransactionTile extends ConsumerWidget {
  final Transaction transaction;

  const TransactionTile({
    required this.transaction,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencySymbol = ref.watch(preferencesProvider).currencySymbol;
    final isIncome = transaction.amount > 0;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (isIncome ? Colors.green : Colors.red).withValues(
          alpha: 0.1,
        ),
        radius: 18.0,
        child: Icon(
          isIncome ? LucideIcons.arrowUp : LucideIcons.arrowDown,
          color: isIncome ? Colors.green : Colors.red,
          size: 18.0,
        ),
      ),
      title: Text(
        transaction.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(transaction.category.name.toString()),
      trailing: Text(
        transaction.amount.toCurrency(
          code: currencySymbol.code,
          locale: currencySymbol.locale,
        ),
        style: TextStyle(
          color: isIncome ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
