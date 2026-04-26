import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/exceptions/category_exception.dart';
import 'package:pocket_vault/exceptions/tag_exception.dart';
import 'package:pocket_vault/exceptions/transaction_exception.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/navigation/route_observer.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/loading_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/components/color_picker_tile.dart';
import 'package:pocket_vault/screens/transaction_form/widgets/input_text_field.dart';
import 'package:pocket_vault/theme/app_theme.dart';
import 'package:pocket_vault/utils/app_alerts.dart';
import 'package:pocket_vault/utils/app_dialogs.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;
  const TransactionFormScreen({this.transaction, super.key});

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen>
    with RouteAware {
  final _formKey = GlobalKey<FormState>();
  final _categoryFocus = FocusNode();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<TextEditingController> _tagsControllers = [];
  late final CurrencyTextFieldController _amountController;
  final _installmentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isIncome = false;
  bool _isRecurring = false;
  String? _amountError;
  Color? _selectedColor;
  late final bool _edit;
  late final CurrencySymbolEnum _currency;
  Transaction? _template;
  bool _categoryHasColor = false;

  void _return() {
    Navigator.pop(context);
  }

  void _onChangedAmount(AppLocalizations t) {
    if (_amountError != null && _amountController.doubleValue > 0) {
      setState(() {
        _amountError = _amountController.doubleValue <= 0
            ? t.valueGreaterThanZero
            : null;
      });
    }
  }

  String? _validatorTitle(String? value, AppLocalizations t) {
    if (value == null || value.trim().isEmpty) {
      return t.insertTitle;
    }
    return null;
  }

  Future<void> _onTapSelectedDate(DateTime now, Locale myLocale) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year, now.month + 1, 0),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: myLocale,
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  void _onSelectedColor(Color? currentColor) {
    setState(() => _selectedColor = currentColor);
  }

  bool _hasPropagatableChanges({
    required Transaction transaction,
    required String title,
    required double amount,
    required Category category,
    required String description,
    required List<Tag> tags,
  }) {
    if (transaction.title != title) return true;
    if (transaction.amount != (_isIncome ? amount : -amount)) return true;
    if (transaction.category.name != category.name) return true;
    if (transaction.category.color != category.color) return true;
    if ((transaction.description ?? '') != description) return true;

    final originalTagNames = transaction.tags.map((t) => t.name).toSet();
    final newTagNames = tags.map((t) => t.name).toSet();
    if (!originalTagNames.containsAll(newTagNames) ||
        !newTagNames.containsAll(originalTagNames)) {
      return true;
    }

    return false;
  }

  Future<void> _saveTransaction(AppLocalizations t) async {
    if (!_formKey.currentState!.validate()) return;
    if (_amountError != null) return;
    final loadingNotifier = ref.read(loadingStateProvider.notifier);

    loadingNotifier.setLoading(true);

    final title = _titleController.text;
    final amount = _amountController.doubleValue;
    final description = _descriptionController.text;
    final totalInstallments = int.tryParse(_installmentController.text) ?? 1;

    final category = Category(
      name: _categoryController.text.trim(),
      color: _selectedColor?.toHexString(),
    );
    final List<Tag> tags = _tagsControllers
        .where((c) => c.text.trim().isNotEmpty)
        .map((c) => Tag(name: c.text.trim()))
        .toList();

    final transactionToSave = _edit
        ? widget.transaction!.copyWith(
            title: title,
            amount: _isIncome ? amount : -amount,
            date: _selectedDate,
            description: description.isNotEmpty ? description : null,
            category: category,
            tags: tags,

            totalInstallments: totalInstallments,
          )
        : Transaction(
            title: title,
            amount: _isIncome ? amount : -amount,
            date: _selectedDate,
            category: category,
            totalInstallments: totalInstallments,
            currentInstallment: totalInstallments > 1 ? null : 1,
            isRecurring: _isRecurring,
            isTemplate: _isRecurring || totalInstallments > 1,
            description: description.isNotEmpty ? description : null,
            tags: tags,
          );

    final notifier = ref.read(transactionListProvider.notifier);

    try {
      if (_edit && _template != null) {
        final shouldAsk = _hasPropagatableChanges(
          transaction: widget.transaction!,
          title: title,
          amount: amount,
          category: category,
          description: description,
          tags: tags,
        );

        if (shouldAsk) {
          final updateAll = await AppDialogs.choice(
            context: context,
            title: t.editTransaction,
            content: t.editScopeQuestion,
            labelA: t.editScopeOnlyThis,
            labelB: t.editScopeThisAndFuture,
          );

          if (updateAll == null || !mounted) return;

          if (updateAll) {
            final updatedTemplate = _template!.copyWith(
              title: title,
              amount: _isIncome ? amount : -amount,
              category: category,
              totalInstallments: totalInstallments,
              isRecurring: _isRecurring,
              description: description.isNotEmpty ? description : null,
              tags: tags,
            );
            await notifier.updateTransactionAndFuture(
              transactionToSave.copyWith(totalInstallments: totalInstallments),
              updatedTemplate,
            );
          } else {
            await notifier.updateTransactionOnly(transactionToSave);
          }
        } else {
          await notifier.updateTransactionOnly(transactionToSave);
        }
      } else {
        _edit
            ? await notifier.updateTransactionOnly(transactionToSave)
            : await notifier.saveTransaction(transactionToSave);
      }

      if (!mounted) return;
      final transactionState = ref.read(transactionListProvider);

      if (transactionState.hasError) {
        final error = transactionState.error;
        if (error is TransactionException) {
          AppAlerts.error(context, e: error);
        } else if (error is CategoryException) {
          AppAlerts.error(context, e: error);
        } else if (error is TagException) {
          AppAlerts.error(context, e: error);
        }
        return;
      }
    } finally {
      loadingNotifier.setLoading(false);
    }

    if (mounted) Navigator.pop(context);
  }

  Iterable<Category> _optionsBuilderCategory(
    TextEditingValue textEditingValue,
    AsyncValue<List<Category>> categoriesAsync,
  ) {
    if (textEditingValue.text.isEmpty) {
      return const Iterable<Category>.empty();
    }

    final categories = categoriesAsync.value ?? [];

    return categories.where(
      (c) => c.name.toLowerCase().contains(textEditingValue.text.toLowerCase()),
    );
  }

  String? _validatorCategory(String? value, AppLocalizations t) {
    if (value == null || value.trim().isEmpty) {
      return t.defineCategory;
    }
    return null;
  }

  String? _validatorInstallment(String? value, AppLocalizations t) {
    if (value == null || value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _installmentController.text = '1';
      });
      return null;
    }
    if (int.tryParse(value) == null) return t.onlyNumbers;
    return null;
  }

  void _onChangedRecurring(bool value) {
    final tryParse = int.tryParse(_installmentController.text);

    return tryParse == null ||
            tryParse <= 1 ||
            _installmentController.text.isEmpty
        ? setState(() => _isRecurring = value)
        : null;
  }

  Future<void> _initTemplate(Transaction transaction) async {
    final template = await ref.read(
      transactionByIdProvider(transaction.templateId).future,
    );

    if (template == null || !mounted) return;

    setState(() {
      _template = template;
      _isRecurring = template.isRecurring;
    });
  }

  void _onTapCategory(Function(Category) onSelected, Category option) {
    onSelected(option);
    setState(() {
      _categoryHasColor = option.color != null;
      if (option.color != null) {
        _selectedColor = Color(int.parse(option.color!, radix: 16));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    double initDoubleValue = 0.0;

    _edit = widget.transaction != null;
    final transaction = widget.transaction;

    if (transaction != null) {
      final categoryColor = transaction.category.color;

      initDoubleValue = transaction.amount.abs();
      _categoryController.text = transaction.category.name;
      _selectedDate = transaction.date;
      _titleController.text = transaction.title;
      _installmentController.text = (transaction.totalInstallments ?? 1)
          .toString();
      _isIncome = transaction.amount >= 0.0;
      _descriptionController.text = transaction.description ?? '';
      if (categoryColor != null) {
        _selectedColor = Color(int.parse(categoryColor, radix: 16));
        _categoryHasColor = true;
      }

      if (transaction.templateId != null) {
        _initTemplate(transaction);
      }

      if (transaction.tags.isNotEmpty) {
        for (Tag tag in transaction.tags) {
          _tagsControllers.add(TextEditingController(text: tag.name));
        }
      }
    }

    _currency = ref.read(preferencesProvider).currencySymbol;

    _amountController = CurrencyTextFieldController(
      currencySymbol: _currency.symbol,
      decimalSymbol: _currency.locale == 'pt_BR' ? ',' : '.',
      thousandSymbol: _currency.locale == 'pt_BR' ? '.' : ',',
      initDoubleValue: initDoubleValue,
      numberOfDecimals: _currency.decimalDigits,
      showZeroValue: true,
      minValue: 0.0,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _categoryFocus.dispose();
    for (var c in _tagsControllers) {
      c.dispose();
    }
    _amountController.dispose();
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    final notifier = ref.read(preferencesProvider.notifier);

    notifier.setLastScreen(AppScreenEnum.form);

    if (_edit) {
      notifier.setLastTransactionDetailId(widget.transaction!.id!);
    }
  }

  @override
  void didPush() {
    final notifier = ref.read(preferencesProvider.notifier);

    notifier.setLastScreen(AppScreenEnum.form);

    if (_edit) {
      notifier.setLastTransactionDetailId(widget.transaction!.id!);
    }
  }

  @override
  void didPop() {
    final notifier = ref.read(preferencesProvider.notifier);

    notifier.setLastScreen(AppScreenEnum.home);

    if (_edit) {
      notifier.setLastTransactionDetailId(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final t = AppLocalizations.of(context)!;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final now = DateTime.now();
    final loading = ref.watch(loadingStateProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    final bool edit = widget.transaction != null;

    final String title = edit ? t.editTransaction : t.newTransaction;

    final iconThemeColor = Theme.of(context).iconTheme.color;
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => _return(),
              icon: const Icon(LucideIcons.chevronLeft),
            ),
            title: Text(title),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => _saveTransaction(t),
                icon: const Icon(LucideIcons.save),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(t.value, style: style),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: (0.0).toCurrency(
                                code: _currency.code,
                                locale: _currency.locale,
                              ),
                              error: _amountError == null
                                  ? null
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _amountError!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                            ),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (_) => _onChangedAmount(t),
                          ),
                          SegmentedButton<bool>(
                            showSelectedIcon: false,
                            style: SegmentedButton.styleFrom(
                              selectedBackgroundColor: _isIncome
                                  ? appColors.incomeBg
                                  : appColors.expenseBg,

                              selectedForegroundColor: _isIncome
                                  ? appColors.income
                                  : appColors.expense,
                            ),
                            selected: {_isIncome},
                            onSelectionChanged: (newSelection) =>
                                setState(() => _isIncome = newSelection.first),
                            segments: [
                              ButtonSegment(
                                value: false,
                                label: Text(t.expense),
                              ),
                              ButtonSegment(value: true, label: Text(t.income)),
                            ],
                          ),
                        ],
                      ),

                      const Divider(height: 32),

                      Column(
                        spacing: 8,
                        children: [
                          InputTextField(
                            label: t.title,
                            controller: _titleController,
                            hint: t.examplePurchase,
                            validator: (value) => _validatorTitle(value, t),
                          ),

                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(t.transactionDate),
                            subtitle: Text(
                              DateFormat.yMd(
                                myLocale.toString(),
                              ).format(_selectedDate),
                            ),
                            trailing: const Icon(LucideIcons.calendar),
                            onTap: () => _onTapSelectedDate(now, myLocale),
                          ),
                          InputTextField(
                            label: t.description,
                            controller: _descriptionController,
                            hint: t.exampleDescription,
                          ),

                          Autocomplete<Category>(
                            textEditingController: _categoryController,
                            focusNode: _categoryFocus,
                            displayStringForOption: (option) => option.name,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) =>
                                    _optionsBuilderCategory(
                                      textEditingValue,
                                      categoriesAsync,
                                    ),
                            optionsViewBuilder: (context, onSelected, options) {
                              return Material(
                                elevation: 4.0,
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 170,
                                  ),
                                  child: categoriesAsync.when(
                                    data: (_) {
                                      if (options.isEmpty) {
                                        return ListTile(
                                          title: Text(t.categoryNotFound),
                                        );
                                      }
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder: (context, index) {
                                          final option = options.elementAt(
                                            index,
                                          );
                                          return ListTile(
                                            title: Text(option.name),
                                            onTap: () => _onTapCategory(
                                              onSelected,
                                              option,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    loading: () => const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    error: (error, _) => ListTile(
                                      title: Text(error.toString()),
                                      leading: Icon(
                                        LucideIcons.circleAlert,
                                        color: appColors.expense,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            fieldViewBuilder:
                                (
                                  context,
                                  controller,
                                  focusNode,
                                  onFieldSubmitted,
                                ) {
                                  return InputTextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    label: t.category,
                                    hint: t.exampleMarket,
                                    onFieldSubmitted: (value) =>
                                        focusNode.unfocus(),
                                    validator: (value) =>
                                        _validatorCategory(value, t),
                                  );
                                },
                          ),

                          ColorPickerTile(
                            enabled: !_categoryHasColor,
                            selectedColor: _selectedColor,
                            onColorChanged: _onSelectedColor,
                          ),

                          InputTextField(
                            controller: _installmentController,
                            label: t.installments,
                            hint: t.exampleInstallments,
                            keyboardType: TextInputType.numberWithOptions(),
                            onChanged: (value) => setState(() {}),
                            sufixIcon: Icon(LucideIcons.x, size: 15,),
                            validator: (value) =>
                                _validatorInstallment(value, t),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(t.tags, style: style),
                              TextButton.icon(
                                onPressed: () => setState(
                                  () => _tagsControllers.add(
                                    TextEditingController(),
                                  ),
                                ),
                                icon: Icon(
                                  LucideIcons.plus,
                                  size: 18,
                                  color: iconThemeColor,
                                ),
                                label: Text(
                                  t.add,
                                  style: TextStyle(color: iconThemeColor),
                                ),
                              ),
                            ],
                          ),
                          if (_tagsControllers.isNotEmpty)
                            Container(
                              constraints: const BoxConstraints(maxHeight: 190),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: _tagsControllers.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) => InputTextField(
                                  controller: _tagsControllers[index],
                                  prefix: true,
                                  hint: t.tagPlaceholder(
                                    index > 0 ? index + 1 : '',
                                  ),
                                  sufixIcon: IconButton(
                                    icon: Icon(
                                      LucideIcons.circleMinus,
                                      color: appColors.expense,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() {
                                      _tagsControllers[index].dispose();
                                      _tagsControllers.removeAt(index);
                                    }),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const Divider(height: 32),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.recurrentTransaction),
                        secondary: const Icon(LucideIcons.refreshCw),
                        value: _isRecurring,
                        onChanged: (value) => _onChangedRecurring(value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (loading) ...[
          ModalBarrier(dismissible: false, color: Colors.black45),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}
