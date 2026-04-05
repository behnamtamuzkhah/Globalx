import '../../core/app_export.dart';
import '../../data/currencies_data.dart';
import '../../data/route_engine.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_empty_state_widget.dart';
import '../../widgets/animated_error_widget.dart';
import '../../widgets/app_navigation.dart';
import './widgets/comparison_header_widget.dart';
import './widgets/route_card_widget.dart';
import './widgets/savings_banner_widget.dart';

class RouteComparisonScreen extends StatefulWidget {
  const RouteComparisonScreen({super.key});

  @override
  State<RouteComparisonScreen> createState() => _RouteComparisonScreenState();
}

class _RouteComparisonScreenState extends State<RouteComparisonScreen>
    with TickerProviderStateMixin {
  int _currentNavIndex = 1;
  String _selectedFilter = 'All';
  String _sortBy = 'Best';
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  late AnimationController _listController;
  late AnimationController _shimmerController;
  List<Map<String, dynamic>> _routes = [];

  final List<String> _filters = [
    'All',
    'Cheapest',
    'Fastest',
    'Bank',
    'Crypto',
    'Wallet',
  ];
  final List<String> _sortOptions = [
    'Best',
    'Cheapest',
    'Fastest',
    'Best Rate',
    'Lowest Fee',
  ];

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _loadRoutes();
    }
  }

  Future<void> _loadRoutes() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final src = args?['sourceCurrency'] as String? ?? 'USD';
    final dst = args?['destinationCurrency'] as String? ?? 'PHP';
    final amount = args?['amount'] as double? ?? 500.0;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    try {
      final computed = await RouteEngine.calculate(
        fromCurrency: src,
        toCurrency: dst,
        amount: amount,
      );

      setState(() {
        _routes = computed.map((r) => r.toMap()).toList();
        _isLoading = false;
        _hasError = false;
      });
      _listController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  List<Map<String, dynamic>> get _filteredAndSorted {
    var list = List<Map<String, dynamic>>.from(_routes);

    // Filter
    if (_selectedFilter != 'All') {
      list = list.where((r) {
        switch (_selectedFilter) {
          case 'Cheapest':
            return r['badgeType'] == 'cheapest' ||
                r['badgeType'] == 'recommended';
          case 'Fastest':
            return r['badgeType'] == 'fastest';
          case 'Bank':
            return r['routeType'] == 'bank';
          case 'Crypto':
            return r['routeType'] == 'crypto';
          case 'Wallet':
            return r['providerCategory'] == 'mobileWallet';
          default:
            return true;
        }
      }).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'Cheapest':
        list.sort(
          (a, b) =>
              (a['totalFees'] as double).compareTo(b['totalFees'] as double),
        );
        break;
      case 'Fastest':
        list.sort(
          (a, b) => (a['deliveryMinutes'] as int).compareTo(
            b['deliveryMinutes'] as int,
          ),
        );
        break;
      case 'Best Rate':
        list.sort(
          (a, b) => (b['exchangeRate'] as double).compareTo(
            a['exchangeRate'] as double,
          ),
        );
        break;
      case 'Lowest Fee':
        list.sort(
          (a, b) =>
              (a['totalFees'] as double).compareTo(b['totalFees'] as double),
        );
        break;
      default: // Best
        list.sort(
          (a, b) => (b['recipientAmount'] as double).compareTo(
            a['recipientAmount'] as double,
          ),
        );
    }

    return list;
  }

  @override
  void dispose() {
    _listController.dispose();
    _shimmerController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final sourceCurrency = args?['sourceCurrency'] as String? ?? 'USD';
    final destinationCurrency =
        args?['destinationCurrency'] as String? ?? 'PHP';
    final amount = args?['amount'] as double? ?? 500.0;
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
                    child: _buildContent(
                      context,
                      sourceCurrency,
                      destinationCurrency,
                      amount,
                      isTablet,
                    ),
                  ),
                ],
              )
            : _buildContent(
                context,
                sourceCurrency,
                destinationCurrency,
                amount,
                isTablet,
              ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    String src,
    String dst,
    double amount,
    bool isTablet,
  ) {
    final srcCurrency = CurrenciesDataset.findByCode(src);
    final dstCurrency = CurrenciesDataset.findByCode(dst);
    final srcFlag = srcCurrency?.flag ?? '🌐';
    final dstFlag = dstCurrency?.flag ?? '🌐';

    return Column(
      children: [
        // App bar
        Container(
          color: AppTheme.surface,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(srcFlag, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          src,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: AppTheme.muted,
                          ),
                        ),
                        Text(dstFlag, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          dst,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${srcCurrency?.symbol ?? ''}${_formatAmount(amount)} · ${_isLoading
                          ? 'Calculating…'
                          : _hasError
                          ? 'Error loading routes'
                          : '${_routes.length} routes found'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              // Sort button
              if (!_isLoading && !_hasError)
                PopupMenuButton<String>(
                  initialValue: _sortBy,
                  onSelected: (v) => setState(() => _sortBy = v),
                  itemBuilder: (_) => _sortOptions
                      .map((s) => PopupMenuItem(value: s, child: Text(s)))
                      .toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.outlineVariant),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sort_rounded,
                          size: 16,
                          color: AppTheme.muted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _sortBy,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: AppTheme.muted,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        Expanded(
          child: _isLoading
              ? _buildLoadingState()
              : _hasError
              ? _buildErrorState()
              : _routes.isEmpty
              ? _buildEmptyState()
              : _buildRouteList(src, dst, amount),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return AnimatedErrorWidget(
      errorType: ErrorType.network,
      title: 'Could not load routes',
      message:
          'We had trouble fetching transfer routes for this corridor. Check your connection and try again.',
      statusMessage: 'Route fetch failed',
      onRetry: _loadRoutes,
      retryLabel: 'Retry',
      onSecondaryAction: () => Navigator.pop(context),
      secondaryActionLabel: 'Change currencies',
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _AnimatedSkeletonCard(shimmerController: _shimmerController),
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return _AnimatedSkeletonCard(shimmerController: _shimmerController);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: const Icon(
                Icons.route_outlined,
                size: 32,
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No routes available yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'No routes available yet — please try a different currency or amount.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.muted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Change currencies'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteList(String src, String dst, double amount) {
    final filtered = _filteredAndSorted;
    final bestRoute = _routes.isNotEmpty ? _routes.first : null;

    return CustomScrollView(
      slivers: [
        // Savings banner
        if (bestRoute != null)
          SliverToBoxAdapter(
            child: SavingsBannerWidget(
              bestRoute: bestRoute,
              sourceCurrency: src,
              destinationCurrency: dst,
              amount: amount,
            ),
          ),

        // Comparison header
        SliverToBoxAdapter(
          child: ComparisonHeaderWidget(
            sourceCurrency: src,
            destinationCurrency: dst,
            amount: amount,
            routeCount: _routes.length,
          ),
        ),

        // Filter chips
        SliverToBoxAdapter(
          child: SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final f = _filters[i];
                final isSelected = _selectedFilter == f;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : AppTheme.surface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.outlineVariant,
                      ),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppTheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // Route count
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '${filtered.length} route${filtered.length == 1 ? '' : 's'} · sorted by $_sortBy',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppTheme.muted),
            ),
          ),
        ),

        // Route cards
        if (filtered.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: AnimatedEmptyStateWidget(
                icon: Icons.filter_list_off_rounded,
                iconColor: AppTheme.muted,
                iconBackgroundColor: AppTheme.surfaceVariant,
                title: 'No routes match this filter',
                description:
                    'Try a different filter or sort option to see more results.',
                statusMessage: 'Filter active',
                ctaLabel: 'Clear filter',
                ctaIcon: Icons.clear_rounded,
                onCta: () => setState(() => _selectedFilter = 'All'),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((ctx, i) {
              final route = filtered[i];
              return AnimatedBuilder(
                animation: _listController,
                builder: (context, child) {
                  final delay = (i * 0.1).clamp(0.0, 0.8);
                  final animValue = Curves.easeOutCubic.transform(
                    ((_listController.value - delay) / (1.0 - delay)).clamp(
                      0.0,
                      1.0,
                    ),
                  );
                  return Opacity(
                    opacity: animValue,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - animValue)),
                      child: child,
                    ),
                  );
                },
                child: RouteCardWidget(route: route, isFirst: i == 0),
              );
            }, childCount: filtered.length),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      final s = amount.toStringAsFixed(0);
      final buf = StringBuffer();
      int count = 0;
      for (int i = s.length - 1; i >= 0; i--) {
        if (count > 0 && count % 3 == 0) buf.write(',');
        buf.write(s[i]);
        count++;
      }
      return buf.toString().split('').reversed.join();
    }
    return amount.toStringAsFixed(2);
  }
}

/// Animated skeleton card with shimmer sweep effect
class _AnimatedSkeletonCard extends StatelessWidget {
  final AnimationController shimmerController;

  const _AnimatedSkeletonCard({required this.shimmerController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmerController,
      builder: (context, child) {
        final shimmerValue = shimmerController.value;
        return Container(
          height: 160,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Static skeleton structure
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: Row(
                        children: [
                          // Avatar placeholder
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 13,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 10,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Badge placeholder
                          Container(
                            height: 24,
                            width: 72,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      color: AppTheme.outlineVariant,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    const SizedBox(height: 14),
                    // Metrics row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: List.generate(
                          3,
                          (i) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Shimmer sweep overlay
                Positioned.fill(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      final sweepX = -1.0 + shimmerValue * 3.0;
                      return LinearGradient(
                        begin: Alignment(sweepX - 0.6, 0),
                        end: Alignment(sweepX + 0.6, 0),
                        colors: const [
                          Colors.transparent,
                          Color(0x18FFFFFF),
                          Color(0x30FFFFFF),
                          Color(0x18FFFFFF),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Container(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
