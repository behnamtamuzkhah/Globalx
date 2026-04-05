import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class SettingsRateAlertsWidget extends StatefulWidget {
  const SettingsRateAlertsWidget({super.key});

  @override
  State<SettingsRateAlertsWidget> createState() =>
      _SettingsRateAlertsWidgetState();
}

class _SettingsRateAlertsWidgetState extends State<SettingsRateAlertsWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  bool _alertsEnabled = true;
  final List<Map<String, dynamic>> _alerts = [
    {
      'pair': 'USD → PHP',
      'fromFlag': '🇺🇸',
      'toFlag': '🇵🇭',
      'targetRate': 58.00,
      'currentRate': 57.24,
      'enabled': true,
    },
    {
      'pair': 'GBP → INR',
      'fromFlag': '🇬🇧',
      'toFlag': '🇮🇳',
      'targetRate': 110.00,
      'currentRate': 108.63,
      'enabled': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Text(
                  'RATE ALERTS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.muted,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _alertsEnabled,
                  onChanged: (v) => setState(() => _alertsEnabled = v),
                ),
              ],
            ),
          ),
          if (_alertsEnabled) ...[
            ..._alerts.asMap().entries.map((entry) {
              final i = entry.key;
              final alert = entry.value;
              final isEnabled = alert['enabled'] as bool;
              final currentRate = alert['currentRate'] as double;
              final targetRate = alert['targetRate'] as double;
              final progress = (currentRate / targetRate).clamp(0.0, 1.0);

              return Column(
                children: [
                  if (i > 0) const Divider(indent: 16, endIndent: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              alert['fromFlag'] as String,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 12,
                              color: AppTheme.muted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              alert['toFlag'] as String,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              alert['pair'] as String,
                              style: theme.textTheme.titleSmall,
                            ),
                            const Spacer(),
                            Switch(
                              value: isEnabled,
                              onChanged: (v) {
                                setState(() => _alerts[i]['enabled'] = v);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current: ${currentRate.toStringAsFixed(2)}',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              'Target: ${targetRate.toStringAsFixed(2)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: AppTheme.outlineVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 0.95
                                  ? AppTheme.success
                                  : AppTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(progress * 100).toStringAsFixed(1)}% of target rate reached',
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Add Rate Alert — coming soon'),
                      backgroundColor: AppTheme.onSurface,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add Rate Alert'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'Enable rate alerts to get notified when your target rate is reached.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
