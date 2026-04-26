import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/enums/edit_category_dialog_enum.dart';
import 'package:pocket_vault/exceptions/category_exception.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/models/nullable.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/loading_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/components/color_picker_tile.dart';
import 'package:pocket_vault/utils/app_alerts.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class EditCategoryDialog extends ConsumerStatefulWidget {
  final Category? category;
  final EditCategoryDialogEnum lastTab;

  const EditCategoryDialog({required this.lastTab, this.category, super.key});

  @override
  ConsumerState<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends ConsumerState<EditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final CurrencyTextFieldController _budgetLimitController;
  Category? _selectedCategory;
  String? _budgetLimitError;
  String? _categoryError;
  Color? _selectedColor;

  late final CurrencySymbolEnum _currency;

  void _saveCategory(AppLocalizations t) async {
    if (!_formKey.currentState!.validate()) return;
    if (_budgetLimitError != null) return;
    if (_selectedCategory == null) {
      setState(() {
        _categoryError = t.selectCategory;
      });
      return;
    }

    final categoryNotifier = ref.read(categoryListProvider.notifier);
    final loadingNotifier = ref.read(loadingStateProvider.notifier);

    loadingNotifier.setLoading(true);

    try {
      await categoryNotifier.upsertCategory(
        _selectedCategory!.copyWith(
          budgetLimit: _budgetLimitController.doubleValue,
          color: Nullable(_selectedColor?.toHexString()),
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
    } finally {
      loadingNotifier.setLoading(false);
    }

    if (mounted) Navigator.pop(context);
  }

  void _cancelDialog() {
    setState(() {
      _selectedCategory = null;
      _budgetLimitController.clear();
    });

    Navigator.pop(context);
  }

  void _onChangedBudgetLimit(AppLocalizations t) {
    if (_budgetLimitError != null && _budgetLimitController.doubleValue > 0) {
      setState(() {
        _budgetLimitError = _budgetLimitController.doubleValue <= 0
            ? t.valueGreaterThanZero
            : null;
      });
    }
  }

  void _onSelectedCategory(Category? value) {
    setState(() {
      _selectedCategory = value;
      _categoryError = null;
    });
  }

  void _onSelectedColor(Color? currentColor) {
    setState(() => _selectedColor = currentColor);
  }

  @override
  void initState() {
    super.initState();
    _currency = ref.read(preferencesProvider).currencySymbol;
    double initValue = 0.0;

    if (widget.category != null) {
      _selectedCategory = widget.category!;
      initValue = widget.category!.budgetLimit!;

      final categoryColor = widget.category!.color;

      _selectedColor = categoryColor != null
          ? Color(int.parse(categoryColor, radix: 16))
          : null;
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
    final lastTab = widget.lastTab;
    late final List<Category> categories;

    if (widget.category == null) {
      categories = ref.watch(categoriesWithoutBudgetProvider);
    }

    return AlertDialog(
      title: Text(
        (lastTab == EditCategoryDialogEnum.color)
            ? t.defineColor
            : t.defineLimit,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(onPressed: () => _cancelDialog(), child: Text(t.cancel)),
        ElevatedButton(onPressed: () => _saveCategory(t), child: Text(t.save)),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lastTab == EditCategoryDialogEnum.color)
              ColorPickerTile(
                selectedColor: _selectedColor,
                onColorChanged: _onSelectedColor,
              ),

            if (lastTab == EditCategoryDialogEnum.budget)
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (_) => _onChangedBudgetLimit(t),
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
