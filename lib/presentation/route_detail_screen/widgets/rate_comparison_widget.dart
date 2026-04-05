import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class RateComparisonWidget extends StatelessWidget {
  final Map<String, dynamic>? route;

  const RateComparisonWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exchangeRate = (route?['exchangeRate'] as num?)?.toDouble() ?? 57.42;
    final sourceCurrency = route?['sourceCurrency'] as String? ?? 'USD';
    final recipientCurrency = route?['recipientCurrency'] as String? ?? 'PHP';
    final fxMarkup = (route?['fxMarkup'] as num?)?.toDouble() ?? 0.0;
    final sendAmount = (route?['sendAmount'] as num?)?.toDouble() ?? 500.0;

    // Derive mid-market rate from fxMarkup and sendAmount:
    // fxMarkup (in dest currency) = sendAmount * fxMarginPercent/100 * midRate
    // midRate = exchangeRate / (1 - fxMarginPercent/100)
    // We approximate: midRate ≈ exchangeRate + (fxMarkup / sendAmount)
    final double midMarketRate = sendAmount > 0
        ? exchangeRate + (fxMarkup / sendAmount)
        : exchangeRate;

    final markup = midMarketRate > 0
        ? ((midMarketRate - exchangeRate) / midMarketRate * 100)
        : 0.0;
    final isGoodRate = markup < 1.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.candlestick_chart_outlined,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Text('Exchange Rate', style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _RateRow(
                  label: 'Provider rate',
                  sourceCurrency: sourceCurrency,
                  value:
                      '${exchangeRate.toStringAsFixed(4)} $recipientCurrency',
                  valueColor: AppTheme.onSurface,
                  isHighlighted: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _RateRow(
                  label: 'Mid-market rate',
                  sourceCurrency: sourceCurrency,
                  value:
                      '${midMarketRate.toStringAsFixed(4)} $recipientCurrency',
                  valueColor: AppTheme.muted,
                  isHighlighted: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isGoodRate
                  ? AppTheme.secondaryContainer
                  : AppTheme.warningContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  isGoodRate
                      ? Icons.thumb_up_outlined
                      : Icons.info_outline_rounded,
                  size: 15,
                  color: isGoodRate ? AppTheme.secondary : AppTheme.warning,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isGoodRate
                        ? 'Great rate — only ${markup.toStringAsFixed(2)}% below mid-market'
                        : 'Rate is ${markup.toStringAsFixed(2)}% below mid-market rate',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isGoodRate ? AppTheme.secondary : AppTheme.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  final String label;
  final String sourceCurrency;
  final String value;
  final Color valueColor;
  final bool isHighlighted;

  const _RateRow({
    required this.label,
    required this.sourceCurrency,
    required this.value,
    required this.valueColor,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.muted),
        ),
        Text(
          '1 $sourceCurrency = $value',
          style: TextStyle(
            fontSize: isHighlighted ? 14 : 13,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w400,
            color: valueColor,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
