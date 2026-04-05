import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import './widgets/delivery_timeline_widget.dart';
import './widgets/detail_header_widget.dart';
import './widgets/fee_breakdown_widget.dart';
import './widgets/provider_info_widget.dart';
import './widgets/rate_comparison_widget.dart';
import './widgets/step_by_step_flow_widget.dart';

class RouteDetailScreen extends StatefulWidget {
  const RouteDetailScreen({super.key});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen>
    with SingleTickerProviderStateMixin {
  int _currentNavIndex = 1;
  bool _isRedirecting = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
    final routes = [
      AppRoutes.homeScreen,
      AppRoutes.routeComparisonScreen,
      AppRoutes.transferHistoryScreen,
      AppRoutes.notificationsScreen,
      AppRoutes.settingsScreen,
    ];
    if (index != 1) {
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

  Future<void> _continueWithProvider(String provider) async {
    setState(() => _isRedirecting = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isRedirecting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Redirecting to $provider...'),
        backgroundColor: AppTheme.onSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final route =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final provider = route?['provider'] as String? ?? 'Wise';
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
                  Expanded(
                    child: _buildBody(context, route, provider, isTablet),
                  ),
                ],
              )
            : _buildBody(context, route, provider, isTablet),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    Map<String, dynamic>? route,
    String provider,
    bool isTablet,
  ) {
    return Column(
      children: [
        Expanded(
          child: isTablet
              ? _buildTabletLayout(route, provider)
              : _buildPhoneLayout(route, provider),
        ),
        _buildStickyCtaBar(provider, route),
      ],
    );
  }

  Widget _buildPhoneLayout(Map<String, dynamic>? route, String provider) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          backgroundColor: AppTheme.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          pinned: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_rounded, color: AppTheme.onSurface),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              Text(
                'Route Details',
                style: const TextStyle(fontSize: 12, color: AppTheme.muted),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                final provider =
                    route?['provider'] as String? ?? 'this provider';
                final recipientAmount =
                    (route?['recipientAmount'] as num?)?.toDouble() ?? 0.0;
                final recipientCurrency =
                    route?['recipientCurrency'] as String? ?? '';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Route shared: $provider · $recipientCurrency ${recipientAmount.toStringAsFixed(2)}',
                    ),
                    backgroundColor: AppTheme.onSurface,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(
                Icons.ios_share_rounded,
                color: AppTheme.onSurface,
                size: 22,
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.muted,
            indicatorColor: AppTheme.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Step-by-Step'),
            ],
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [
          // Overview tab
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                DetailHeaderWidget(route: route),
                const SizedBox(height: 8),
                _RecommendedReasonWidget(route: route),
                const SizedBox(height: 8),
                RateComparisonWidget(route: route),
                const SizedBox(height: 8),
                FeeBreakdownWidget(route: route),
                const SizedBox(height: 8),
                DeliveryTimelineWidget(route: route),
                const SizedBox(height: 8),
                ProviderInfoWidget(route: route),
              ],
            ),
          ),
          // Step-by-step tab
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(children: [StepByStepFlowWidget(route: route)]),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(Map<String, dynamic>? route, String provider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DetailHeaderWidget(route: route),
                const SizedBox(height: 12),
                _RecommendedReasonWidget(route: route),
                const SizedBox(height: 12),
                RateComparisonWidget(route: route),
                const SizedBox(height: 12),
                ProviderInfoWidget(route: route),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StepByStepFlowWidget(route: route),
                const SizedBox(height: 12),
                FeeBreakdownWidget(route: route),
                const SizedBox(height: 12),
                DeliveryTimelineWidget(route: route),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStickyCtaBar(String provider, Map<String, dynamic>? route) {
    final recipientAmount =
        (route?['recipientAmount'] as num?)?.toDouble() ?? 0.0;
    final recipientCurrency = route?['recipientCurrency'] as String? ?? '';
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 13,
                    color: AppTheme.muted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Complete transfer on $provider',
                    style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                  ),
                ],
              ),
              if (recipientAmount > 0)
                Text(
                  '$recipientCurrency ${recipientAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _isRedirecting
                  ? null
                  : () => _continueWithProvider(provider),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: _isRedirecting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                _isRedirecting ? 'Redirecting...' : 'Continue with $provider',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedReasonWidget extends StatelessWidget {
  final Map<String, dynamic>? route;
  const _RecommendedReasonWidget({required this.route});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rankingReason = route?['rankingReason'] as String? ?? '';
    final badgeType = route?['badgeType'] as String? ?? 'bank';
    if (rankingReason.isEmpty) return const SizedBox.shrink();

    Color color;
    IconData icon;
    switch (badgeType) {
      case 'recommended':
        color = AppTheme.primary;
        icon = Icons.star_rounded;
        break;
      case 'cheapest':
        color = AppTheme.secondary;
        icon = Icons.savings_rounded;
        break;
      case 'fastest':
        color = const Color(0xFF7C3AED);
        icon = Icons.bolt_rounded;
        break;
      default:
        color = AppTheme.muted;
        icon = Icons.info_outline_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why this route?',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rankingReason,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
