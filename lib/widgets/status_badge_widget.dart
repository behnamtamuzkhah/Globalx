import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BadgeType {
  recommended,
  cheapest,
  fastest,
  safest,
  crypto,
  hybrid,
  bank,
  completed,
  pending,
  failed,
}

class StatusBadgeWidget extends StatelessWidget {
  final BadgeType type;
  final String? customLabel;
  final bool compact;

  const StatusBadgeWidget({
    super.key,
    required this.type,
    this.customLabel,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _badgeConfig(type);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: config.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (config.icon != null) ...[
            Icon(config.icon, size: compact ? 10 : 12, color: config.textColor),
            const SizedBox(width: 4),
          ],
          Text(
            customLabel ?? config.label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: config.textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _badgeConfig(BadgeType type) {
    switch (type) {
      case BadgeType.recommended:
        return _BadgeConfig(
          label: 'Recommended',
          backgroundColor: AppTheme.primaryMuted,
          borderColor: AppTheme.primary.withAlpha(50),
          textColor: AppTheme.primary,
          icon: Icons.star_rounded,
        );
      case BadgeType.cheapest:
        return _BadgeConfig(
          label: 'Cheapest',
          backgroundColor: AppTheme.secondaryContainer,
          borderColor: AppTheme.secondary.withAlpha(50),
          textColor: AppTheme.secondary,
          icon: Icons.savings_outlined,
        );
      case BadgeType.fastest:
        return _BadgeConfig(
          label: 'Fastest',
          backgroundColor: AppTheme.primaryContainer,
          borderColor: AppTheme.primary.withAlpha(50),
          textColor: AppTheme.primaryDark,
          icon: Icons.bolt_rounded,
        );
      case BadgeType.safest:
        return _BadgeConfig(
          label: 'Safest',
          backgroundColor: AppTheme.successContainer,
          borderColor: AppTheme.success.withAlpha(50),
          textColor: AppTheme.success,
          icon: Icons.verified_outlined,
        );
      case BadgeType.crypto:
        return _BadgeConfig(
          label: 'Crypto',
          backgroundColor: AppTheme.cryptoContainer,
          borderColor: AppTheme.cryptoAccent.withAlpha(50),
          textColor: AppTheme.cryptoAccent,
          icon: Icons.currency_bitcoin_rounded,
        );
      case BadgeType.hybrid:
        return _BadgeConfig(
          label: 'Hybrid',
          backgroundColor: const Color(0xFFEDE9FE),
          borderColor: const Color(0xFF7C3AED).withAlpha(50),
          textColor: const Color(0xFF7C3AED),
          icon: Icons.merge_type_rounded,
        );
      case BadgeType.bank:
        return _BadgeConfig(
          label: 'Bank',
          backgroundColor: AppTheme.surfaceVariant,
          borderColor: AppTheme.outline,
          textColor: AppTheme.muted,
          icon: Icons.account_balance_outlined,
        );
      case BadgeType.completed:
        return _BadgeConfig(
          label: 'Completed',
          backgroundColor: AppTheme.successContainer,
          borderColor: AppTheme.success.withAlpha(50),
          textColor: AppTheme.success,
          icon: Icons.check_circle_outline_rounded,
        );
      case BadgeType.pending:
        return _BadgeConfig(
          label: 'Pending',
          backgroundColor: AppTheme.warningContainer,
          borderColor: AppTheme.warning.withAlpha(50),
          textColor: AppTheme.warning,
          icon: Icons.schedule_rounded,
        );
      case BadgeType.failed:
        return _BadgeConfig(
          label: 'Failed',
          backgroundColor: AppTheme.errorContainer,
          borderColor: AppTheme.error.withAlpha(50),
          textColor: AppTheme.error,
          icon: Icons.cancel_outlined,
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final IconData? icon;

  _BadgeConfig({
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.icon,
  });
}
