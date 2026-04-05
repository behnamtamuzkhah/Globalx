import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class HowItWorksWidget extends StatelessWidget {
  const HowItWorksWidget({super.key});

  static const _steps = [
    {
      'step': '01',
      'icon': Icons.tune_rounded,
      'title': 'Enter transfer details',
      'desc':
          'Set your source and destination currencies, amount, and preferred provider type.',
      'color': AppTheme.primary,
    },
    {
      'step': '02',
      'icon': Icons.compare_arrows_rounded,
      'title': 'Compare routes instantly',
      'desc':
          'Our engine scans 30+ providers and calculates the best routes in real time.',
      'color': AppTheme.secondary,
    },
    {
      'step': '03',
      'icon': Icons.check_circle_outline_rounded,
      'title': 'Choose the best option',
      'desc':
          'Pick by cost, speed, or reliability — then continue directly with the provider.',
      'color': Color(0xFF7C3AED),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'HOW IT WORKS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Three steps to smarter transfers',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'From comparison to execution in under 60 seconds.',
            style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.muted),
          ),
          const SizedBox(height: 20),
          ..._steps.asMap().entries.map((entry) {
            final step = entry.value;
            final isLast = entry.key == _steps.length - 1;
            final color = step['color'] as Color;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color.withAlpha(18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: color.withAlpha(50)),
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            color: color,
                            size: 20,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 28,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  color.withAlpha(80),
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withAlpha(18),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    step['step'] as String,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    step['title'] as String,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              step['desc'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.muted,
                                height: 1.4,
                              ),
                            ),
                            if (!isLast) const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
