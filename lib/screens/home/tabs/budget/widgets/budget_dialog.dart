import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
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

  void _saveBudget() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      setState(() {
        _categoryError = 'Selecione uma categoria';
      });
      return;
    }

    final categoryNotifier = ref.read(categoryListProvider.notifier);

    categoryNotifier.upsertCategory(
      _selectedCategory!.copyWith(
        budgetLimit: _budgetLimitController.doubleValue,
      ),
    );

    Navigator.pop(context);
  }

  void _cancelDialog() {
    setState(() {
      _selectedCategory = null;
      _budgetLimitController.clear();
    });

    Navigator.pop(context);
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
    final categories = ref.watch(categoriesAvailableForBudgetProvider);

    return AlertDialog(
      title: const Text('Definir Limite', textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () => _cancelDialog(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => _saveBudget(),
          child: const Text('Salvar'),
        ),
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
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              onChanged: (value) {
                if (_budgetLimitError != null &&
                    _budgetLimitController.doubleValue > 0) {
                  setState(() => _budgetLimitError = null);
                }
              },
              validator: (_) {
                setState(() {
                  if (_budgetLimitController.doubleValue <= 0) {
                    _budgetLimitError = 'O valor deve ser maior que zero';
                  } else {
                    _budgetLimitError = null;
                  }
                });

                return null;
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecione a Categoria',
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
                    onSelected: (Category? value) {
                      setState(() {
                        _selectedCategory = value;
                        _categoryError = null;
                      });
                    },
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
