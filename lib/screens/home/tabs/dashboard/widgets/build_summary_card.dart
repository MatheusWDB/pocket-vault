import 'package:flutter/material.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class BuildSummaryCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;
  final CurrencySymbolEnum currencySymbol;

  const BuildSummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.currencySymbol,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8.0,
                children: [
                  Icon(icon, color: color),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      
              Text(
                value.toCurrency(
                  code: currencySymbol.code,
                  locale: currencySymbol.locale,
                ),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
