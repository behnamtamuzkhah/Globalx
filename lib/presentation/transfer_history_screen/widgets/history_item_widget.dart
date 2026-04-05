import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';
import '../../../routes/app_routes.dart';

class HistoryItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRepeat;

  const HistoryItemWidget({
    super.key,
    required this.item,
    required this.onRepeat,
  });

  BadgeType _statusBadge(String s) {
    switch (s) {
      case 'completed':
        return BadgeType.completed;
      case 'pending':
        return BadgeType.pending;
      default:
        return BadgeType.failed;
    }
  }

  String _formatDate(String dateStr) {
    final d = DateTime.parse(dateStr);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = item['status'] as String;
    final savingsVsBank = item['savingsVsBank'] as double;
    final hasSavings = savingsVsBank > 0;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.routeDetailScreen,
        arguments: {
          'provider': item['provider'],
          'sourceCurrency': item['fromCurrency'],
          'recipientCurrency': item['toCurrency'],
          'sendAmount': item['amountSent'],
          'recipientAmount': item['amountReceived'],
          'totalFees': item['totalFees'],
          'exchangeRate': item['exchangeRate'],
          'badgeType': 'completed',
          'routeType': 'bank',
          'deliveryTime': item['deliveryTime'],
          'transferFee': item['totalFees'],
          'fxMarkup': 0.0,
          'networkFee': 0.0,
          'savingsVsBank': item['savingsVsBank'],
          'providerLogo':
              'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=80&h=80&fit=crop',
          'providerLogoSemanticLabel':
              'Money transfer provider logo on white background',
        },
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: status == 'failed'
              ? Border.all(color: AppTheme.error.withAlpha(60))
              : Border.all(color: AppTheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Currency pair flags
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item['fromFlag'] as String,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 12,
                        color: AppTheme.muted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['toFlag'] as String,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item['fromCurrency']} → ${item['toCurrency']}',
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        '${item['provider']} · ${_formatDate(item['date'] as String)}',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                StatusBadgeWidget(type: _statusBadge(status), compact: true),
              ],
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: AppTheme.outlineVariant),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sent', style: theme.textTheme.labelSmall),
                      const SizedBox(height: 2),
                      Text(
                        '${item['fromCurrency']} ${(item['amountSent'] as double).toStringAsFixed(2)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Received', style: theme.textTheme.labelSmall),
                      const SizedBox(height: 2),
                      Text(
                        '${item['toCurrency']} ${_formatAmount(item['amountReceived'] as double)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.secondary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fees', style: theme.textTheme.labelSmall),
                      const SizedBox(height: 2),
                      Text(
                        '\$${(item['totalFees'] as double).toStringAsFixed(2)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onRepeat,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          size: 13,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Repeat',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (hasSavings) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.trending_down_rounded,
                    size: 13,
                    color: AppTheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Saved \$${savingsVsBank.toStringAsFixed(2)} vs bank wire',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
