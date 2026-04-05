import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class AppNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(
      label: 'Send',
      icon: Icons.send_outlined,
      selectedIcon: Icons.send_rounded,
      route: AppRoutes.homeScreen,
    ),
    _NavItem(
      label: 'Compare',
      icon: Icons.compare_arrows_outlined,
      selectedIcon: Icons.compare_arrows_rounded,
      route: AppRoutes.routeComparisonScreen,
    ),
    _NavItem(
      label: 'History',
      icon: Icons.history_outlined,
      selectedIcon: Icons.history_rounded,
      route: AppRoutes.transferHistoryScreen,
    ),
    _NavItem(
      label: 'Alerts',
      icon: Icons.notifications_none_rounded,
      selectedIcon: Icons.notifications_rounded,
      route: AppRoutes.notificationsScreen,
    ),
    _NavItem(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      route: AppRoutes.settingsScreen,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    if (isTablet) {
      return NavigationRail(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        labelType: NavigationRailLabelType.all,
        backgroundColor: AppTheme.surface,
        indicatorColor: AppTheme.primaryContainer,
        selectedIconTheme: const IconThemeData(
          color: AppTheme.primary,
          size: 22,
        ),
        unselectedIconTheme: const IconThemeData(
          color: AppTheme.muted,
          size: 22,
        ),
        selectedLabelTextStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
        ),
        unselectedLabelTextStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppTheme.muted,
        ),
        destinations: _items
            .map(
              (item) => NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: Text(item.label),
              ),
            )
            .toList(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: AppTheme.surface,
        elevation: 0,
        destinations: _items
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });
}
