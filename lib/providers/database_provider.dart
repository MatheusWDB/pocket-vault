// lib/providers/database_provider.dart
import 'package:pocket_vault/data/database_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
DatabaseHelper databaseHelper(Ref _) => DatabaseHelper.instance;
