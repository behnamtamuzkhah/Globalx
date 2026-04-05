import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_empty_state_widget.dart';
import '../../widgets/animated_error_widget.dart';
import '../../widgets/app_navigation.dart';
import './widgets/history_item_widget.dart';
import './widgets/history_search_widget.dart';
import './widgets/history_stats_widget.dart';

class TransferHistoryScreen extends StatefulWidget {
  const TransferHistoryScreen({super.key});

  @override
  State<TransferHistoryScreen> createState() => _TransferHistoryScreenState();
}

class _TransferHistoryScreenState extends State<TransferHistoryScreen> {
  // TODO: Replace with Riverpod/Bloc for production
  int _currentNavIndex = 2;
  String _searchQuery = '';
  String _selectedFilter = 'All time';
  bool _isRefreshing = false;
  bool _hasError = false;

  final List<String> _filters = [
    'All time',
    'This month',
    'Last 3 months',
    'USD→PHP',
    'GBP→INR',
  ];

  static final List<Map<String, dynamic>> _historyMaps = [
    {
      'id': 'hist_001',
      'date': '2026-04-01',
      'fromCurrency': 'USD',
      'fromFlag': '🇺🇸',
      'toCurrency': 'PHP',
      'toFlag': '🇵🇭',
      'amountSent': 500.0,
      'amountReceived': 28620.0,
      'provider': 'Wise',
      'totalFees': 4.14,
      'exchangeRate': 57.42,
      'status': 'completed',
      'savingsVsBank': 18.36,
      'deliveryTime': '1–2 hours',
    },
    {
      'id': 'hist_002',
      'date': '2026-03-28',
      'fromCurrency': 'GBP',
      'fromFlag': '🇬🇧',
      'toCurrency': 'INR',
      'toFlag': '🇮🇳',
      'amountSent': 300.0,
      'amountReceived': 31740.0,
      'provider': 'Remitly',
      'totalFees': 3.99,
      'exchangeRate': 108.24,
      'status': 'completed',
      'savingsVsBank': 12.50,
      'deliveryTime': '10 minutes',
    },
    {
      'id': 'hist_003',
      'date': '2026-03-20',
      'fromCurrency': 'USD',
      'fromFlag': '🇺🇸',
      'toCurrency': 'MXN',
      'toFlag': '🇲🇽',
      'amountSent': 1200.0,
      'amountReceived': 23520.0,
      'provider': 'Xe',
      'totalFees': 9.99,
      'exchangeRate': 19.72,
      'status': 'completed',
      'savingsVsBank': 31.20,
      'deliveryTime': '2–4 hours',
    },
    {
      'id': 'hist_004',
      'date': '2026-03-14',
      'fromCurrency': 'EUR',
      'fromFlag': '🇪🇺',
      'toCurrency': 'NGN',
      'toFlag': '🇳🇬',
      'amountSent': 250.0,
      'amountReceived': 421250.0,
      'provider': 'WorldRemit',
      'totalFees': 6.79,
      'exchangeRate': 1687.0,
      'status': 'completed',
      'savingsVsBank': 22.10,
      'deliveryTime': '2–4 hours',
    },
    {
      'id': 'hist_005',
      'date': '2026-03-08',
      'fromCurrency': 'USD',
      'fromFlag': '🇺🇸',
      'toCurrency': 'PHP',
      'toFlag': '🇵🇭',
      'amountSent': 750.0,
      'amountReceived': 42750.0,
      'provider': 'Binance Pay',
      'totalFees': 2.70,
      'exchangeRate': 57.10,
      'status': 'completed',
      'savingsVsBank': 29.55,
      'deliveryTime': '15–30 min',
    },
    {
      'id': 'hist_006',
      'date': '2026-03-01',
      'fromCurrency': 'GBP',
      'fromFlag': '🇬🇧',
      'toCurrency': 'KES',
      'toFlag': '🇰🇪',
      'amountSent': 150.0,
      'amountReceived': 24750.0,
      'provider': 'Remitly',
      'totalFees': 3.99,
      'exchangeRate': 165.68,
      'status': 'completed',
      'savingsVsBank': 8.40,
      'deliveryTime': '10 minutes',
    },
    {
      'id': 'hist_007',
      'date': '2026-02-22',
      'fromCurrency': 'USD',
      'fromFlag': '🇺🇸',
      'toCurrency': 'VND',
      'toFlag': '🇻🇳',
      'amountSent': 400.0,
      'amountReceived': 9920000.0,
      'provider': 'Wise',
      'totalFees': 4.14,
      'exchangeRate': 24845.0,
      'status': 'pending',
      'savingsVsBank': 14.80,
      'deliveryTime': '1–2 hours',
    },
    {
      'id': 'hist_008',
      'date': '2026-02-15',
      'fromCurrency': 'AUD',
      'fromFlag': '🇦🇺',
      'toCurrency': 'PHP',
      'toFlag': '🇵🇭',
      'amountSent': 600.0,
      'amountReceived': 22800.0,
      'provider': 'Xe',
      'totalFees': 7.50,
      'exchangeRate': 38.12,
      'status': 'completed',
      'savingsVsBank': 16.90,
      'deliveryTime': '2–4 hours',
    },
    {
      'id': 'hist_009',
      'date': '2026-02-08',
      'fromCurrency': 'USD',
      'fromFlag': '🇺🇸',
      'toCurrency': 'BRL',
      'toFlag': '🇧🇷',
      'amountSent': 300.0,
      'amountReceived': 1530.0,
      'provider': 'Remitly',
      'totalFees': 4.99,
      'exchangeRate': 5.12,
      'status': 'failed',
      'savingsVsBank': 0.0,
      'deliveryTime': 'N/A',
    },
    {
      'id': 'hist_010',
      'date': '2026-01-30',
      'fromCurrency': 'CAD',
      'fromFlag': '🇨🇦',
      'toCurrency': 'INR',
      'toFlag': '🇮🇳',
      'amountSent': 500.0,
      'amountReceived': 30750.0,
      'provider': 'WorldRemit',
      'totalFees': 5.99,
      'exchangeRate': 61.74,
      'status': 'completed',
      'savingsVsBank': 19.25,
      'deliveryTime': '2–4 hours',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    var list = _historyMaps;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((h) {
        return (h['fromCurrency'] as String).toLowerCase().contains(q) ||
            (h['toCurrency'] as String).toLowerCase().contains(q) ||
            (h['provider'] as String).toLowerCase().contains(q);
      }).toList();
    }
    if (_selectedFilter == 'This month') {
      final now = DateTime.now();
      list = list.where((h) {
        final d = DateTime.parse(h['date'] as String);
        return d.month == now.month && d.year == now.year;
      }).toList();
    } else if (_selectedFilter == 'Last 3 months') {
      final cutoff = DateTime.now().subtract(const Duration(days: 90));
      list = list.where((h) {
        final d = DateTime.parse(h['date'] as String);
        return d.isAfter(cutoff);
      }).toList();
    } else if (_selectedFilter == 'USD→PHP') {
      list = list
          .where((h) => h['fromCurrency'] == 'USD' && h['toCurrency'] == 'PHP')
          .toList();
    } else if (_selectedFilter == 'GBP→INR') {
      list = list
          .where((h) => h['fromCurrency'] == 'GBP' && h['toCurrency'] == 'INR')
          .toList();
    }
    return list;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
      _hasError = false;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() => _isRefreshing = false);
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
    final filtered = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppTheme.surface,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Transfer History',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Export history — coming soon'),
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
                      Icons.download_outlined,
                      color: AppTheme.primary,
                      size: 22,
                    ),
                    tooltip: 'Export history',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              HistorySearchWidget(
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final isSelected = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(f),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedFilter = f),
                        selectedColor: AppTheme.primaryContainer,
                        backgroundColor: AppTheme.surface,
                        checkmarkColor: AppTheme.primary,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.onSurface,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.outlineVariant,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const HistoryStatsWidget(),
        Expanded(
          child: _hasError
              ? AnimatedErrorWidget(
                  errorType: ErrorType.network,
                  title: 'Could not load history',
                  message:
                      'Your transfer history couldn\'t be loaded right now. Pull down to refresh or tap retry.',
                  statusMessage: 'Sync failed',
                  onRetry: _onRefresh,
                  retryLabel: 'Refresh history',
                )
              : filtered.isEmpty
              ? (_searchQuery.isNotEmpty || _selectedFilter != 'All time'
                    ? AnimatedEmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        iconColor: AppTheme.muted,
                        iconBackgroundColor: AppTheme.surfaceVariant,
                        title: 'No transfers found',
                        description:
                            'No transfers match your current search or filter. Try clearing them to see all history.',
                        statusMessage: 'Filter active',
                        ctaLabel: 'Clear filters',
                        ctaIcon: Icons.clear_rounded,
                        onCta: () => setState(() {
                          _searchQuery = '';
                          _selectedFilter = 'All time';
                        }),
                      )
                    : AnimatedEmptyStateWidget(
                        icon: Icons.history_rounded,
                        iconColor: AppTheme.primary,
                        iconBackgroundColor: AppTheme.primaryContainer,
                        title: 'No transfers yet',
                        description:
                            'Your past transfer comparisons will appear here. Start by searching for a route.',
                        statusMessage: 'History is empty',
                        ctaLabel: 'Find a Route',
                        ctaIcon: Icons.compare_arrows_rounded,
                        onCta: () =>
                            Navigator.pushNamed(context, AppRoutes.homeScreen),
                      ))
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      return Dismissible(
                        key: Key(filtered[i]['id'] as String),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.errorContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: AppTheme.error,
                            size: 24,
                          ),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Record'),
                              content: const Text(
                                'Remove this transfer from your history?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppTheme.error,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: HistoryItemWidget(
                          item: filtered[i],
                          onRepeat: () => Navigator.pushNamed(
                            context,
                            AppRoutes.routeComparisonScreen,
                            arguments: {
                              'sourceCurrency': filtered[i]['fromCurrency'],
                              'destinationCurrency': filtered[i]['toCurrency'],
                              'amount': filtered[i]['amountSent'],
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
