import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_filter_provider.g.dart';

typedef TransactionFilters = ({
  List<String> titles,
  List<Category> categories,
  List<Tag> tags,
  DateTime? start,
  DateTime? end,
});

@Riverpod(keepAlive: true)
class TransactionFilter extends _$TransactionFilter {
  @override
  TransactionFilters build() {
    final now = DateTime.now();

    return (
      titles: [],
      categories: [],
      tags: [],
      start: DateTime(now.year, now.month),
      end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
    );
  }

  void addTitle(String title) {
    if (!state.titles.contains(title)) {
      state = (
        titles: [...state.titles, title],
        categories: state.categories,
        tags: state.tags,
        start: state.start,
        end: state.end,
      );
    }
  }

  void removeTitle(String title) {
    state = (
      titles: state.titles.where((t) => t != title).toList(),
      categories: state.categories,
      tags: state.tags,
      start: state.start,
      end: state.end,
    );
  }

  void addCategory(Category category) {
    final exists = state.categories.any((c) => c.id == category.id);

    if (!exists) {
      state = (
        titles: state.titles,
        categories: [...state.categories, category],
        tags: state.tags,
        start: state.start,
        end: state.end,
      );
    }
  }

  void removeCategory(Category category) {
    state = (
      titles: state.titles,
      categories: state.categories.where((c) => c.id! != category.id!).toList(),
      tags: state.tags,
      start: state.start,
      end: state.end,
    );
  }

  void addTag(Tag tag) {
    final exists = state.tags.any((t) => t.id == tag.id);

    if (!exists) {
      state = (
        titles: state.titles,
        categories: state.categories,
        tags: [...state.tags, tag],
        start: state.start,
        end: state.end,
      );
    }
  }

  void removeTag(Tag tag) {
    state = (
      titles: state.titles,
      categories: state.categories,
      tags: state.tags.where((t) => t.id! != tag.id!).toList(),
      start: state.start,
      end: state.end,
    );
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = (
      titles: state.titles,
      categories: state.categories,
      tags: state.tags,
      start: start,
      end: end,
    );
  }

  void clearDateRange() {
    state = (
      titles: state.titles,
      categories: state.categories,
      tags: state.tags,
      start: null,
      end: null,
    );
  }

  void standardFilter() {
    final now = DateTime.now();

    state = (
      titles: [],
      categories: [],
      tags: [],
      start: DateTime(now.year, now.month),
      end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
    );
  }

  void clear() {
    state = (titles: [], categories: [], tags: [], start: null, end: null);
  }
}
