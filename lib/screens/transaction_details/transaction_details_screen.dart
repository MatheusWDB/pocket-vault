import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/navigation/route_observer.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/transacation_form/transaction_form_screen.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class TransactionDetailsScreen extends ConsumerStatefulWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({required this.transaction, super.key});

  @override
  ConsumerState<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState
    extends ConsumerState<TransactionDetailsScreen>
    with RouteAware {
  late final Transaction transaction;

  void _return(BuildContext context, WidgetRef ref) {
    ref.read(preferencesProvider.notifier).setLastTransactionDetailId(null);

    Navigator.pop(context);
  }

  void _onPressedEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionFormScreen(transaction: transaction),
      ),
    );
  }

  void _onPressedDelete(BuildContext context, WidgetRef ref) {
    ref
        .read(transactionListProvider.notifier)
        .removeTransaction(transaction.id!);

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    final notifier = ref.read(preferencesProvider.notifier);

    notifier.setLastScreen(AppScreenEnum.details);
    notifier.setLastTransactionDetailId(transaction.id!);
  }

  @override
  void didPush() {
    final notifier = ref.read(preferencesProvider.notifier);

    notifier.setLastScreen(AppScreenEnum.details);
    notifier.setLastTransactionDetailId(transaction.id!);
  }

  @override
  void didPop() {
    final notifier = ref.read(preferencesProvider.notifier);

    notifier.setLastScreen(AppScreenEnum.home);
    notifier.setLastTransactionDetailId(null);
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final themePrimaryContainer = theme.colorScheme.primaryContainer;
    final currencySymbol = ref.watch(preferencesProvider).currencySymbol;

    final String amountText = transaction.amount.toCurrency(
      code: currencySymbol.code,
      locale: currencySymbol.locale,
    );
    final String categoryText = transaction.category.name;
    final String dateText = transaction.date.toDateTime(myLocale);

    final tags = transaction.tags;

    final buttonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    final borderRadius = BorderRadius.circular(16);

    final spacing = SizedBox(height: 20);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _return(context, ref),
          icon: const Icon(LucideIcons.chevronLeft),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(
            children: [
              Column(
                spacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: themePrimaryContainer,
                      borderRadius: borderRadius,
                    ),
                    child: const Icon(LucideIcons.receiptText, size: 50),
                  ),

                  Text(
                    transaction.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    amountText,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: themePrimaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categoryText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              spacing,

              Row(
                spacing: 16,
                children: [
                  Icon(LucideIcons.clock),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('Data'), Text(dateText)],
                  ),
                ],
              ),

              spacing,

              if (tags.isNotEmpty)
                Row(
                  spacing: 16,
                  children: [
                    Icon(LucideIcons.tag),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tags.length > 1 ? 'Tags' : 'Tag'),
                          SizedBox(
                            height: 50,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: tags.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final tag = tags[index];

                                return Text(
                                  '#${tag.name}',
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              if (transaction.description != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: borderRadius,
                  ),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Descrição',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '"${transaction.description!}"',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),

              Expanded(child: SizedBox.shrink()),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () => _onPressedEdit(context),
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(LucideIcons.pencil),
                        Text('Editar'),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () => _onPressedDelete(context, ref),
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(LucideIcons.trash2),
                        Text('Excluir'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
