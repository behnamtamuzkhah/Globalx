import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class DetailHeaderWidget extends StatelessWidget {
  final Map<String, dynamic>? route;

  const DetailHeaderWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recipientAmount = route?['recipientAmount'] as double? ?? 28620.0;
    final recipientCurrency = route?['recipientCurrency'] as String? ?? 'PHP';
    final sendAmount = route?['sendAmount'] as double? ?? 500.0;
    final sourceCurrency = route?['sourceCurrency'] as String? ?? 'USD';
    final badgeType = route?['badgeType'] as String? ?? 'recommended';

    BadgeType badge;
    switch (badgeType) {
      case 'recommended':
        badge = BadgeType.recommended;
        break;
      case 'cheapest':
        badge = BadgeType.cheapest;
        break;
      case 'fastest':
        badge = BadgeType.fastest;
        break;
      case 'safest':
        badge = BadgeType.safest;
        break;
      case 'crypto':
        badge = BadgeType.crypto;
        break;
      default:
        badge = BadgeType.bank;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transfer Summary',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white.withAlpha(200),
                ),
              ),
              StatusBadgeWidget(type: badge),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You send',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white.withAlpha(170),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$sourceCurrency ${_formatAmount(sendAmount)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Recipient gets',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white.withAlpha(170),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$recipientCurrency ${_formatAmount(recipientAmount)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Format amount with thousands separator, 2 decimal places for < 1000
  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    }
    if (amount >= 1000) {
      final s = amount.toStringAsFixed(0);
      final buf = StringBuffer();
      int count = 0;
      for (int i = s.length - 1; i >= 0; i--) {
        if (count > 0 && count % 3 == 0) buf.write(',');
        buf.write(s[i]);
        count++;
      }
      return buf.toString().split('').reversed.join();
    }
    return amount.toStringAsFixed(2);
  }
}
