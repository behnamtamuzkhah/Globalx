import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/currencies_data.dart';
import '../../../services/affiliate_service.dart';

class SavingsBannerWidget extends StatelessWidget {
  final Map<String, dynamic>? bestRoute;
  final String sourceCurrency;
  final String destinationCurrency;
  final double amount;

  const SavingsBannerWidget({
    super.key,
    this.bestRoute,
    this.sourceCurrency = 'USD',
    this.destinationCurrency = 'PHP',
    this.amount = 500.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (bestRoute == null) return const SizedBox.shrink();

    final savings = (bestRoute!['savingsVsBank'] as num?)?.toDouble() ?? 0.0;
    final provider = bestRoute!['provider'] as String? ?? 'Best provider';
    final providerId =
        bestRoute!['providerId'] as String? ?? provider.toLowerCase();
    final recipientAmount =
        (bestRoute!['recipientAmount'] as num?)?.toDouble() ?? 0.0;
    final exchangeRate =
        (bestRoute!['exchangeRate'] as num?)?.toDouble() ?? 0.0;
    final deliveryTime = bestRoute!['deliveryTime'] as String? ?? '—';
    final totalFees = (bestRoute!['totalFees'] as num?)?.toDouble() ?? 0.0;
    final routeType = bestRoute!['routeType'] as String? ?? 'bank';
    final recipientCurrency =
        bestRoute!['recipientCurrency'] as String? ?? destinationCurrency;
    final src = CurrenciesDataset.findByCode(sourceCurrency);
    final dst = CurrenciesDataset.findByCode(destinationCurrency);
    final srcCode = sourceCurrency;
    final dstCode = destinationCurrency;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A1F5C), Color(0xFF1B4FD8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withAlpha(35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 11,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'BEST ROUTE',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Urgency chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80).withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF4ADE80).withAlpha(60),
                    ),
                  ),
                  child: Text(
                    'Best value right now',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF4ADE80),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'via $provider',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withAlpha(180),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recipient gets',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withAlpha(160),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$dstCode ${_formatAmount(recipientAmount)}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (savings > 0.01)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.success.withAlpha(80)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Save vs worst route',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withAlpha(160),
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '$srcCode ${savings.toStringAsFixed(2)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF4ADE80),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (savings > 0.01) ...[
              const SizedBox(height: 6),
              Text(
                'Compared to the worst available route',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withAlpha(120),
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(height: 1, color: Colors.white.withAlpha(20)),
            const SizedBox(height: 10),
            Row(
              children: [
                _MetricChip(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Rate',
                  value: exchangeRate > 0
                      ? exchangeRate.toStringAsFixed(4)
                      : '—',
                ),
                const SizedBox(width: 16),
                _MetricChip(
                  icon: Icons.schedule_rounded,
                  label: 'Arrival',
                  value: deliveryTime,
                ),
                const SizedBox(width: 16),
                _MetricChip(
                  icon: Icons.receipt_long_rounded,
                  label: 'Fees',
                  value: totalFees > 0
                      ? '$srcCode ${totalFees.toStringAsFixed(2)}'
                      : '$srcCode 0.00',
                ),
              ],
            ),
            const SizedBox(height: 14),
            // ── Best Action CTA ──────────────────────────────────────────
            if (savings > 0.01) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ADE80).withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF4ADE80).withAlpha(60),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.savings_rounded,
                      size: 14,
                      color: Color(0xFF4ADE80),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Save $srcCode ${savings.toStringAsFixed(2)} → Send now',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AffiliateService.trackAndRedirect(
                    providerId: providerId,
                    providerName: provider,
                    routeType: routeType,
                    amount: amount,
                    sourceCurrency: srcCode,
                    destinationCurrency: dstCode,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, size: 16),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Send money with $provider',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.open_in_new_rounded,
                  size: 10,
                  color: Colors.white.withAlpha(120),
                ),
                const SizedBox(width: 4),
                Text(
                  'You will be redirected to the provider',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withAlpha(120),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
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

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.white.withAlpha(160)),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withAlpha(160),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
