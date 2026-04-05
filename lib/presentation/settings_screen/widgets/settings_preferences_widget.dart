import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/currencies_data.dart';

class SettingsPreferencesWidget extends StatefulWidget {
  const SettingsPreferencesWidget({super.key});

  @override
  State<SettingsPreferencesWidget> createState() =>
      _SettingsPreferencesWidgetState();
}

class _SettingsPreferencesWidgetState extends State<SettingsPreferencesWidget> {
  String _homeCurrency = 'USD';
  String _preferredMethod = 'Best overall';

  static const _methods = [
    'Best overall',
    'Cheapest fees',
    'Fastest delivery',
    'Best exchange rate',
    'Crypto routes',
    'Bank transfer only',
    'Mobile wallet',
  ];

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _HomeCurrencyPicker(
        selectedCode: _homeCurrency,
        onSelect: (code) {
          setState(() => _homeCurrency = code);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showMethodPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferred Method',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ..._methods.map(
              (m) => InkWell(
                onTap: () {
                  setState(() => _preferredMethod = m);
                  Navigator.pop(ctx);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          m,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      if (_preferredMethod == m)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeCurrencyData = CurrenciesDataset.findByCode(_homeCurrency);
    final flag = homeCurrencyData?.flag ?? '🌐';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _SectionHeader(label: 'Transfer Preferences'),
          ),
          _SettingsRow(
            icon: Icons.currency_exchange_rounded,
            iconColor: AppTheme.primary,
            title: 'Home Currency',
            subtitle:
                'Default send currency · ${CurrenciesDataset.all.length} currencies available',
            trailing: InkWell(
              onTap: _showCurrencyPicker,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      _homeCurrency,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: AppTheme.muted,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(indent: 52),
          _SettingsRow(
            icon: Icons.tune_rounded,
            iconColor: AppTheme.secondary,
            title: 'Preferred Method',
            subtitle: 'How to sort transfer routes',
            trailing: InkWell(
              onTap: _showMethodPicker,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _preferredMethod.length > 14
                          ? '${_preferredMethod.substring(0, 14)}…'
                          : _preferredMethod,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: AppTheme.muted,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(indent: 52),
          _SettingsRow(
            icon: Icons.language_rounded,
            iconColor: AppTheme.cryptoAccent,
            title: 'Currency Coverage',
            subtitle:
                '${CurrenciesDataset.all.length} ISO 4217 currencies supported',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.successContainer,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Full',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Compact currency picker for settings ─────────────────────────────────────

class _HomeCurrencyPicker extends StatefulWidget {
  final String selectedCode;
  final Function(String) onSelect;

  const _HomeCurrencyPicker({
    required this.selectedCode,
    required this.onSelect,
  });

  @override
  State<_HomeCurrencyPicker> createState() => _HomeCurrencyPickerState();
}

class _HomeCurrencyPickerState extends State<_HomeCurrencyPicker> {
  String _search = '';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<CurrencyData> get _filtered => CurrenciesDataset.search(_search);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filtered;

    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.outlineVariant,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('Home Currency', style: theme.textTheme.headlineSmall),
                const Spacer(),
                Text(
                  '${CurrenciesDataset.all.length} currencies',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _controller,
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search currency…',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppTheme.muted,
                  size: 20,
                ),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          size: 18,
                          color: AppTheme.muted,
                        ),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _search = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemExtent: 60,
              itemBuilder: (ctx, i) {
                final c = filtered[i];
                final isSelected = c.code == widget.selectedCode;
                return InkWell(
                  onTap: () => widget.onSelect(c.code),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    color: isSelected
                        ? AppTheme.primaryContainer
                        : Colors.transparent,
                    child: Row(
                      children: [
                        Text(c.flag, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                c.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: isSelected ? AppTheme.primary : null,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${c.code} · ${c.country}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.muted,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppTheme.muted,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}
