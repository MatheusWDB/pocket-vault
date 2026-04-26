import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/screens/home/widgets/navbar_item.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int activeIndex;
  final Function(int) onDestinationSelected;

  const CustomBottomAppBar({
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
              NavBarItem(
                activeIndex: activeIndex,
                onDestinationSelected: onDestinationSelected,
                icon: LucideIcons.layoutDashboard,
                index: 0,
              ),
              NavBarItem(
                activeIndex: activeIndex,
                onDestinationSelected: onDestinationSelected,
                icon: LucideIcons.receiptText,
                index: 1,
              ),
            ],
          ),

          Row(
            spacing: 20.0,
            children: [
              NavBarItem(
                activeIndex: activeIndex,
                onDestinationSelected: onDestinationSelected,
                icon: LucideIcons.target,
                index: 2,
              ),
              NavBarItem(
                activeIndex: activeIndex,
                onDestinationSelected: onDestinationSelected,
                icon: LucideIcons.chartPie,
                index: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
