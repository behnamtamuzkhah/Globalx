import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class TrustComplianceWidget extends StatelessWidget {
  const TrustComplianceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
          // Header section with gradient accent
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withAlpha(8),
                  AppTheme.secondary.withAlpha(8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'TRUSTED INFRASTRUCTURE',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Trusted by global users',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'GlobalX is a comparison and routing layer — not a money transmitter. Your funds stay with regulated providers.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.muted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(height: 1, color: AppTheme.outlineVariant),
          // Trust pillars
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _TrustPillar(
                        icon: Icons.route_outlined,
                        color: AppTheme.primary,
                        title: 'Multi-provider routing',
                        desc:
                            'Optimized paths across banks, exchanges, and wallets.',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TrustPillar(
                        icon: Icons.receipt_long_outlined,
                        color: AppTheme.secondary,
                        title: 'Transparent pricing',
                        desc:
                            'Every fee and margin shown clearly — no surprises.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _TrustPillar(
                        icon: Icons.account_balance_wallet_outlined,
                        color: const Color(0xFF7C3AED),
                        title: 'No custody of funds',
                        desc: 'GlobalX never holds or moves your money.',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TrustPillar(
                        icon: Icons.verified_user_outlined,
                        color: AppTheme.success,
                        title: 'Secure & compliant',
                        desc:
                            'Built with regulatory requirements from day one.',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bottom stats bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _StatItem(value: '130+', label: 'Currencies'),
                ),
                Container(width: 1, height: 32, color: AppTheme.outlineVariant),
                Expanded(
                  child: _StatItem(value: '30+', label: 'Providers'),
                ),
                Container(width: 1, height: 32, color: AppTheme.outlineVariant),
                Expanded(
                  child: _StatItem(value: '6', label: 'Route types'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustPillar extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;

  const _TrustPillar({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.muted,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(color: AppTheme.muted),
        ),
      ],
    );
  }
}
