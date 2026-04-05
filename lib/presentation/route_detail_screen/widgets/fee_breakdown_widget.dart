import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class FeeBreakdownWidget extends StatelessWidget {
  final Map<String, dynamic>? route;

  const FeeBreakdownWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transferFee = (route?['transferFee'] as num?)?.toDouble() ?? 4.14;
    final fxMarkup = (route?['fxMarkup'] as num?)?.toDouble() ?? 0.0;
    final networkFee = (route?['networkFee'] as num?)?.toDouble() ?? 0.0;
    final totalFees = (route?['totalFees'] as num?)?.toDouble() ?? 4.14;
    final sendAmount = (route?['sendAmount'] as num?)?.toDouble() ?? 500.0;
    final sourceCurrency = route?['sourceCurrency'] as String? ?? 'USD';

    final List<Map<String, dynamic>> feeLines = [
      {
        'label': 'Transfer fee',
        'description': 'Service charge for processing',
        'amount': transferFee,
        'icon': Icons.receipt_long_outlined,
        'isFree': false,
      },
      {
        'label': 'FX markup',
        'description': 'Difference from mid-market rate',
        'amount': fxMarkup,
        'icon': Icons.currency_exchange_rounded,
        'isFree': fxMarkup == 0.0,
      },
      {
        'label': 'Network fee',
        'description': 'Blockchain/network processing',
        'amount': networkFee,
        'icon': Icons.hub_outlined,
        'isFree': networkFee == 0.0,
      },
      {
        'label': 'Recipient fee',
        'description': 'Charged by receiving bank',
        'amount': 0.0,
        'icon': Icons.account_balance_wallet_outlined,
        'isFree': true,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text('Fee Breakdown', style: theme.textTheme.titleSmall),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'You send',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.muted,
                    ),
                  ),
                  Text(
                    '$sourceCurrency ${sendAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...feeLines.map((fee) {
            final amount = fee['amount'] as double;
            final isFree = fee['isFree'] as bool;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.outlineVariant, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      fee['icon'] as IconData,
                      size: 16,
                      color: AppTheme.muted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fee['label'] as String,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          fee['description'] as String,
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    isFree
                        ? 'Included'
                        : '$sourceCurrency ${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isFree ? AppTheme.success : AppTheme.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.outlineVariant, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total fees',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$sourceCurrency ${totalFees.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: totalFees > 10 ? AppTheme.error : AppTheme.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
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
