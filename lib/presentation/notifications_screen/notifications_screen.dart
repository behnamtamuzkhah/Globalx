import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  int _currentNavIndex = 3;
  String _selectedFilter = 'All';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _filters = [
    'All',
    'Rate Alerts',
    'Transfers',
    'System',
    'Promotions',
  ];

  static final List<_NotificationItem> _notifications = [
    _NotificationItem(
      id: 'n001',
      type: NotifType.rateAlert,
      title: 'Rate Alert: USD → PHP',
      body:
          'The USD/PHP rate just hit 57.80 — your target rate of 57.50 has been exceeded. Lock in this rate now.',
      time: DateTime.now().subtract(const Duration(minutes: 8)),
      isRead: false,
      actionLabel: 'Send Now',
      actionRoute: AppRoutes.homeScreen,
      metadata: {'from': 'USD', 'to': 'PHP', 'rate': '57.80'},
    ),
    _NotificationItem(
      id: 'n002',
      type: NotifType.transfer,
      title: 'Transfer Completed',
      body:
          'Your transfer of \$500.00 USD → PHP 28,620 via Wise has been delivered successfully.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      actionLabel: 'View Details',
      actionRoute: AppRoutes.transferHistoryScreen,
      metadata: {'amount': '500', 'currency': 'USD', 'provider': 'Wise'},
    ),
    _NotificationItem(
      id: 'n003',
      type: NotifType.rateAlert,
      title: 'Rate Alert: GBP → INR',
      body:
          'GBP/INR is now at 108.50, up 0.8% from yesterday. This is a favorable window for your regular remittance.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      actionLabel: 'Compare Routes',
      actionRoute: AppRoutes.routeComparisonScreen,
      metadata: {'from': 'GBP', 'to': 'INR', 'rate': '108.50'},
    ),
    _NotificationItem(
      id: 'n004',
      type: NotifType.promo,
      title: 'Zero Fees This Weekend',
      body:
          'GlobalX partner Remitly is offering zero transfer fees on all USD → MXN transfers this weekend only. Save up to \$9.99.',
      time: DateTime.now().subtract(const Duration(hours: 9)),
      isRead: true,
      actionLabel: 'Claim Offer',
      actionRoute: AppRoutes.routeComparisonScreen,
      metadata: {'provider': 'Remitly', 'corridor': 'USD→MXN'},
    ),
    _NotificationItem(
      id: 'n005',
      type: NotifType.transfer,
      title: 'Transfer Processing',
      body:
          'Your transfer of £300.00 GBP → INR 31,740 via Remitly is being processed. Expected delivery: 10 minutes.',
      time: DateTime.now().subtract(const Duration(hours: 14)),
      isRead: true,
      actionLabel: 'Track Transfer',
      actionRoute: AppRoutes.transferHistoryScreen,
      metadata: {'amount': '300', 'currency': 'GBP', 'provider': 'Remitly'},
    ),
    _NotificationItem(
      id: 'n006',
      type: NotifType.system,
      title: 'New Providers Added',
      body:
          'We\'ve added 3 new providers: Paysend, Azimo, and OFX. Compare their rates for your next transfer.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      actionLabel: 'Explore',
      actionRoute: AppRoutes.routeComparisonScreen,
      metadata: {},
    ),
    _NotificationItem(
      id: 'n007',
      type: NotifType.rateAlert,
      title: 'EUR → NGN Spike',
      body:
          'EUR/NGN has jumped 2.3% in the last hour to 1,715. If you\'re sending to Nigeria, now may be a good time.',
      time: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isRead: true,
      actionLabel: 'Send Now',
      actionRoute: AppRoutes.homeScreen,
      metadata: {'from': 'EUR', 'to': 'NGN', 'rate': '1715'},
    ),
    _NotificationItem(
      id: 'n008',
      type: NotifType.system,
      title: 'Security Update',
      body:
          'We\'ve enhanced our encryption protocols. Your data and transfers are protected with bank-grade security.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      actionLabel: null,
      actionRoute: null,
      metadata: {},
    ),
    _NotificationItem(
      id: 'n009',
      type: NotifType.promo,
      title: 'Refer & Earn',
      body:
          'Invite friends to GlobalX and earn \$10 for each friend who completes their first transfer. No limit on referrals.',
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      actionLabel: 'Invite Friends',
      actionRoute: null,
      metadata: {},
    ),
    _NotificationItem(
      id: 'n010',
      type: NotifType.transfer,
      title: 'Transfer Failed',
      body:
          'Your transfer of \$300.00 USD → BRL via Remitly could not be completed. Your funds have not been debited.',
      time: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
      actionLabel: 'Try Again',
      actionRoute: AppRoutes.homeScreen,
      metadata: {'amount': '300', 'currency': 'USD', 'status': 'failed'},
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
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

  List<_NotificationItem> get _filtered {
    if (_selectedFilter == 'All') return _notifications;
    final type = _filterToType(_selectedFilter);
    return _notifications.where((n) => n.type == type).toList();
  }

  NotifType? _filterToType(String filter) {
    switch (filter) {
      case 'Rate Alerts':
        return NotifType.rateAlert;
      case 'Transfers':
        return NotifType.transfer;
      case 'System':
        return NotifType.system;
      case 'Promotions':
        return NotifType.promo;
      default:
        return null;
    }
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(String id) {
    setState(() {
      final idx = _notifications.indexWhere((n) => n.id == id);
      if (idx != -1) _notifications[idx].isRead = true;
    });
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
    if (index != 3) {
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
          _buildFilterBar(theme),
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
              Text('Notifications', style: theme.textTheme.headlineMedium),
              if (_unreadCount > 0)
                Text(
                  '$_unreadCount unread',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const Spacer(),
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              child: Text(
                'Mark all read',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.surfaceVariant,
              foregroundColor: AppTheme.onSurface,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((f) {
            final selected = _selectedFilter == f;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppTheme.primary
                        : AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: selected
                          ? AppTheme.primary
                          : AppTheme.outlineVariant,
                    ),
                  ),
                  child: Text(
                    f,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: selected
                          ? Colors.white
                          : AppTheme.onSurfaceVariant,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildList(ThemeData theme) {
    final items = _filtered;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 36,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text('No notifications', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('You\'re all caught up!', style: theme.textTheme.bodySmall),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return _NotificationCard(
          item: item,
          onTap: () {
            _markRead(item.id);
            if (item.actionRoute != null) {
              Navigator.pushNamed(context, item.actionRoute!);
            }
          },
          onDismiss: () {
            setState(() => _notifications.removeWhere((n) => n.id == item.id));
          },
        );
      },
    );
  }
}

// ─── Data Model ──────────────────────────────────────────────────────────────

enum NotifType { rateAlert, transfer, system, promo }

class _NotificationItem {
  final String id;
  final NotifType type;
  final String title;
  final String body;
  final DateTime time;
  bool isRead;
  final String? actionLabel;
  final String? actionRoute;
  final Map<String, String> metadata;

  _NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.actionLabel,
    required this.actionRoute,
    required this.metadata,
  });
}

// ─── Notification Card ───────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.item,
    required this.onTap,
    required this.onDismiss,
  });

  Color _typeColor() {
    switch (item.type) {
      case NotifType.rateAlert:
        return AppTheme.secondary;
      case NotifType.transfer:
        return AppTheme.primary;
      case NotifType.system:
        return AppTheme.muted;
      case NotifType.promo:
        return AppTheme.cryptoAccent;
    }
  }

  IconData _typeIcon() {
    switch (item.type) {
      case NotifType.rateAlert:
        return Icons.trending_up_rounded;
      case NotifType.transfer:
        return Icons.send_rounded;
      case NotifType.system:
        return Icons.info_outline_rounded;
      case NotifType.promo:
        return Icons.local_offer_rounded;
    }
  }

  String _typeLabel() {
    switch (item.type) {
      case NotifType.rateAlert:
        return 'Rate Alert';
      case NotifType.transfer:
        return 'Transfer';
      case NotifType.system:
        return 'System';
      case NotifType.promo:
        return 'Promotion';
    }
  }

  String _timeAgo() {
    final diff = DateTime.now().difference(item.time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _typeColor();

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.error.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppTheme.error,
          size: 22,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: item.isRead ? AppTheme.surface : color.withAlpha(8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isRead
                  ? AppTheme.outlineVariant
                  : color.withAlpha(60),
              width: item.isRead ? 1 : 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_typeIcon(), color: color, size: 20),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _typeLabel(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _timeAgo(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.muted,
                            ),
                          ),
                          if (!item.isRead) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: item.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.actionLabel != null) ...[
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: color.withAlpha(15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: color.withAlpha(40)),
                            ),
                            child: Text(
                              item.actionLabel!,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
