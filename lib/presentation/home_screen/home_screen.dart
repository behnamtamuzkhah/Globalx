import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import './widgets/hero_section_widget.dart';
import './widgets/home_header_widget.dart';
import './widgets/how_it_works_widget.dart';
import './widgets/quick_sections_widget.dart';
import './widgets/rate_ticker_widget.dart';
import './widgets/recent_transfers_widget.dart';
import './widgets/transfer_form_widget.dart';
import './widgets/trust_compliance_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
    final routes = [
      AppRoutes.homeScreen,
      AppRoutes.routeComparisonScreen,
      AppRoutes.transferHistoryScreen,
      AppRoutes.notificationsScreen,
      AppRoutes.settingsScreen,
    ];
    if (index != 0) {
      Navigator.pushNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.background,
      bottomNavigationBar: AppNavigation(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
      body: SafeArea(
        child: isTablet
            ? Row(
                children: [
                  AppNavigation(
                    currentIndex: _currentNavIndex,
                    onTap: _onNavTap,
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: _buildBody(isTablet)),
                ],
              )
            : _buildBody(isTablet),
      ),
    );
  }

  Widget _buildBody(bool isTablet) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: const HomeHeaderWidget()),
        SliverToBoxAdapter(child: const HeroSectionWidget()),
        SliverToBoxAdapter(child: const RateTickerWidget()),
        SliverToBoxAdapter(
          child: isTablet
              ? Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: const TransferFormWidget(),
                  ),
                )
              : const TransferFormWidget(),
        ),
        SliverToBoxAdapter(child: const HowItWorksWidget()),
        SliverToBoxAdapter(child: const QuickSectionsWidget()),
        SliverToBoxAdapter(child: const RecentTransfersWidget()),
        SliverToBoxAdapter(child: const TrustComplianceWidget()),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
