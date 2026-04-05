import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../data/providers_data.dart';

class ProviderInfoWidget extends StatelessWidget {
  final Map<String, dynamic>? route;

  const ProviderInfoWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = route?['provider'] as String? ?? 'Wise';
    final providerId = route?['providerId'] as String? ?? '';
    final routeTypeLabel = route?['routeTypeLabel'] as String? ?? 'Direct';
    final trustScore = (route?['trustScore'] as num?)?.toDouble() ?? 4.5;
    final payoutMethods =
        (route?['payoutMethods'] as List<dynamic>?)?.cast<String>() ?? [];
    final complianceTags =
        (route?['complianceTags'] as List<dynamic>?)?.cast<String>() ?? [];
    final hops = route?['hops'] as List<dynamic>? ?? [];

    // Try to get rich data from dataset
    final providerData = ProvidersDataset.findById(providerId);

    final tagline =
        providerData?.tagline ??
        'Trusted international money transfer provider.';
    final category = providerData?.categoryLabel ?? 'Transfer Service';
    final popularity = providerData?.popularityScore ?? 70.0;

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
                Icons.verified_outlined,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Text('About $provider', style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 16),

          // Provider header
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: route?['providerLogo'] as String? ?? '',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    semanticLabel:
                        route?['providerLogoSemanticLabel'] as String? ??
                        '$provider logo',
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(provider, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: AppTheme.cryptoAccent,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          trustScore.toStringAsFixed(1),
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Popularity bar
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: popularity / 100,
                              backgroundColor: AppTheme.outlineVariant,
                              color: AppTheme.primary,
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${popularity.toInt()}% popular',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            tagline,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
          ),

          // Route type
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.route_rounded,
                  size: 14,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Route type: ',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.muted,
                  ),
                ),
                Text(
                  routeTypeLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Hop path
          if (hops.length > 1) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.cryptoContainer,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.cryptoAccent.withAlpha(60)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.merge_type_rounded,
                        size: 14,
                        color: AppTheme.cryptoAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Transfer path',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ...hops.asMap().entries.map((entry) {
                    final hop = entry.value as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${hop['from']} → ${hop['to']} via ${hop['provider']}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          // Payout methods
          if (payoutMethods.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Payout methods',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: payoutMethods
                  .map(
                    (m) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        m,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          // Compliance tags
          if (complianceTags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Regulated by',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: complianceTags
                  .map(
                    (t) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successContainer,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            size: 10,
                            color: AppTheme.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            t,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
