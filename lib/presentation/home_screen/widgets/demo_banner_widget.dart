import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class DemoBannerWidget extends StatelessWidget {
  const DemoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.cryptoAccent.withAlpha(30),
            AppTheme.cryptoAccent.withAlpha(15),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cryptoAccent.withAlpha(80)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.cryptoAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'DEMO',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 10,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Currently in demo mode · Live execution coming soon',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.warning,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.rocket_launch_rounded,
            size: 14,
            color: AppTheme.cryptoAccent,
          ),
        ],
      ),
    );
  }
}
