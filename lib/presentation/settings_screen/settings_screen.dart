import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import './widgets/settings_account_widget.dart';
import './widgets/settings_notifications_widget.dart';
import './widgets/settings_preferences_widget.dart';
import './widgets/settings_profile_widget.dart';
import './widgets/settings_rate_alerts_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // TODO: Replace with Riverpod/Bloc for production
  int _currentNavIndex = 4;

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
    final routes = [
      AppRoutes.homeScreen,
      AppRoutes.routeComparisonScreen,
      AppRoutes.transferHistoryScreen,
      AppRoutes.notificationsScreen,
      AppRoutes.settingsScreen,
    ];
    if (index != 4) {
      if (index == 0) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeScreen,
          (route) => false,
        );
      } else {
        Navigator.pushNamed(context, routes[index]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      backgroundColor: AppTheme.background,
      bottomNavigationBar: isTablet
          ? null
          : AppNavigation(currentIndex: _currentNavIndex, onTap: _onNavTap),
      body: SafeArea(
        child: isTablet
            ? Row(
                children: [
                  AppNavigation(
                    currentIndex: _currentNavIndex,
                    onTap: _onNavTap,
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: _buildContent(isTablet)),
                ],
              )
            : _buildContent(isTablet),
      ),
    );
  }

  Widget _buildContent(bool isTablet) {
    final theme = Theme.of(context);
    Widget body = ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        const SettingsProfileWidget(),
        const SizedBox(height: 8),
        const SettingsPreferencesWidget(),
        const SizedBox(height: 8),
        const SettingsRateAlertsWidget(),
        const SizedBox(height: 8),
        const SettingsNotificationsWidget(),
        const SizedBox(height: 8),
        const SettingsAccountWidget(),
      ],
    );

    if (isTablet) {
      body = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: body,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppTheme.surface,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            children: [
              Text('Settings', style: theme.textTheme.headlineMedium),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Pro',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}
