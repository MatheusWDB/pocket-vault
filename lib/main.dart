import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pocket_vault/app.dart';
import 'package:pocket_vault/data/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();
  await DatabaseHelper.instance.database;

  runApp(const ProviderScope(child: MyApp()));
}

