import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class QuickSectionsWidget extends StatelessWidget {
  const QuickSectionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sections = [
      _QuickSection(
        icon: Icons.bookmark_outline_rounded,
        label: 'Saved',
        count: '4',
        color: AppTheme.primary,
        bg: AppTheme.primaryContainer,
        route: AppRoutes.savedRoutesScreen,
      ),
      _QuickSection(
        icon: Icons.history_rounded,
        label: 'History',
        count: '10',
        color: AppTheme.secondary,
        bg: AppTheme.secondaryContainer,
        route: AppRoutes.transferHistoryScreen,
      ),
      _QuickSection(
        icon: Icons.notifications_outlined,
        label: 'Alerts',
        count: '2',
        color: AppTheme.warning,
        bg: AppTheme.warningContainer,
        route: AppRoutes.notificationsScreen,
      ),
      _QuickSection(
        icon: Icons.compare_arrows_rounded,
        label: 'Compare',
        count: '0',
        color: const Color(0xFF7C3AED),
        bg: const Color(0xFFEDE9FE),
        route: AppRoutes.routeComparisonScreen,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Access', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: sections.asMap().entries.map((entry) {
              final s = entry.value;
              final isLast = entry.key == sections.length - 1;
              return Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, s.route),
                  child: Container(
                    margin: EdgeInsets.only(right: isLast ? 0 : 10),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(6),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: s.bg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(s.icon, color: s.color, size: 18),
                            ),
                            if (s.count != '0')
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: s.color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    s.count,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _QuickSection {
  final IconData icon;
  final String label;
  final String count;
  final Color color;
  final Color bg;
  final String route;

  const _QuickSection({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.bg,
    required this.route,
  });
}
