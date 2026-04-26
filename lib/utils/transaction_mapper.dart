import 'package:pocket_vault/models/transaction.dart';

abstract final class TransactionMapper {
  static List<Transaction> fromRows(List<Map<String, dynamic>> rows) {
    final Map<int, Map<String, dynamic>> grouped = {};

    for (final row in rows) {
      final id = row['id'] as int;

      grouped.putIfAbsent(
        id,
        () => {
          'id': id,
          'title': row['title'],
          'amount': row['amount'],
          'date': row['date'],
          'description': row['description'],
          'isRecurring': row['isRecurring'],
          'isTemplate': row['isTemplate'],
          'templateId': row['templateId'],
          'totalInstallments': row['totalInstallments'],
          'currentInstallment': row['currentInstallment'],
          'lastGeneratedMonth': row['lastGeneratedMonth'],
          'createdAt': row['createdAt'],
          'updatedAt': row['updatedAt'],
          'category': {
            'id': row['categoryId'],
            'name': row['category_name'],
            'budgetLimit': row['category_budgetLimit'],
            'color': row['category_color'],
            'createdAt': row['category_created_at'],
          },
          'tags': <Map<String, dynamic>>[],
        },
      );

      if (row['tag_id'] != null) {
        (grouped[id]!['tags'] as List<Map<String, dynamic>>).add({
          'id': row['tag_id'],
          'name': row['tag_name'],
        });
      }
    }

    return grouped.values.map(Transaction.fromMap).toList();
  }
}
