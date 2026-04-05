import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class SettingsNotificationsWidget extends StatefulWidget {
  const SettingsNotificationsWidget({super.key});

  @override
  State<SettingsNotificationsWidget> createState() =>
      _SettingsNotificationsWidgetState();
}

class _SettingsNotificationsWidgetState
    extends State<SettingsNotificationsWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  final List<Map<String, dynamic>> _prefs = [
    {
      'icon': Icons.rate_review_outlined,
      'iconColor': AppTheme.primary,
      'title': 'Rate Alerts',
      'subtitle': 'When your target rate is reached',
      'enabled': true,
    },
    {
      'icon': Icons.local_offer_outlined,
      'iconColor': AppTheme.secondary,
      'title': 'Fee Drop Alerts',
      'subtitle': 'When transfer fees decrease',
      'enabled': true,
    },
    {
      'icon': Icons.trending_up_rounded,
      'iconColor': AppTheme.cryptoAccent,
      'title': 'Market Updates',
      'subtitle': 'Weekly FX market summary',
      'enabled': false,
    },
    {
      'icon': Icons.history_edu_outlined,
      'iconColor': AppTheme.muted,
      'title': 'Transfer Reminders',
      'subtitle': 'Remind me to check rates',
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
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'NOTIFICATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.muted,
                letterSpacing: 0.8,
              ),
            ),
          ),
          ..._prefs.asMap().entries.map((entry) {
            final i = entry.key;
            final pref = entry.value;
            return Column(
              children: [
                if (i > 0) const Divider(indent: 52, endIndent: 16, height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: (pref['iconColor'] as Color).withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          pref['icon'] as IconData,
                          size: 18,
                          color: pref['iconColor'] as Color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pref['title'] as String,
                              style: theme.textTheme.titleSmall,
                            ),
                            Text(
                              pref['subtitle'] as String,
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: pref['enabled'] as bool,
                        onChanged: (v) {
                          setState(() => _prefs[i]['enabled'] = v);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
