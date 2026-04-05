import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class RateTickerWidget extends StatefulWidget {
  const RateTickerWidget({super.key});

  @override
  State<RateTickerWidget> createState() => _RateTickerWidgetState();
}

class _RateTickerWidgetState extends State<RateTickerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final List<Map<String, dynamic>> _rates = [
    {'pair': 'USD/PHP', 'rate': '57.24', 'change': '+0.12', 'positive': true},
    {'pair': 'GBP/INR', 'rate': '108.63', 'change': '-0.34', 'positive': false},
    {'pair': 'EUR/MXN', 'rate': '19.87', 'change': '+0.08', 'positive': true},
    {
      'pair': 'USD/NGN',
      'rate': '1,587.40',
      'change': '+2.10',
      'positive': true,
    },
    {'pair': 'AUD/VND', 'rate': '16,240', 'change': '-45.0', 'positive': false},
    {'pair': 'CAD/BDT', 'rate': '82.15', 'change': '+0.22', 'positive': true},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, child) => Opacity(
                  opacity: _pulseAnim.value,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Market Rates',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '· Indicative mid-market',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _rates.asMap().entries.map((entry) {
                final rate = entry.value;
                final isPositive = rate['positive'] as bool;
                return Container(
                  margin: EdgeInsets.only(
                    right: entry.key < _rates.length - 1 ? 20 : 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        rate['pair'] as String,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        rate['rate'] as String,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isPositive
                              ? AppTheme.successContainer
                              : AppTheme.errorContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          rate['change'] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isPositive
                                ? AppTheme.success
                                : AppTheme.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
