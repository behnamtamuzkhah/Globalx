import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/currencies_data.dart';
import '../../../data/providers_data.dart';
import '../../../data/fx_rates_service.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';

class TransferFormWidget extends StatefulWidget {
  const TransferFormWidget({super.key});

  @override
  State<TransferFormWidget> createState() => _TransferFormWidgetState();
}

class _TransferFormWidgetState extends State<TransferFormWidget>
    with TickerProviderStateMixin {
  final _amountController = TextEditingController(text: '500');
  String _sourceCurrency = 'USD';
  String _destinationCurrency = 'PHP';
  String _fromCountry = 'United States';
  String _toCountry = 'Philippines';
  String _providerType = 'All';
  bool _isLoading = false;
  late AnimationController _swapController;
  late Animation<double> _swapRotation;
  late AnimationController _submitPulseController;
  late Animation<double> _submitPulseAnimation;

  static const _providerTypes = [
    'All',
    'Bank',
    'Digital Bank',
    'Remittance',
    'FX Specialist',
    'Crypto',
    'Mobile Wallet',
  ];

  @override
  void initState() {
    super.initState();
    _swapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _swapRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _swapController, curve: Curves.easeOutCubic),
    );
    _submitPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _submitPulseAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _submitPulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _swapController.dispose();
    _submitPulseController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    _swapController.forward(from: 0);
    setState(() {
      final tempCurrency = _sourceCurrency;
      _sourceCurrency = _destinationCurrency;
      _destinationCurrency = tempCurrency;
      final tempCountry = _fromCountry;
      _fromCountry = _toCountry;
      _toCountry = tempCountry;
    });
  }

  Future<void> _findBestRoute() async {
    if (_amountController.text.isEmpty) return;
    setState(() => _isLoading = true);
    _submitPulseController.repeat(reverse: true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    _submitPulseController.stop();
    _submitPulseController.reset();
    setState(() => _isLoading = false);
    Navigator.pushNamed(
      context,
      AppRoutes.routeComparisonScreen,
      arguments: {
        'sourceCurrency': _sourceCurrency,
        'destinationCurrency': _destinationCurrency,
        'amount': double.tryParse(_amountController.text) ?? 500.0,
        'fromCountry': _fromCountry,
        'toCountry': _toCountry,
        'providerType': _providerType,
      },
    );
  }

  CurrencyData _getCurrency(String code) =>
      CurrenciesDataset.findByCode(code) ??
      CurrencyData(
        code: code,
        name: code,
        country: '',
        flag: '🌐',
        symbol: code,
      );

  void _showCurrencyPicker(bool isSource) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CurrencyPickerSheet(
        selectedCode: isSource ? _sourceCurrency : _destinationCurrency,
        onSelect: (code) {
          final currency = CurrenciesDataset.findByCode(code);
          setState(() {
            if (isSource) {
              _sourceCurrency = code;
              if (currency != null) _fromCountry = currency.country;
            } else {
              _destinationCurrency = code;
              if (currency != null) _toCountry = currency.country;
            }
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  String _estimatedRecipient() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return '0.00';
    final midRate = MockFxRates.getRate(_sourceCurrency, _destinationCurrency);
    if (midRate <= 0) return '—';
    final dest = _getCurrency(_destinationCurrency);
    final estimated = amount * midRate;
    final formatted = _formatAmount(estimated, _destinationCurrency);
    return '${dest.symbol} $formatted';
  }

  String _formatAmount(double amount, String currency) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(2)}M';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final src = _getCurrency(_sourceCurrency);
    final dst = _getCurrency(_destinationCurrency);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transfer Calculator',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Compare ${CurrenciesDataset.all.length}+ currencies · ${ProvidersDataset.all.length}+ providers',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(160),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // You Send + Source Currency
                _SectionLabel(label: 'You Send'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        onChanged: (_) => setState(() {}),
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: AppTheme.onSurface,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: theme.textTheme.displayMedium?.copyWith(
                            color: AppTheme.muted,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppTheme.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppTheme.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppTheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppTheme.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _CurrencyButton(
                      flag: src.flag,
                      code: src.code,
                      symbol: src.symbol,
                      onTap: () => _showCurrencyPicker(true),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // From Country
                _SectionLabel(label: 'From Country'),
                const SizedBox(height: 8),
                _CountryField(
                  value: _fromCountry,
                  flag: src.flag,
                  onTap: () => _showCurrencyPicker(true),
                ),

                // Swap button
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: _swapCurrencies,
                    child: AnimatedBuilder(
                      animation: _swapRotation,
                      builder: (context, child) => Transform.rotate(
                        angle: _swapRotation.value * 3.14159,
                        child: child,
                      ),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: AppTheme.surface, width: 3),
                        ),
                        child: const Icon(
                          Icons.swap_vert_rounded,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Recipient Gets + Destination Currency
                _SectionLabel(label: 'Recipient Gets'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.secondary.withAlpha(80),
                          ),
                        ),
                        child: Text(
                          '≈ ${_estimatedRecipient()}',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: AppTheme.secondary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _CurrencyButton(
                      flag: dst.flag,
                      code: dst.code,
                      symbol: dst.symbol,
                      onTap: () => _showCurrencyPicker(false),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // To Country
                _SectionLabel(label: 'To Country'),
                const SizedBox(height: 8),
                _CountryField(
                  value: _toCountry,
                  flag: dst.flag,
                  onTap: () => _showCurrencyPicker(false),
                ),

                const SizedBox(height: 16),

                // Provider Type
                _SectionLabel(label: 'Provider Type'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _providerTypes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (ctx, i) {
                      final pt = _providerTypes[i];
                      final selected = _providerType == pt;
                      return GestureDetector(
                        onTap: () => setState(() => _providerType = pt),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: selected
                                  ? AppTheme.primary
                                  : AppTheme.outlineVariant,
                            ),
                          ),
                          child: Text(
                            pt,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : AppTheme.muted,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 13,
                      color: AppTheme.muted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Estimated best route · actual amount varies by provider',
                        style: theme.textTheme.labelSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // CTA
                ScaleTransition(
                  scale: _submitPulseAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _findBestRoute,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        disabledBackgroundColor: AppTheme.primary.withAlpha(
                          200,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        ),
                        child: _isLoading
                            ? const _SubmitLoadingIndicator(
                                key: ValueKey('loading'),
                              )
                            : const _SubmitIdleContent(key: ValueKey('idle')),
                      ),
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

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppTheme.muted,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CountryField extends StatelessWidget {
  final String value;
  final String flag;
  final VoidCallback onTap;
  const _CountryField({
    required this.value,
    required this.flag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppTheme.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyButton extends StatelessWidget {
  final String flag;
  final String code;
  final String symbol;
  final VoidCallback onTap;

  const _CurrencyButton({
    required this.flag,
    required this.code,
    required this.symbol,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              code,
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppTheme.muted,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Currency Picker Sheet ─────────────────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final String selectedCode;
  final Function(String) onSelect;

  const _CurrencyPickerSheet({
    required this.selectedCode,
    required this.onSelect,
  });

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  String _search = '';
  bool _showPopularOnly = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CurrencyData> get _filtered {
    if (_search.isEmpty && _showPopularOnly) return CurrenciesDataset.popular;
    if (_search.isEmpty) return CurrenciesDataset.all;
    return CurrenciesDataset.search(_search);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filtered;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
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
                Text('Select Currency', style: theme.textTheme.headlineSmall),
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
              controller: _searchController,
              autofocus: false,
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search by name, code, or country…',
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
                          _searchController.clear();
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
          if (_search.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All Currencies',
                    selected: !_showPopularOnly,
                    onTap: () => setState(() => _showPopularOnly = false),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: '⭐ Popular',
                    selected: _showPopularOnly,
                    onTap: () => setState(() => _showPopularOnly = true),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          if (_search.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${filtered.length} result${filtered.length == 1 ? '' : 's'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 40,
                          color: AppTheme.muted,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No currencies found',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.muted,
                          ),
                        ),
                        Text(
                          'Try a different search term',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemExtent: 68,
                    itemBuilder: (ctx, i) {
                      final c = filtered[i];
                      final isSelected = c.code == widget.selectedCode;
                      return InkWell(
                        onTap: () => widget.onSelect(c.code),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          color: isSelected
                              ? AppTheme.primaryContainer
                              : Colors.transparent,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  c.flag,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      c.name,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            color: isSelected
                                                ? AppTheme.primary
                                                : AppTheme.onSurface,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${c.code} · ${c.country}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: isSelected
                                                ? AppTheme.primary.withAlpha(
                                                    180,
                                                  )
                                                : AppTheme.muted,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                c.symbol,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: isSelected
                                      ? AppTheme.primary
                                      : AppTheme.muted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppTheme.primary,
                                  size: 20,
                                ),
                              ],
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryContainer : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? AppTheme.primary : AppTheme.muted,
          ),
        ),
      ),
    );
  }
}

class _SubmitLoadingIndicator extends StatelessWidget {
  const _SubmitLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
            backgroundColor: Colors.white.withAlpha(60),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Calculating routes...',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _SubmitIdleContent extends StatelessWidget {
  const _SubmitIdleContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.route_rounded, size: 20, color: Colors.white),
        SizedBox(width: 8),
        Text(
          'Find Best Route',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
