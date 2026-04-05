import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StepByStepFlowWidget extends StatelessWidget {
  final Map<String, dynamic>? route;

  const StepByStepFlowWidget({super.key, required this.route});

  List<Map<String, dynamic>> _buildSteps() {
    final routeType = route?['routeType'] as String? ?? 'bank';
    final provider = route?['provider'] as String? ?? 'Provider';
    final sourceCurrency = route?['sourceCurrency'] as String? ?? 'USD';
    final recipientCurrency = route?['recipientCurrency'] as String? ?? 'PHP';
    final sendAmount = (route?['sendAmount'] as num?)?.toDouble() ?? 500.0;
    final recipientAmount =
        (route?['recipientAmount'] as num?)?.toDouble() ?? 0.0;
    final totalFees = (route?['totalFees'] as num?)?.toDouble() ?? 0.0;
    final transferFee =
        (route?['transferFee'] as num?)?.toDouble() ?? totalFees * 0.6;
    final fxMarkup =
        (route?['fxMarkup'] as num?)?.toDouble() ?? totalFees * 0.3;
    final networkFee =
        (route?['networkFee'] as num?)?.toDouble() ?? totalFees * 0.1;
    final exchangeRate = (route?['exchangeRate'] as num?)?.toDouble() ?? 1.0;
    final deliveryTime = route?['deliveryTime'] as String? ?? '1–2 hours';
    final hops = route?['hops'] as List<dynamic>? ?? [];

    if (routeType == 'crypto' && hops.length > 1) {
      return [
        {
          'step': 1,
          'icon': Icons.account_balance_wallet_outlined,
          'title': 'Initiate transfer',
          'desc':
              'You send $sourceCurrency ${sendAmount.toStringAsFixed(2)} from your account',
          'fee': '$sourceCurrency ${transferFee.toStringAsFixed(2)}',
          'time': 'Instant',
          'status': 'done',
          'amount': '$sourceCurrency ${sendAmount.toStringAsFixed(2)}',
        },
        {
          'step': 2,
          'icon': Icons.currency_bitcoin_rounded,
          'title': 'Convert to crypto',
          'desc': 'Funds converted to USDT via $provider exchange',
          'fee': '$sourceCurrency ${fxMarkup.toStringAsFixed(2)}',
          'time': '~2 min',
          'status': 'active',
          'amount': 'USDT ${(sendAmount * 0.998).toStringAsFixed(2)}',
        },
        {
          'step': 3,
          'icon': Icons.hub_outlined,
          'title': 'On-chain transfer',
          'desc': 'USDT transferred via blockchain network',
          'fee': '$sourceCurrency ${networkFee.toStringAsFixed(2)}',
          'time': '~5 min',
          'status': 'pending',
          'amount': 'USDT ${(sendAmount * 0.997).toStringAsFixed(2)}',
        },
        {
          'step': 4,
          'icon': Icons.swap_horiz_rounded,
          'title': 'Convert to $recipientCurrency',
          'desc':
              'USDT converted to $recipientCurrency at rate ${exchangeRate.toStringAsFixed(4)}',
          'fee': 'Included',
          'time': '~3 min',
          'status': 'pending',
          'amount': '$recipientCurrency ${recipientAmount.toStringAsFixed(2)}',
        },
        {
          'step': 5,
          'icon': Icons.check_circle_outline_rounded,
          'title': 'Recipient credited',
          'desc': 'Funds arrive in recipient\'s account',
          'fee': 'Free',
          'time': deliveryTime,
          'status': 'pending',
          'amount': '$recipientCurrency ${recipientAmount.toStringAsFixed(2)}',
        },
      ];
    }

    return [
      {
        'step': 1,
        'icon': Icons.account_balance_wallet_outlined,
        'title': 'Initiate transfer',
        'desc':
            'You send $sourceCurrency ${sendAmount.toStringAsFixed(2)} to $provider',
        'fee': '$sourceCurrency ${transferFee.toStringAsFixed(2)}',
        'time': 'Instant',
        'status': 'done',
        'amount': '$sourceCurrency ${sendAmount.toStringAsFixed(2)}',
      },
      {
        'step': 2,
        'icon': Icons.verified_user_outlined,
        'title': 'Compliance check',
        'desc': '$provider verifies transaction against AML/KYC rules',
        'fee': 'Included',
        'time': '~5 min',
        'status': 'active',
        'amount': '$sourceCurrency ${sendAmount.toStringAsFixed(2)}',
      },
      {
        'step': 3,
        'icon': Icons.currency_exchange_rounded,
        'title': 'FX conversion',
        'desc':
            '$sourceCurrency converted to $recipientCurrency at ${exchangeRate.toStringAsFixed(4)}',
        'fee': '$sourceCurrency ${fxMarkup.toStringAsFixed(2)}',
        'time': '~2 min',
        'status': 'pending',
        'amount': '$recipientCurrency ${recipientAmount.toStringAsFixed(2)}',
      },
      {
        'step': 4,
        'icon': Icons.account_balance_rounded,
        'title': 'Bank network routing',
        'desc': 'Funds routed through SWIFT/local payment network',
        'fee': '$sourceCurrency ${networkFee.toStringAsFixed(2)}',
        'time': '~20 min',
        'status': 'pending',
        'amount': '$recipientCurrency ${recipientAmount.toStringAsFixed(2)}',
      },
      {
        'step': 5,
        'icon': Icons.check_circle_outline_rounded,
        'title': 'Recipient credited',
        'desc': 'Funds arrive in recipient\'s bank account',
        'fee': 'Free',
        'time': deliveryTime,
        'status': 'pending',
        'amount': '$recipientCurrency ${recipientAmount.toStringAsFixed(2)}',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = _buildSteps();
    final recipientAmount =
        (route?['recipientAmount'] as num?)?.toDouble() ?? 0.0;
    final recipientCurrency = route?['recipientCurrency'] as String? ?? '';
    final sendAmount = (route?['sendAmount'] as num?)?.toDouble() ?? 0.0;
    final sourceCurrency = route?['sourceCurrency'] as String? ?? 'USD';
    final totalFees = (route?['totalFees'] as num?)?.toDouble() ?? 0.0;
    final rankingReason = route?['rankingReason'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F2B7A), AppTheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transfer Flow',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Step-by-step breakdown of your transfer',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(180),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _SummaryChip(
                      label: 'You send',
                      value: '$sourceCurrency ${sendAmount.toStringAsFixed(2)}',
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white54,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    _SummaryChip(
                      label: 'They receive',
                      value:
                          '$recipientCurrency ${recipientAmount.toStringAsFixed(2)}',
                      highlight: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Steps
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transfer Steps',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                ...steps.asMap().entries.map((entry) {
                  final i = entry.key;
                  final step = entry.value;
                  final isLast = i == steps.length - 1;
                  final status = step['status'] as String;
                  final isDone = status == 'done';
                  final isActive = status == 'active';

                  Color dotColor = isDone
                      ? AppTheme.success
                      : isActive
                      ? AppTheme.primary
                      : AppTheme.outlineVariant;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline column
                      Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: dotColor.withAlpha(
                                isDone || isActive ? 255 : 40,
                              ),
                              shape: BoxShape.circle,
                              border: isActive
                                  ? Border.all(
                                      color: AppTheme.primaryContainer,
                                      width: 3,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: isDone
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      '${step['step']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isActive
                                            ? Colors.white
                                            : AppTheme.muted,
                                      ),
                                    ),
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 52,
                              color: isDone
                                  ? AppTheme.success.withAlpha(60)
                                  : AppTheme.outlineVariant,
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? AppTheme.successContainer.withAlpha(80)
                                  : isActive
                                  ? AppTheme.primaryContainer.withAlpha(80)
                                  : AppTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDone
                                    ? AppTheme.success.withAlpha(40)
                                    : isActive
                                    ? AppTheme.primary.withAlpha(40)
                                    : AppTheme.outlineVariant,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      step['icon'] as IconData,
                                      size: 16,
                                      color: isDone
                                          ? AppTheme.success
                                          : isActive
                                          ? AppTheme.primary
                                          : AppTheme.muted,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        step['title'] as String,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              color: isDone || isActive
                                                  ? AppTheme.onSurface
                                                  : AppTheme.muted,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDone
                                            ? AppTheme.success.withAlpha(20)
                                            : isActive
                                            ? AppTheme.primary.withAlpha(20)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: Text(
                                        step['time'] as String,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isDone
                                              ? AppTheme.success
                                              : isActive
                                              ? AppTheme.primary
                                              : AppTheme.muted,
                                        ),
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
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.receipt_outlined,
                                          size: 12,
                                          color: AppTheme.muted,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Fee: ${step['fee']}',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: AppTheme.muted,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      step['amount'] as String,
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            color: isDone
                                                ? AppTheme.success
                                                : isActive
                                                ? AppTheme.primary
                                                : AppTheme.onSurface,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Final received amount card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.secondary.withAlpha(60)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Final received amount',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$recipientCurrency ${recipientAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total fees',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.muted,
                      ),
                    ),
                    Text(
                      '$sourceCurrency ${totalFees.toStringAsFixed(2)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (rankingReason.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withAlpha(40)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppTheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommended because',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rankingReason,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SummaryChip({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: highlight
            ? Colors.white.withAlpha(30)
            : Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlight
              ? Colors.white.withAlpha(80)
              : Colors.white.withAlpha(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withAlpha(160),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
