import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class RecentTransfersWidget extends StatelessWidget {
  const RecentTransfersWidget({super.key});

  static final List<Map<String, dynamic>> _recent = [
    {
      'fromFlag': '🇺🇸',
      'from': 'USD',
      'toFlag': '🇵🇭',
      'to': 'PHP',
      'amount': '500',
      'provider': 'Wise',
      'daysAgo': 3,
    },
    {
      'fromFlag': '🇬🇧',
      'from': 'GBP',
      'toFlag': '🇮🇳',
      'to': 'INR',
      'amount': '300',
      'provider': 'Remitly',
      'daysAgo': 12,
    },
    {
      'fromFlag': '🇺🇸',
      'from': 'USD',
      'toFlag': '🇲🇽',
      'to': 'MXN',
      'amount': '1,200',
      'provider': 'Xe',
      'daysAgo': 28,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Searches', style: theme.textTheme.titleMedium),
              TextButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.transferHistoryScreen,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View all',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _recent.asMap().entries.map((entry) {
                final r = entry.value;
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.routeComparisonScreen,
                    arguments: {
                      'sourceCurrency': r['from'],
                      'destinationCurrency': r['to'],
                      'amount':
                          double.tryParse(r['amount'].replaceAll(',', '')) ??
                          500.0,
                    },
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: entry.key < _recent.length - 1 ? 12 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              r['fromFlag'] as String,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              r['from'] as String,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: AppTheme.muted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              r['toFlag'] as String,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              r['to'] as String,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${r['from']} ${r['amount']}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'via ${r['provider']}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppTheme.muted,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '· ${r['daysAgo']}d ago',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
