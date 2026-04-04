import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/screens/home/widgets/build_item.dart';

class MyCustomBottomAppBar extends StatelessWidget {
  final int activeIndex;
  final Function(int) onDestinationSelected;

  const MyCustomBottomAppBar({
    required this.activeIndex,
    required this.onDestinationSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 40.0,
        children: [
          Row(
            spacing: 20.0,
            children: [
              BuildItem(
                activeIndex: activeIndex,
                onDestinationSelected: onDestinationSelected,
                icon: LucideIcons.layoutDashboard,
                index: 0,
                context: context,
              ),
              BuildItem(
                activeIndex: activeIndex,
                onDestinationSelected: onDestinationSelected,
                icon: LucideIcons.receiptText,
                index: 1,
                context: context,
              ),
            ],
          ),

          Row(
            spacing: 20.0,
            children: [
              BuildItem(
                activeIndex: activeIndex,
                onDestinationSelected: onDestinationSelected,
                icon: LucideIcons.target,
                index: 2,
                context: context,
              ),
              BuildItem(
                activeIndex: activeIndex,
                onDestinationSelected: onDestinationSelected,
                icon: LucideIcons.chartPie,
                index: 3,
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
