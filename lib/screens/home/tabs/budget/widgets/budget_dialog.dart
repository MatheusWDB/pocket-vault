import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/exceptions/category_exception.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/utils/app_alerts.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class BudgetDialog extends ConsumerStatefulWidget {
  final Category? category;

  const BudgetDialog({this.category, super.key});

  @override
  ConsumerState<BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends ConsumerState<BudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  late final CurrencyTextFieldController _budgetLimitController;
  Category? _selectedCategory;
  String? _budgetLimitError;
  String? _categoryError;

  late final CurrencySymbolEnum _currency;

  void _saveBudget(AppLocalizations t) async {
    if (!_formKey.currentState!.validate()) return;
    if (_budgetLimitError != null) return;
    if (_selectedCategory == null) {
      setState(() {
        _categoryError = t.selectCategory;
      });
      return;
    }

    final categoryNotifier = ref.read(categoryListProvider.notifier);

    await categoryNotifier.upsertCategory(
      _selectedCategory!.copyWith(
        budgetLimit: _budgetLimitController.doubleValue,
      ),
    );

    final categoryState = ref.read(categoryListProvider);
    if (categoryState.hasError) {
      if (!mounted) return;
      final error = categoryState.error;
      if (error is CategoryException) {
        AppAlerts.error(context, e: error);
      }
      return;
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  void _cancelDialog() {
    setState(() {
      _selectedCategory = null;
      _budgetLimitController.clear();
    });

    Navigator.pop(context);
  }

  void _onChangedBudgetLimit() {
    if (_budgetLimitError != null && _budgetLimitController.doubleValue > 0) {
      setState(() => _budgetLimitError = null);
    }
  }

  Null _validatorBudgetLimit(AppLocalizations t) {
    setState(() {
      _budgetLimitError = (_budgetLimitController.doubleValue <= 0)
          ? t.valueGreaterThanZero
          : null;
    });

    return null;
  }

  void _onSelectedCategory(Category? value) {
    setState(() {
      _selectedCategory = value;
      _categoryError = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _currency = ref.read(preferencesProvider).currencySymbol;
    double initValue = 0.0;

    if (widget.category != null) {
      _selectedCategory = widget.category!;
      initValue = widget.category!.budgetLimit!;
    }

    _budgetLimitController = CurrencyTextFieldController(
      currencySymbol: _currency.symbol,
      decimalSymbol: _currency.locale == 'pt_BR' ? ',' : '.',
      thousandSymbol: _currency.locale == 'pt_BR' ? '.' : ',',
      initDoubleValue: initValue,
      numberOfDecimals: _currency.decimalDigits,
      showZeroValue: true,
      minValue: 0.0,
    );
  }

  @override
  void dispose() {
    _budgetLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final categories = ref.watch(categoriesAvailableForBudgetProvider);

    return AlertDialog(
      title: Text(t.defineLimit, textAlign: TextAlign.center),
      actions: [
        TextButton(onPressed: () => _cancelDialog(), child: Text(t.cancel)),
        ElevatedButton(onPressed: () => _saveBudget(t), child: Text(t.save)),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _budgetLimitController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: (0.0).toCurrency(
                  code: _currency.code,
                  locale: _currency.locale,
                ),
                error: _budgetLimitError == null
                    ? null
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _budgetLimitError!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              onChanged: (_) => _onChangedBudgetLimit(),
              validator: (_) => _validatorBudgetLimit(t),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.selectCategory,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                LayoutBuilder(
                  builder: (context, constraints) => DropdownMenu<Category?>(
                    initialSelection: _selectedCategory,
                    enabled: widget.category == null,
                    width: constraints.maxWidth,
                    enableFilter: true,
                    requestFocusOnTap: true,
                    menuHeight: MediaQuery.heightOf(context) * .32,
                    errorText: _categoryError,
                    onSelected: (Category? value) => _onSelectedCategory(value),
                    dropdownMenuEntries: widget.category != null
                        ? [
                            DropdownMenuEntry<Category>(
                              value: widget.category!,
                              label: widget.category!.name,
                            ),
                          ]
                        : categories
                              .map(
                                (c) => DropdownMenuEntry<Category>(
                                  value: c,
                                  label: c.name,
                                ),
                              )
                              .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
