import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/currencies_data.dart';
import '../../../data/providers_data.dart';
import '../../../data/fx_rates_service.dart';

/// Demo Transparency & Data Status widget for Settings screen.
/// Clearly communicates mock data status and future API integration readiness.
class SettingsDemoTransparencyWidget extends StatefulWidget {
  const SettingsDemoTransparencyWidget({super.key});

  @override
  State<SettingsDemoTransparencyWidget> createState() =>
      _SettingsDemoTransparencyWidgetState();
}

class _SettingsDemoTransparencyWidgetState
    extends State<SettingsDemoTransparencyWidget> {
  bool _expanded = false;

  /// True when a real OXR API key is configured.
  bool get _liveRatesActive => !FxRatesService.useMockRates;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _liveRatesActive
              ? AppTheme.success.withAlpha(80)
              : AppTheme.cryptoAccent.withAlpha(80),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _liveRatesActive
                          ? AppTheme.success.withAlpha(25)
                          : AppTheme.cryptoAccent.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _liveRatesActive
                          ? Icons.wifi_rounded
                          : Icons.science_outlined,
                      size: 18,
                      color: _liveRatesActive
                          ? AppTheme.success
                          : AppTheme.cryptoAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _liveRatesActive ? 'Live Mode' : 'Demo Mode',
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _liveRatesActive
                                    ? AppTheme.success.withAlpha(25)
                                    : AppTheme.cryptoContainer,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                _liveRatesActive ? 'LIVE' : 'DEMO',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _liveRatesActive
                                      ? AppTheme.success
                                      : AppTheme.warning,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _liveRatesActive
                              ? 'Open Exchange Rates API connected'
                              : 'Rates & providers are simulated',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.muted,
                  ),
                ],
              ),
            ),
          ),

          if (_expanded) ...[
            Container(height: 1, color: AppTheme.outlineVariant),

            // Data stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Dataset',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _StatRow(
                    icon: Icons.language_rounded,
                    iconColor: AppTheme.primary,
                    label: 'Currencies',
                    value: '${CurrenciesDataset.all.length} ISO 4217',
                    status: 'Mock',
                    statusColor: AppTheme.warning,
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    icon: Icons.business_rounded,
                    iconColor: AppTheme.secondary,
                    label: 'Providers',
                    value: '${ProvidersDataset.all.length} across 6 categories',
                    status: 'Mock',
                    statusColor: AppTheme.warning,
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    icon: Icons.route_rounded,
                    iconColor: _liveRatesActive
                        ? AppTheme.success
                        : AppTheme.cryptoAccent,
                    label: 'FX Rates',
                    value: _liveRatesActive
                        ? 'Open Exchange Rates (live, 30-min cache)'
                        : 'Simulated mid-market',
                    status: _liveRatesActive ? 'Live' : 'Mock',
                    statusColor: _liveRatesActive
                        ? AppTheme.success
                        : AppTheme.warning,
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    icon: Icons.account_balance_rounded,
                    iconColor: AppTheme.success,
                    label: 'Compliance data',
                    value: 'Regulatory tags included',
                    status: 'Structured',
                    statusColor: AppTheme.success,
                  ),

                  const SizedBox(height: 16),
                  Container(height: 1, color: AppTheme.outlineVariant),
                  const SizedBox(height: 16),

                  Text(
                    'Live API Readiness',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _ApiReadinessRow(
                    label: 'Wise API',
                    description: 'Real-time rates & transfer quotes',
                    ready: true,
                  ),
                  _ApiReadinessRow(
                    label: 'Remitly API',
                    description: 'Live corridor pricing',
                    ready: true,
                  ),
                  _ApiReadinessRow(
                    label: 'Open Exchange Rates',
                    description: _liveRatesActive
                        ? 'Connected — mid-market FX rates active'
                        : 'Set OPEN_EXCHANGE_RATES_API_KEY to activate',
                    ready: _liveRatesActive,
                    isConnected: _liveRatesActive,
                  ),
                  _ApiReadinessRow(
                    label: 'Binance API',
                    description: 'Crypto spot prices',
                    ready: true,
                  ),

                  const SizedBox(height: 16),

                  // Info note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _liveRatesActive
                          ? AppTheme.success.withAlpha(15)
                          : AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _liveRatesActive
                              ? Icons.check_circle_outline_rounded
                              : Icons.info_outline_rounded,
                          size: 16,
                          color: _liveRatesActive
                              ? AppTheme.success
                              : AppTheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _liveRatesActive
                                ? 'Live FX rates are active via Open Exchange Rates API. Rates are cached for 30 minutes and fall back to mock data if the API is unreachable.'
                                : 'To activate live FX rates, set OPEN_EXCHANGE_RATES_API_KEY in your build config. Get a free key at openexchangerates.org. The app falls back to mock rates automatically.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _liveRatesActive
                                  ? AppTheme.success
                                  : AppTheme.primary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String status;
  final Color statusColor;

  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelMedium),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(20),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: statusColor.withAlpha(60)),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _ApiReadinessRow extends StatelessWidget {
  final String label;
  final String description;
  final bool ready;
  final bool isConnected;

  const _ApiReadinessRow({
    required this.label,
    required this.description,
    required this.ready,
    this.isConnected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isConnected
                ? Icons.wifi_rounded
                : ready
                ? Icons.check_circle_outline_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 16,
            color: isConnected
                ? AppTheme.success
                : ready
                ? AppTheme.success
                : AppTheme.muted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            isConnected
                ? 'Connected'
                : ready
                ? 'Ready'
                : 'Pending',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isConnected
                  ? AppTheme.success
                  : ready
                  ? AppTheme.success
                  : AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}
