import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../services/affiliate_service.dart';

class RouteCardWidget extends StatelessWidget {
  final Map<String, dynamic> route;
  final bool isFirst;

  const RouteCardWidget({super.key, required this.route, this.isFirst = false});

  Color _badgeColor(String t) {
    switch (t) {
      case 'recommended':
        return AppTheme.primary;
      case 'cheapest':
      case 'best_rate':
        return AppTheme.secondary;
      case 'fastest':
        return const Color(0xFF7C3AED);
      case 'crypto':
        return AppTheme.cryptoAccent;
      case 'safest':
        return AppTheme.success;
      default:
        return AppTheme.muted;
    }
  }

  IconData _badgeIcon(String t) {
    switch (t) {
      case 'recommended':
        return Icons.star_rounded;
      case 'cheapest':
      case 'best_rate':
        return Icons.savings_rounded;
      case 'fastest':
        return Icons.bolt_rounded;
      case 'crypto':
        return Icons.currency_bitcoin_rounded;
      case 'safest':
        return Icons.verified_rounded;
      default:
        return Icons.account_balance_rounded;
    }
  }

  String _badgeLabel(String t) {
    switch (t) {
      case 'recommended':
        return 'Best overall (highest received)';
      case 'cheapest':
        return 'Cheapest';
      case 'best_rate':
        return 'Best Rate';
      case 'fastest':
        return 'Fastest';
      case 'crypto':
        return 'Crypto';
      case 'safest':
        return 'Balanced';
      default:
        return 'Bank';
    }
  }

  IconData _routeTypeIcon(String t) {
    switch (t) {
      case 'crypto':
        return Icons.currency_bitcoin_rounded;
      case 'hybrid':
        return Icons.merge_type_rounded;
      default:
        return Icons.account_balance_outlined;
    }
  }

  String _categoryLabel(String? cat) {
    switch (cat) {
      case 'cryptoExchange':
        return 'Crypto Exchange';
      case 'mobileWallet':
        return 'Mobile Wallet';
      case 'digitalBank':
        return 'Digital Bank';
      case 'fxSpecialist':
        return 'FX Specialist';
      case 'remittance':
        return 'Remittance';
      default:
        return 'Bank';
    }
  }

  String _ctaLabel(String provider, String badgeType, String routeType) {
    if (badgeType == 'recommended') return 'Send money with $provider';
    if (routeType == 'crypto') return 'Transfer now via $provider';
    return 'Continue with $provider';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRecommended = route['isRecommended'] as bool? ?? false;
    final recipientAmount =
        (route['recipientAmount'] as num?)?.toDouble() ?? 0.0;
    final totalFees = (route['totalFees'] as num?)?.toDouble() ?? 0.0;
    final exchangeRate = (route['exchangeRate'] as num?)?.toDouble() ?? 0.0;
    final deliveryTime = route['deliveryTime'] as String? ?? '—';
    final provider = route['provider'] as String? ?? '—';
    final savingsVsBank = (route['savingsVsBank'] as num?)?.toDouble() ?? 0.0;
    final badgeType = route['badgeType'] as String? ?? 'bank';
    final routeType = route['routeType'] as String? ?? 'bank';
    final recipientCurrency = route['recipientCurrency'] as String? ?? '';
    final sourceCurrency = route['sourceCurrency'] as String? ?? '';
    final sendAmount = (route['sendAmount'] as num?)?.toDouble() ?? 0.0;
    final trustScore = (route['trustScore'] as num?)?.toDouble() ?? 4.0;
    final rankingReason = route['rankingReason'] as String? ?? '';
    final routeTypeLabel = route['routeTypeLabel'] as String? ?? '';
    final providerCategory = route['providerCategory'] as String?;
    final hops = route['hops'] as List<dynamic>? ?? [];
    final payoutMethods =
        (route['payoutMethods'] as List<dynamic>?)?.cast<String>() ?? [];
    final providerId = route['providerId'] as String? ?? provider.toLowerCase();

    final badgeColor = _badgeColor(badgeType);
    final ctaLabel = _ctaLabel(provider, badgeType, routeType);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.routeDetailScreen,
        arguments: route,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: isRecommended
              ? Border.all(color: AppTheme.primary, width: 2)
              : Border.all(color: AppTheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: isRecommended
                  ? AppTheme.primary.withAlpha(25)
                  : Colors.black.withAlpha(8),
              blurRadius: isRecommended ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  // Provider logo
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomImageWidget(
                        imageUrl: route['providerLogo'] as String? ?? '',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        semanticLabel:
                            route['providerLogoSemanticLabel'] as String? ??
                            provider,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(provider, style: theme.textTheme.titleSmall),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              _routeTypeIcon(routeType),
                              size: 11,
                              color: AppTheme.muted,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              routeTypeLabel.isNotEmpty
                                  ? routeTypeLabel
                                  : _categoryLabel(providerCategory),
                              style: theme.textTheme.labelSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: badgeColor.withAlpha(60)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _badgeIcon(badgeType),
                          size: 11,
                          color: badgeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _badgeLabel(badgeType),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: badgeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Urgency label for recommended ────────────────────────────
            if (isRecommended) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.primary.withAlpha(40),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            size: 11,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Most users choose this option',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withAlpha(15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.success.withAlpha(40),
                        ),
                      ),
                      child: Text(
                        'Best value right now',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),
            Container(
              height: 1,
              color: AppTheme.outlineVariant,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            const SizedBox(height: 12),

            // ── Key Metrics ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _MetricCell(
                      label: 'Recipient gets',
                      value:
                          '$recipientCurrency ${_formatAmount(recipientAmount, recipientCurrency)}',
                      valueColor: AppTheme.secondary,
                      valueLarge: true,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: AppTheme.outlineVariant,
                  ),
                  Expanded(
                    child: _MetricCell(
                      label: 'Total cost',
                      value: '$sourceCurrency ${totalFees.toStringAsFixed(2)}',
                      valueColor: totalFees > 15
                          ? AppTheme.error
                          : totalFees < 3
                          ? AppTheme.secondary
                          : AppTheme.onSurface,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: AppTheme.outlineVariant,
                  ),
                  Expanded(
                    child: _MetricCell(
                      label: 'Arrival',
                      value: deliveryTime,
                      valueColor: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── FX Rate row ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.currency_exchange_rounded,
                      size: 12,
                      color: AppTheme.muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'FX Rate: 1 $sourceCurrency = ${exchangeRate.toStringAsFixed(4)} $recipientCurrency',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.muted,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    if (savingsVsBank > 0) ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Save $sourceCurrency ${savingsVsBank.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppTheme.success,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Route path (hops) ────────────────────────────────────────
            if (hops.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _HopPath(hops: hops),
              ),

            // ── Ranking reason ───────────────────────────────────────────
            if (rankingReason.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 12,
                      color: badgeColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        rankingReason,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: badgeColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // ── CTA Button ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Best route: "Save $X → Send now" highlight
                  if (isRecommended && savingsVsBank > 0.01) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withAlpha(18),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.success.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.savings_rounded,
                            size: 14,
                            color: AppTheme.success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Save $sourceCurrency ${savingsVsBank.toStringAsFixed(2)} → Send now',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Main CTA button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        AffiliateService.trackAndRedirect(
                          providerId: providerId,
                          providerName: provider,
                          routeType: routeType,
                          amount: sendAmount,
                          sourceCurrency: sourceCurrency,
                          destinationCurrency: recipientCurrency,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRecommended
                            ? AppTheme.primary
                            : AppTheme.surface,
                        foregroundColor: isRecommended
                            ? Colors.white
                            : AppTheme.primary,
                        side: isRecommended
                            ? null
                            : BorderSide(
                                color: AppTheme.primary.withAlpha(120),
                              ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: isRecommended ? 2 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send_rounded,
                            size: 15,
                            color: isRecommended
                                ? Colors.white
                                : AppTheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              ctaLabel,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Disclaimer
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.open_in_new_rounded,
                        size: 10,
                        color: AppTheme.muted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'You will be redirected to the provider',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Bottom row (trust + rate + details link) ─────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  // Trust score
                  Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 12,
                        color: AppTheme.muted,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        trustScore.toStringAsFixed(1),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: trustScore >= 4.5
                              ? AppTheme.secondary
                              : AppTheme.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Rate
                  Text(
                    'Rate: ${exchangeRate.toStringAsFixed(4)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.muted,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.routeDetailScreen,
                      arguments: route,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'View details',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppTheme.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: AppTheme.muted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount, String currency) {
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

class _HopPath extends StatelessWidget {
  final List<dynamic> hops;
  const _HopPath({required this.hops});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.route_rounded, size: 12, color: AppTheme.muted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              hops.map((h) => '${h['from']}→${h['to']}').join(' · '),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.muted,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool valueLarge;

  const _MetricCell({
    required this.label,
    required this.value,
    required this.valueColor,
    this.valueLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: AppTheme.muted),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: valueLarge
                ? theme.textTheme.titleSmall?.copyWith(
                    color: valueColor,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  )
                : theme.textTheme.labelMedium?.copyWith(
                    color: valueColor,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
