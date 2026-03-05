import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionformscreenState();
}

class _TransactionformscreenState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryFocus = FocusNode();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<TextEditingController> _tagsControllers = [];
  late final CurrencyTextFieldController _amountController;
  late DateTime _selectedDate;
  bool _isRevenue = false;
  bool _isRecurring = false;

  String? _amountError;

  final now = DateTime.now();
  late final CurrencySymbolEnum _currency;

  Widget _buildInputField({
    required TextEditingController controller,
    String? label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? sufixIcon,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    bool prefix = false,
    Function(String)? onChanged,
    Function()? onTap,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    Function(String)? onFieldSubmitted,
  }) {
    return Column(
      spacing: 6,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (label != null)
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            hintText: hint,
            suffixIcon: sufixIcon,
            prefixIcon: prefix ? const Icon(LucideIcons.tag, size: 20) : null,
          ),
          keyboardType: keyboardType,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          onTap: onTap,
          validator: validator,
        ),
      ],
    );
  }

  Future<void> _saveTransaction(TransactionList notifier) async {
    if (!_formKey.currentState!.validate()) return;
    if (_amountError != null) return;

    final title = _titleController.text;
    final amount = _amountController.doubleValue;
    final descripition = _descriptionController.text;

    final category = Category(name: _categoryController.text.trim());
    final List<Tag> tags = _tagsControllers
        .where((c) => c.text.trim().isNotEmpty)
        .map((c) => Tag(name: c.text.trim()))
        .toList();

    final newTrasaction = Transaction(
      title: title,
      amount: _isRevenue ? amount : -amount,
      date: _selectedDate,
      category: category,
      isRecurring: _isRecurring,
      description: descripition.isNotEmpty ? descripition : null,
      tags: tags,
    );

    try {
      await notifier.addTransaction(newTrasaction);

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }
  }

  @override
  void initState() {
    super.initState();

    _selectedDate = now;

    _currency = ref.read(preferencesProvider).currencySymbol;

    _amountController = CurrencyTextFieldController(
      currencySymbol: _currency.symbol,
      decimalSymbol: _currency.locale == 'pt_BR' ? ',' : '.',
      thousandSymbol: _currency.locale == 'pt_BR' ? '.' : ',',
      initDoubleValue: 0.0,
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final now = DateTime.now();
    final transactionNotifier = ref.read(transactionListProvider.notifier);
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LucideIcons.chevronLeft),
        ),
        title: const Text('Nova Transação'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _saveTransaction(transactionNotifier),
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
                      const Text(
                        'Valor',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) {
                          if (_amountError != null &&
                              _amountController.doubleValue > 0) {
                            setState(() => _amountError = null);
                          }
                        },
                        validator: (_) {
                          setState(() {
                            if (_amountController.doubleValue <= 0) {
                              _amountError = 'O valor deve ser maior que zero';
                            } else {
                              _amountError = null;
                            }
                          });

                          return null;
                        },
                      ),
                      SegmentedButton<bool>(
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          selectedForegroundColor: _isRevenue
                              ? Colors.green
                              : Colors.red,
                        ),
                        selected: {_isRevenue},
                        onSelectionChanged: (newSelection) {
                          setState(() => _isRevenue = newSelection.first);
                        },
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
                      _buildInputField(
                        label: 'Título',
                        controller: _titleController,
                        hint: 'Ex: Compras 01/01/2026',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Insira um título';
                          }
                          return null;
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(LucideIcons.calendar),
                        title: const Text('Data da Transação'),
                        subtitle: Text(
                          DateFormat.yMd(
                            myLocale.toString(),
                          ).format(_selectedDate),
                        ),
                        trailing: const Icon(LucideIcons.pencil, size: 20),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(now.year, now.month + 1, 0),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            locale: myLocale,
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                      ),

                      _buildInputField(
                        label: 'Descrição',
                        controller: _descriptionController,
                        hint: 'Ex: Compras do mês pago no cartão',
                      ),
                      Autocomplete<Category>(
                        textEditingController: _categoryController,
                        focusNode: _categoryFocus,
                        displayStringForOption: (option) => option.name,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Category>.empty();
                          }

                          final categories = categoriesAsync.value ?? [];

                          return categories.where(
                            (c) => c.name.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            ),
                          );
                        },
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
                                  leading: const Icon(
                                    LucideIcons.circleAlert,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                              return _buildInputField(
                                controller: controller,
                                focusNode: focusNode,
                                label: 'Categoria',
                                hint: 'Ex: Mercado',
                                onFieldSubmitted: (value) {
                                  focusNode.unfocus();
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Defina uma categoria';
                                  }
                                  return null;
                                },
                              );
                            },
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tags',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: () => setState(
                              () =>
                                  _tagsControllers.add(TextEditingController()),
                            ),
                            icon: const Icon(LucideIcons.plus, size: 18),
                            label: const Text('Add'),
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
                            itemBuilder: (context, index) => _buildInputField(
                              controller: _tagsControllers[index],
                              prefix: true,
                              hint: 'Tag${index > 0 ? index + 1 : ''}...',
                              sufixIcon: IconButton(
                                icon: const Icon(
                                  LucideIcons.circleMinus,
                                  color: Colors.red,
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
                    onChanged: (value) => setState(() => _isRecurring = value),
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
