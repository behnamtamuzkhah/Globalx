import 'package:flutter/material.dart';

import '../presentation/home_screen/home_screen.dart';
import '../presentation/route_comparison_screen/route_comparison_screen.dart';
import '../presentation/route_detail_screen/route_detail_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/transfer_history_screen/transfer_history_screen.dart';
import '../presentation/edit_profile_screen/edit_profile_screen.dart';
import '../presentation/notifications_screen/notifications_screen.dart';
import '../presentation/saved_routes_screen/saved_routes_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String homeScreen = '/home-screen';
  static const String routeComparisonScreen = '/route-comparison-screen';
  static const String routeDetailScreen = '/route-detail-screen';
  static const String transferHistoryScreen = '/transfer-history-screen';
  static const String settingsScreen = '/settings-screen';
  static const String editProfileScreen = '/edit-profile-screen';
  static const String notificationsScreen = '/notifications-screen';
  static const String savedRoutesScreen = '/saved-routes-screen';

  // Keep routes map for compatibility
  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    homeScreen: (context) => const HomeScreen(),
    routeComparisonScreen: (context) => const RouteComparisonScreen(),
    routeDetailScreen: (context) => const RouteDetailScreen(),
    transferHistoryScreen: (context) => const TransferHistoryScreen(),
    settingsScreen: (context) => const SettingsScreen(),
    editProfileScreen: (context) => const EditProfileScreen(),
    notificationsScreen: (context) => const NotificationsScreen(),
    savedRoutesScreen: (context) => const SavedRoutesScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case initial:
      case homeScreen:
        page = const HomeScreen();
        break;
      case routeComparisonScreen:
        page = const RouteComparisonScreen();
        break;
      case routeDetailScreen:
        page = const RouteDetailScreen();
        break;
      case transferHistoryScreen:
        page = const TransferHistoryScreen();
        break;
      case settingsScreen:
        page = const SettingsScreen();
        break;
      case editProfileScreen:
        page = const EditProfileScreen();
        break;
      case notificationsScreen:
        page = const NotificationsScreen();
        break;
      case savedRoutesScreen:
        page = const SavedRoutesScreen();
        break;
      default:
        page = const HomeScreen();
    }

    // Slide + fade transition
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.06, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        final slideTween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        final fadeTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }
}
