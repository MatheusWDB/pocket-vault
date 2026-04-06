import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/navigation/route_observer.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/transacation_form/widgets/build_input_field.dart';
import 'package:pocket_vault/theme/app_theme.dart';
import 'package:pocket_vault/utils/double_extensions.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;
  const TransactionFormScreen({this.transaction, super.key});

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionformscreenState();
}

class _TransactionformscreenState extends ConsumerState<TransactionFormScreen>
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
  bool _isRevenue = false;
  bool _isRecurring = false;
  String? _amountError;
  Color? _selectedColor;
  late final CurrencySymbolEnum _currency;
  late final bool edit;

  void _return() {
    Navigator.pop(context);
  }

  void _onChangedAmount() {
    if (_amountError != null && _amountController.doubleValue > 0) {
      setState(() => _amountError = null);
    }
  }

  Null _validatorAmount() {
    setState(() {
      _amountError = (_amountController.doubleValue <= 0)
          ? 'O valor deve ser maior que zero'
          : null;
    });

    return null;
  }

  String? _validatorTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Insira um título';
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

  Future<void> _onTapSelectedColor() async {
    Color currentColor = Colors.red[50]!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolher cor'),
        contentPadding: const EdgeInsets.all(0),
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: _selectedColor ?? currentColor,
            onColorChanged: (color) => setState(() => currentColor = color),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _onResetSelectedColor(),
            child: const Text('Redefinir'),
          ),
          TextButton(
            onPressed: () => _onConfirmSelectedColor(currentColor),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _onConfirmSelectedColor(Color? currentColor) {
    setState(() => _selectedColor = currentColor);
    Navigator.pop(context);
  }

  void _onResetSelectedColor() {
    setState(() => _selectedColor = null);
    Navigator.pop(context);
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_amountError != null) return;

    final title = _titleController.text;
    final amount = _amountController.doubleValue;
    final descripition = _descriptionController.text;
    final totalInstallments = int.tryParse(_installmentController.text) ?? 1;

    final category = Category(
      name: _categoryController.text.trim(),
      color: _selectedColor?.toHexString(),
    );

    final List<Tag> tags = _tagsControllers
        .where((c) => c.text.trim().isNotEmpty)
        .map((c) => Tag(name: c.text.trim()))
        .toList();

    final transactionToSave = edit
        ? widget.transaction!.copyWith(
            title: title,
            amount: _isRevenue ? amount : -amount,
            date: _selectedDate,
            category: category,
            totalInstallments: totalInstallments,
            currentInstallment: totalInstallments > 1 ? null : 1,
            isRecurring: _isRecurring,
            isTemplate: _isRecurring || totalInstallments > 1,
            description: descripition.isNotEmpty ? descripition : null,
            tags: tags,
          )
        : Transaction(
            title: title,
            amount: _isRevenue ? amount : -amount,
            date: _selectedDate,
            category: category,
            totalInstallments: totalInstallments,
            currentInstallment: totalInstallments > 1 ? null : 1,
            isRecurring: _isRecurring,
            isTemplate: _isRecurring || totalInstallments > 1,
            description: descripition.isNotEmpty ? descripition : null,
            tags: tags,
          );

    try {
      final notifier = ref.read(transactionListProvider.notifier);

      await notifier.saveTransaction(transactionToSave, creating: !edit);

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }
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

  String? _validatorCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Defina uma categoria';
    }
    return null;
  }

  String? _validatorInstallment(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        value = '1';
      });
    }

    final installment = int.tryParse(value!);

    if (installment == null) {
      return 'Somente números';
    }

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

  @override
  void initState() {
    super.initState();

    edit = widget.transaction != null;

    double initDoubleValue = 0.0;

    if (widget.transaction != null) {
      final transaction = widget.transaction;

      initDoubleValue = transaction!.amount.abs();
      _categoryController.text = transaction.category.name;
      _selectedDate = transaction.date;
      _titleController.text = transaction.title;
      _installmentController.text = transaction.totalInstallments.toString();
      _isRevenue = transaction.amount >= 0.0;
      _descriptionController.text = transaction.description ?? '';

      final templateId = widget.transaction!.templateId;

      if (templateId != null) {
        final template = ref
            .read(transactionByIdProvider(id: templateId))
            .value;

        if (template != null) _isRecurring = template.isRecurring;
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

    if (edit) {
      notifier.setLastTransactionDetailId(widget.transaction!.id!);
    }
  }

  @override
  void didPush() {
    final notifier = ref.read(preferencesProvider.notifier);

    notifier.setLastScreen(AppScreenEnum.form);

    if (edit) {
      notifier.setLastTransactionDetailId(widget.transaction!.id!);
    }
  }

  @override
  void didPop() {
    final notifier = ref.read(preferencesProvider.notifier);

    notifier.setLastScreen(AppScreenEnum.home);

    if (edit) {
      notifier.setLastTransactionDetailId(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    final now = DateTime.now();
    final categoriesAsync = ref.watch(categoryListProvider);

    final bool edit = widget.transaction != null;

    final String title = edit ? 'Editar Transação' : 'Nova Transação';

    final iconThemeColor = Theme.of(context).iconTheme.color;
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _return(),
          icon: const Icon(LucideIcons.chevronLeft),
        ),
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _saveTransaction(),
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
                      Text('Valor', style: style),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                        onChanged: (_) => _onChangedAmount(),
                        validator: (_) => _validatorAmount(),
                      ),
                      SegmentedButton<bool>(
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          selectedBackgroundColor: _isRevenue
                              ? appColors.incomeBg
                              : appColors.expenseBg,

                          selectedForegroundColor: _isRevenue
                              ? appColors.income
                              : appColors.expense,
                        ),
                        selected: {_isRevenue},
                        onSelectionChanged: (newSelection) =>
                            setState(() => _isRevenue = newSelection.first),
                        segments: const [
                          ButtonSegment(value: false, label: Text('Despesa')),
                          ButtonSegment(value: true, label: Text('Receita')),
                        ],
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  Column(
                    spacing: 8,
                    children: [
                      BuildInputField(
                        label: 'Título',
                        controller: _titleController,
                        hint: 'Ex: Compras 01/01/2026',
                        validator: (value) => _validatorTitle(value),
                      ),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Data da Transação'),
                        subtitle: Text(
                          DateFormat.yMd(
                            myLocale.toString(),
                          ).format(_selectedDate),
                        ),
                        trailing: const Icon(LucideIcons.calendar),
                        onTap: () => _onTapSelectedDate(now, myLocale),
                      ),
                      BuildInputField(
                        label: 'Descrição',
                        controller: _descriptionController,
                        hint: 'Ex: Compras do mês pago no cartão',
                      ),

                      Autocomplete<Category>(
                        textEditingController: _categoryController,
                        focusNode: _categoryFocus,
                        displayStringForOption: (option) => option.name,
                        optionsBuilder: (TextEditingValue textEditingValue) =>
                            _optionsBuilderCategory(
                              textEditingValue,
                              categoriesAsync,
                            ),
                        optionsViewBuilder: (context, onSelected, options) {
                          return Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 170),
                              child: categoriesAsync.when(
                                data: (_) {
                                  if (options.isEmpty) {
                                    return const ListTile(
                                      title: Text(
                                        'Nenhuma categoria encontrada',
                                      ),
                                    );
                                  }
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final option = options.elementAt(index);
                                      return ListTile(
                                        title: Text(option.name),
                                        onTap: () => onSelected(option),
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
                                  title: Text('Erro: $error'),
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
                            (context, controller, focusNode, onFieldSubmitted) {
                              return BuildInputField(
                                controller: controller,
                                focusNode: focusNode,
                                label: 'Categoria',
                                hint: 'Ex: Mercado',
                                onFieldSubmitted: (value) =>
                                    focusNode.unfocus(),
                                validator: (value) => _validatorCategory(value),
                              );
                            },
                      ),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Cor de Categoria'),
                        subtitle: _selectedColor != null
                            ? Text(_selectedColor!.toHexString())
                            : null,
                        trailing: Icon(
                          LucideIcons.palette,
                          color: _selectedColor,
                        ),
                        onTap: () => _onTapSelectedColor(),
                      ),

                      BuildInputField(
                        controller: _installmentController,
                        label: 'Parcelas',
                        hint: 'Ex: 12',
                        keyboardType: TextInputType.numberWithOptions(),
                        onChanged: (value) => setState(() {}),
                        sufixIcon: Text('x'),
                        validator: (value) => _validatorInstallment(value),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tags', style: style),
                          TextButton.icon(
                            onPressed: () => setState(
                              () =>
                                  _tagsControllers.add(TextEditingController()),
                            ),
                            icon: Icon(
                              LucideIcons.plus,
                              size: 18,
                              color: iconThemeColor,
                            ),
                            label: Text(
                              'Add',
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
                            itemBuilder: (context, index) => BuildInputField(
                              controller: _tagsControllers[index],
                              prefix: true,
                              hint: 'Tag${index > 0 ? index + 1 : ''}...',
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
                    title: const Text('Transação Recorrente'),
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
    );
  }
}
