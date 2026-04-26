import 'package:flutter/material.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/screens/home/home_screen.dart';
import 'package:pocket_vault/screens/home/tabs/budget/budget_tab.dart';
import 'package:pocket_vault/screens/home/tabs/dashboard/dashboard_tab.dart';
import 'package:pocket_vault/screens/home/tabs/report/report_tab.dart';
import 'package:pocket_vault/screens/home/tabs/transaction/transaction_tab.dart';
import 'package:pocket_vault/screens/settings/settings_screen.dart';
import 'package:pocket_vault/screens/transaction_form/transaction_form_screen.dart';
import 'package:pocket_vault/screens/transaction_details/transaction_details_screen.dart';

enum AppScreenEnum {
  home,
  settings,
  form,
  details;

  Widget toScreen([Transaction? transaction]) {
    return switch (this) {
      AppScreenEnum.home => HomeScreen(),
      AppScreenEnum.settings => SettingsScreen(),
      AppScreenEnum.form => TransactionFormScreen(transaction: transaction),
      AppScreenEnum.details =>
        transaction != null
            ? TransactionDetailsScreen(transaction: transaction)
            : HomeScreen(),
    };
  }
}

enum AppTabEnum {
  dashboard,
  transactions,
  budgets,
  reports;

  Widget toTab() {
    return switch (this) {
      AppTabEnum.dashboard => DashboardTab(),
      AppTabEnum.budgets => BudgetTab(),
      AppTabEnum.transactions => TransactionTab(),
      AppTabEnum.reports => ReportTab(),
    };
  }
}
