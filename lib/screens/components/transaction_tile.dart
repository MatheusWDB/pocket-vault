import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final CurrencySymbolEnum currencySymbol;

  const TransactionTile({
    required this.transaction,
    required this.currencySymbol,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
        transaction.amount.toCurrency(currencySymbol),
        style: TextStyle(
          color: isIncome ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
