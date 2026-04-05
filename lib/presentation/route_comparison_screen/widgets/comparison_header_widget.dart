import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/currencies_data.dart';

class ComparisonHeaderWidget extends StatelessWidget {
  final String sourceCurrency;
  final String destinationCurrency;
  final double amount;
  final int routeCount;

  const ComparisonHeaderWidget({
    super.key,
    required this.sourceCurrency,
    required this.destinationCurrency,
    required this.amount,
    this.routeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final src = CurrenciesDataset.findByCode(sourceCurrency);
    final dst = CurrenciesDataset.findByCode(destinationCurrency);
    final srcFlag = src?.flag ?? '🌐';
    final dstFlag = dst?.flag ?? '🌐';
    // Always use ISO currency code for display — no localized symbols

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          // From
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You send',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(srcFlag, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '$sourceCurrency ${_formatAmount(amount)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  src?.name ?? sourceCurrency,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.muted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Arrow
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: AppTheme.primary,
            ),
          ),
          // To
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Recipient gets',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(dstFlag, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      destinationCurrency,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Text(
                  dst?.name ?? destinationCurrency,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.muted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
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
