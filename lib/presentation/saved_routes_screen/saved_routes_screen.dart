import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';

class SavedRoutesScreen extends StatefulWidget {
  const SavedRoutesScreen({super.key});

  @override
  State<SavedRoutesScreen> createState() => _SavedRoutesScreenState();
}

class _SavedRoutesScreenState extends State<SavedRoutesScreen>
    with TickerProviderStateMixin {
  int _currentNavIndex = 2;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static final List<_SavedRoute> _savedRoutes = [
    _SavedRoute(
      id: 'sr001',
      fromCurrency: 'USD',
      fromFlag: '🇺🇸',
      toCurrency: 'PHP',
      toFlag: '🇵🇭',
      amount: 500.0,
      provider: 'Wise',
      rate: 57.42,
      fee: 4.14,
      deliveryTime: '1–2 hours',
      savedAt: DateTime.now().subtract(const Duration(hours: 3)),
      note: 'Monthly family remittance',
    ),
    _SavedRoute(
      id: 'sr002',
      fromCurrency: 'GBP',
      fromFlag: '🇬🇧',
      toCurrency: 'INR',
      toFlag: '🇮🇳',
      amount: 300.0,
      provider: 'Remitly',
      rate: 108.24,
      fee: 3.99,
      deliveryTime: '10 minutes',
      savedAt: DateTime.now().subtract(const Duration(days: 1)),
      note: 'Parents support',
    ),
    _SavedRoute(
      id: 'sr003',
      fromCurrency: 'USD',
      fromFlag: '🇺🇸',
      toCurrency: 'MXN',
      toFlag: '🇲🇽',
      amount: 1200.0,
      provider: 'Xe',
      rate: 19.72,
      fee: 9.99,
      deliveryTime: '2–4 hours',
      savedAt: DateTime.now().subtract(const Duration(days: 3)),
      note: 'Business payment',
    ),
    _SavedRoute(
      id: 'sr004',
      fromCurrency: 'EUR',
      fromFlag: '🇪🇺',
      toCurrency: 'NGN',
      toFlag: '🇳🇬',
      amount: 250.0,
      provider: 'WorldRemit',
      rate: 1687.0,
      fee: 6.79,
      deliveryTime: '2–4 hours',
      savedAt: DateTime.now().subtract(const Duration(days: 5)),
      note: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
    if (index != 2) {
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
    Widget body = FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          _buildHeader(theme),
          Expanded(child: _buildList(theme)),
        ],
      ),
    );

    if (isTablet) {
      body = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: body,
        ),
      );
    }

    return body;
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Saved Routes', style: theme.textTheme.headlineMedium),
              Text(
                '${_savedRoutes.length} saved quote${_savedRoutes.length != 1 ? 's' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.homeScreen),
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('New Quote'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(ThemeData theme) {
    if (_savedRoutes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppTheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 36,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text('No saved routes', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Save a quote to compare rates later',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.homeScreen),
              child: const Text('Find a Route'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: _savedRoutes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final route = _savedRoutes[index];
        return _SavedRouteCard(
          route: route,
          onSend: () => Navigator.pushNamed(
            context,
            AppRoutes.routeComparisonScreen,
            arguments: {
              'sourceCurrency': route.fromCurrency,
              'destinationCurrency': route.toCurrency,
              'amount': route.amount,
            },
          ),
          onDelete: () {
            setState(() => _savedRoutes.removeWhere((r) => r.id == route.id));
          },
        );
      },
    );
  }
}

// ─── Data Model ──────────────────────────────────────────────────────────────

class _SavedRoute {
  final String id;
  final String fromCurrency;
  final String fromFlag;
  final String toCurrency;
  final String toFlag;
  final double amount;
  final String provider;
  final double rate;
  final double fee;
  final String deliveryTime;
  final DateTime savedAt;
  final String? note;

  const _SavedRoute({
    required this.id,
    required this.fromCurrency,
    required this.fromFlag,
    required this.toCurrency,
    required this.toFlag,
    required this.amount,
    required this.provider,
    required this.rate,
    required this.fee,
    required this.deliveryTime,
    required this.savedAt,
    this.note,
  });

  double get recipientAmount => amount * rate;
}

// ─── Saved Route Card ────────────────────────────────────────────────────────

class _SavedRouteCard extends StatelessWidget {
  final _SavedRoute route;
  final VoidCallback onSend;
  final VoidCallback onDelete;

  const _SavedRouteCard({
    required this.route,
    required this.onSend,
    required this.onDelete,
  });

  String _timeAgo() {
    final diff = DateTime.now().difference(route.savedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(2)}M';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        children: [
          // Top row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                // Currency pair
                Row(
                  children: [
                    Text(route.fromFlag, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${route.fromCurrency} → ${route.toCurrency}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'via ${route.provider}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    Text(route.toFlag, style: const TextStyle(fontSize: 22)),
                  ],
                ),
                const Spacer(),
                Text(
                  _timeAgo(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.muted,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
                      color: AppTheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider
          const Divider(height: 1),
          // Amount details
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                _StatChip(
                  label: 'You send',
                  value: '${route.fromCurrency} ${_formatAmount(route.amount)}',
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppTheme.muted,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'They receive',
                  value:
                      '${route.toCurrency} ${_formatAmount(route.recipientAmount)}',
                  color: AppTheme.secondary,
                ),
              ],
            ),
          ),
          // Meta row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _MetaTag(
                  icon: Icons.attach_money_rounded,
                  label: 'Fee: \$${route.fee.toStringAsFixed(2)}',
                ),
                const SizedBox(width: 8),
                _MetaTag(
                  icon: Icons.schedule_rounded,
                  label: route.deliveryTime,
                ),
                const SizedBox(width: 8),
                _MetaTag(
                  icon: Icons.currency_exchange_rounded,
                  label:
                      '1 ${route.fromCurrency} = ${route.rate.toStringAsFixed(2)} ${route.toCurrency}',
                ),
              ],
            ),
          ),
          if (route.note != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.sticky_note_2_outlined,
                    size: 13,
                    color: AppTheme.muted,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      route.note!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.muted,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          // CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSend,
                icon: const Icon(Icons.send_rounded, size: 15),
                label: const Text('Send with this route'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppTheme.muted),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
