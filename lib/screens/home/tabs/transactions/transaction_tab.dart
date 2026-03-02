import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/tag_provider.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/screens/components/filter_actions_mixin.dart';
import 'package:pocket_vault/screens/components/transaction_tile.dart';
import 'package:pocket_vault/screens/home/tabs/transactions/widgets/filter_chip_item.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';
import 'package:pocket_vault/utils/transactions_extension.dart';

class TransactionTab extends ConsumerStatefulWidget {
  const TransactionTab({super.key});

  @override
  ConsumerState<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends ConsumerState<TransactionTab>
    with FilterActions {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final transactionsAsync = ref.watch(transactionListProvider);
    final titlesAsync = ref.watch(transactionTitlesProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    final tagsAsync = ref.watch(tagListProvider);
    final filter = ref.watch(transactionFilterProvider);

    final filterNotifier = ref.read(transactionFilterProvider.notifier);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SearchAnchor(
                isFullScreen: false,
                builder: (context, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        if (filter.tags.isEmpty && filter.titles.isEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                LucideIcons.search,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                              Text(
                                'Filtrar por nome ou tag...',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                        ...filter.titles.map((title) {
                          final isSelected = filter.titles.any(
                            (t) => t == title,
                          );
                          return FilterChipItem(
                            label: title,
                            isSelectable: false,
                            isSelected: isSelected,
                            onDeleted: () => filterNotifier.removeTitle(title),
                          );
                        }),
                        ...filter.tags.map((tag) {
                          final isSelected = filter.tags.any(
                            (t) => t.id == tag.id,
                          );
                          return FilterChipItem(
                            label: '#${tag.name}',
                            isSelectable: false,
                            isSelected: isSelected,
                            onDeleted: () => filterNotifier.removeTag(tag),
                          );
                        }),
                      ],
                    ),
                  );
                },
                suggestionsBuilder: (context, controller) {
                  final allTitles = titlesAsync.value ?? [];
                  final allTags = tagsAsync.value ?? [];

                  final allSuggestions = [...allTitles, ...allTags];

                  return allSuggestions
                      .where((element) {
                        if (element is Tag) {
                          return element.name.toLowerCase().contains(
                                controller.text.toLowerCase(),
                              ) &&
                              !filter.tags.contains(element);
                        }

                        return (element as String).toLowerCase().contains(
                              controller.text.toLowerCase(),
                            ) &&
                            !filter.titles.contains(element);
                      })
                      .map(
                        (element) => ListTile(
                          title: Text(
                            element is Tag
                                ? '#${element.name}'
                                : (element as String),
                          ),
                          onTap: () {
                            element is Tag
                                ? filterNotifier.addTag(element)
                                : filterNotifier.addTitle(element as String);
                            controller.clear();
                            controller.closeView(null);
                          },
                        ),
                      );
                },
              ),
            ),
            IconButton(
              onPressed: () => showFilterPicker(context),
              icon: Icon(LucideIcons.funnel),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          child: categoriesAsync.when(
            data: (categories) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  final isSelected = filter.categories.any(
                    (c) => c.id == category.id,
                  );

                  return FilterChipItem(
                    label: category.name,
                    isSelectable: true,
                    isSelected: isSelected,
                    onSelected: (bool selected) {
                      (selected)
                          ? filterNotifier.addCategory(category)
                          : filterNotifier.removeCategory(category);
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 10);
                },
              );
            },
            error: (error, stackTrace) {
              return Center(child: Text('Erro: $error'));
            },
            loading: () {
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
        Expanded(
          child: transactionsAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return const Center(
                  child: Text('Nenhuma transação no período'),
                );
              }

              final groupedByYear = transactions.groupByYearAndDate();
              final sortedYears = groupedByYear.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              return ListView.builder(
                itemCount: sortedYears.length,
                itemBuilder: (context, yearIndex) {
                  final year = sortedYears[yearIndex];
                  final datesInYear = groupedByYear[year]!;
                  final sortedDates = datesInYear.keys.toList()
                    ..sort((a, b) => b.compareTo(a));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),

                      ...sortedDates.map((date) {
                        final dayTransactions = datesInYear[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Text(
                                date.toHeaderFormat('$myLocale'),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),

                            ...dayTransactions.map(
                              (t) => TransactionTile(transaction: t),
                            ),
                            const Divider(height: 1),
                          ],
                        );
                      }),
                    ],
                  );
                },
              );
            },
            error: (error, stackTrace) {
              return Center(child: Text('Erro: $error'));
            },
            loading: () {
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
