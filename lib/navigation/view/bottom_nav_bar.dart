import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final navigationBarItems = mainNavigationBarItems(
      homeLabel: l10n.homeNavBarItemLabel,
      searchLabel: l10n.searchNavBarItemLabel,
      createMediaLabel: l10n.createMediaNavBarItemLabel,
      reelsLabel: l10n.reelsNavBarItemLabel,
      userProfileLabel: l10n.profileNavBarItemLabel,
      userProfileAvatar: const Icon(Icons.person),
    );
    return BottomNavigationBar(
      iconSize: 28,
      items: navigationBarItems
          .map(
            (e) => BottomNavigationBarItem(
              icon: e.child ?? Icon(e.icon),
              label: e.label,
              tooltip: e.tooltip,
            ),
          )
          .toList(),
      currentIndex: navigationShell.currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == 2) {
        } else {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        }
      },
    );
  }
}
