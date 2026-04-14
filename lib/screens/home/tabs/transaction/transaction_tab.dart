import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/tag_provider.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/screens/components/build_marquee_text.dart';
import 'package:pocket_vault/screens/components/filter_actions_mixin.dart';
import 'package:pocket_vault/screens/components/transaction_tile.dart';
import 'package:pocket_vault/screens/home/tabs/transaction/widgets/filter_chip_item.dart';
import 'package:pocket_vault/theme/app_theme.dart';
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

  void _onTapTitleOrTag(Object element, SearchController controller) {
    final filterNotifier = ref.read(transactionFilterProvider.notifier);

    element is Tag
        ? filterNotifier.addTag(element)
        : filterNotifier.addTitle(element as String);
    controller.clear();
    controller.closeView(null);
  }

  Future<Iterable<ListTile>> _suggestionBuilderTitlesAndTags(
    SearchController controller,
  ) async {
    final filter = ref.read(transactionFilterProvider);
    final allTitles = await ref.read(transactionTitlesProvider.future);
    final allTags = await ref.read(tagListProvider.future);

    final allSuggestions = [...allTitles, ...allTags];

    final filtered = allSuggestions.where((element) {
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
    }).toList();

    return filtered.map(
      (element) => ListTile(
        title: BuildMarqueeText(
          text: element is Tag ? '#${element.name}' : (element as String),
        ),
        onTap: () => _onTapTitleOrTag(element, controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final myLocale = Localizations.localeOf(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    final transactionsAsync = ref.watch(transactionListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    final filter = ref.watch(transactionFilterProvider);

    final filterNotifier = ref.read(transactionFilterProvider.notifier);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SearchAnchor(
                isFullScreen: true,
                builder: (context, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: appColors.balanceCardSurface),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        if (filter.tags.isEmpty && filter.titles.isEmpty) ...[
                          Row(
                            spacing: 6,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(LucideIcons.search, size: 20),
                              Text(t.filterByNameOrTag),
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
                suggestionsBuilder: (context, controller) =>
                    _suggestionBuilderTitlesAndTags(controller),
              ),
            ),
            IconButton(
              onPressed: () => showFilterPicker(context),
              icon: const Icon(LucideIcons.funnel),
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
                    onSelected: (bool selected) => (selected)
                        ? filterNotifier.addCategory(category)
                        : filterNotifier.removeCategory(category),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 10);
                },
              );
            },
            error: (error, stackTrace) {
              return Center(child: Text('Erro: $error'));
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
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
                itemCount: sortedYears.length + 1,
                itemBuilder: (context, yearIndex) {
                  if (yearIndex == sortedYears.length) {
                    return const SizedBox(height: 25);
                  }

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
                                date.toShortDate(myLocale, t),
                                style: TextStyle(
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
            error: (error, _) {
              return Center(child: Text('Erro: $error'));
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
