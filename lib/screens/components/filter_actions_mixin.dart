import 'package:flutter/material.dart';
import 'package:pocket_vault/screens/components/month_year_picker_modal.dart';

mixin FilterActions {
  void showFilterPicker(BuildContext context, {bool showAllYearsOption = true}) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) => MonthYearPickerModal(showAllYearsOption: showAllYearsOption),
    );
  }
}
