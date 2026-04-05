import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class DeliveryTimelineWidget extends StatelessWidget {
  final Map<String, dynamic>? route;

  const DeliveryTimelineWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deliveryTime = route?['deliveryTime'] as String? ?? '1–2 hours';
    final routeType = route?['routeType'] as String? ?? 'bank';

    final List<Map<String, dynamic>> steps = routeType == 'crypto'
        ? [
            {
              'label': 'Transfer initiated',
              'sublabel': 'Your payment is confirmed',
              'status': 'done',
              'time': 'Now',
            },
            {
              'label': 'On-chain confirmation',
              'sublabel': 'Blockchain validates transaction',
              'status': 'active',
              'time': '~5 min',
            },
            {
              'label': 'Provider converts',
              'sublabel': 'Crypto converted to local currency',
              'status': 'pending',
              'time': '~10 min',
            },
            {
              'label': 'Recipient credited',
              'sublabel': 'Funds arrive in recipient account',
              'status': 'pending',
              'time': deliveryTime,
            },
          ]
        : [
            {
              'label': 'Transfer initiated',
              'sublabel': 'Your payment is confirmed',
              'status': 'done',
              'time': 'Now',
            },
            {
              'label': 'Provider processes',
              'sublabel': 'Compliance and FX conversion',
              'status': 'active',
              'time': '~15 min',
            },
            {
              'label': 'Bank network transfer',
              'sublabel': 'Routed through payment network',
              'status': 'pending',
              'time': '~30 min',
            },
            {
              'label': 'Recipient credited',
              'sublabel': 'Funds arrive in recipient account',
              'status': 'pending',
              'time': deliveryTime,
            },
          ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Text('Delivery Timeline', style: theme.textTheme.titleSmall),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  deliveryTime,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isLast = i == steps.length - 1;
            final status = step['status'] as String;
            final isDone = status == 'done';
            final isActive = status == 'active';

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppTheme.success
                            : isActive
                            ? AppTheme.primary
                            : AppTheme.surfaceVariant,
                        shape: BoxShape.circle,
                        border: isActive
                            ? Border.all(
                                color: AppTheme.primaryContainer,
                                width: 3,
                              )
                            : null,
                      ),
                      child: Icon(
                        isDone
                            ? Icons.check_rounded
                            : isActive
                            ? Icons.radio_button_checked_rounded
                            : Icons.circle_outlined,
                        size: isDone ? 16 : 14,
                        color: isDone || isActive
                            ? Colors.white
                            : AppTheme.muted,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 36,
                        color: isDone
                            ? AppTheme.success.withAlpha(80)
                            : AppTheme.outlineVariant,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['label'] as String,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: isDone || isActive
                                      ? AppTheme.onSurface
                                      : AppTheme.muted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                step['sublabel'] as String,
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          step['time'] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isActive ? AppTheme.primary : AppTheme.muted,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
