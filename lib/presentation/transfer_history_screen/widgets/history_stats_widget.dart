import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class HistoryStatsWidget extends StatelessWidget {
  const HistoryStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatCell(
            label: 'Total saved',
            value: '\$173.06',
            valueColor: AppTheme.secondary,
            icon: Icons.savings_outlined,
          ),
          Container(width: 1, height: 36, color: AppTheme.outlineVariant),
          _StatCell(
            label: 'Transfers',
            value: '10',
            valueColor: AppTheme.primary,
            icon: Icons.swap_horiz_rounded,
          ),
          Container(width: 1, height: 36, color: AppTheme.outlineVariant),
          _StatCell(
            label: 'Top corridor',
            value: 'USD→PHP',
            valueColor: AppTheme.onSurface,
            icon: Icons.route_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;

  const _StatCell({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppTheme.muted),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}
