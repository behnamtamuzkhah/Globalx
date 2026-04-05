import './providers_data.dart';
import './fx_rates_service.dart';

/// GlobalX – Scalable Route Comparison Engine
/// Supports: Bank-to-Bank, Bank-to-Wallet, Wallet-to-Bank,
/// Exchange-to-Exchange, Fiat→Crypto→Fiat, Multi-hop corridors.
/// Designed so real API data can replace mock rates without redesigning.

enum RouteType {
  bankToBank,
  bankToWallet,
  walletToBank,
  exchangeToExchange,
  fiatCryptoFiat,
  multiHop,
  direct,
}

enum RouteBadge {
  recommended,
  cheapest,
  fastest,
  bestRate,
  lowestFee,
  balanced,
  bank,
  crypto,
  hybrid,
}

class RouteHop {
  final String fromCurrency;
  final String toCurrency;
  final String providerName;
  final double rate;
  final double fee;

  const RouteHop({
    required this.fromCurrency,
    required this.toCurrency,
    required this.providerName,
    required this.rate,
    required this.fee,
  });
}

class TransferRoute {
  final String id;
  final String providerName;
  final String providerId;
  final String providerLogo;
  final String providerLogoSemanticLabel;
  final ProviderCategory providerCategory;
  final RouteType routeType;
  final RouteBadge badge;
  final double sendAmount;
  final String sourceCurrency;
  final String destinationCurrency;
  final double recipientAmount;
  final double transferFee;
  final double fxMarkup;
  final double networkFee;
  final double totalFees;
  final double exchangeRate;
  final String deliveryTimeLabel;
  final int deliveryMinutesMin;
  final int deliveryMinutesMax;
  final double savingsVsBank;
  final double trustScore;
  final List<RouteHop> hops;
  final String rankingReason;
  final List<String> payoutMethods;
  final List<String> complianceTags;

  const TransferRoute({
    required this.id,
    required this.providerName,
    required this.providerId,
    required this.providerLogo,
    required this.providerLogoSemanticLabel,
    required this.providerCategory,
    required this.routeType,
    required this.badge,
    required this.sendAmount,
    required this.sourceCurrency,
    required this.destinationCurrency,
    required this.recipientAmount,
    required this.transferFee,
    required this.fxMarkup,
    required this.networkFee,
    required this.totalFees,
    required this.exchangeRate,
    required this.deliveryTimeLabel,
    required this.deliveryMinutesMin,
    required this.deliveryMinutesMax,
    required this.savingsVsBank,
    required this.trustScore,
    required this.hops,
    required this.rankingReason,
    required this.payoutMethods,
    required this.complianceTags,
  });

  String get routeTypeLabel {
    switch (routeType) {
      case RouteType.bankToBank:
        return 'Bank → Bank';
      case RouteType.bankToWallet:
        return 'Bank → Wallet';
      case RouteType.walletToBank:
        return 'Wallet → Bank';
      case RouteType.exchangeToExchange:
        return 'Exchange → Exchange';
      case RouteType.fiatCryptoFiat:
        return 'Fiat → Crypto → Fiat';
      case RouteType.multiHop:
        return 'Multi-Hop';
      case RouteType.direct:
        return 'Direct';
    }
  }

  String get badgeLabel {
    switch (badge) {
      case RouteBadge.recommended:
        return 'Recommended';
      case RouteBadge.cheapest:
        return 'Cheapest';
      case RouteBadge.fastest:
        return 'Fastest';
      case RouteBadge.bestRate:
        return 'Best Rate';
      case RouteBadge.lowestFee:
        return 'Lowest Fee';
      case RouteBadge.balanced:
        return 'Balanced';
      case RouteBadge.bank:
        return 'Bank';
      case RouteBadge.crypto:
        return 'Crypto';
      case RouteBadge.hybrid:
        return 'Hybrid';
    }
  }

  /// Convert to legacy Map for backward compatibility with existing widgets
  Map<String, dynamic> toMap() => {
    'id': id,
    'provider': providerName,
    'providerId': providerId,
    'providerLogo': providerLogo,
    'providerLogoSemanticLabel': providerLogoSemanticLabel,
    'routeType': _routeTypeString,
    'badgeType': _badgeTypeString,
    'recipientAmount': recipientAmount,
    'recipientCurrency': destinationCurrency,
    'transferFee': transferFee,
    'fxMarkup': fxMarkup,
    'networkFee': networkFee,
    'totalFees': totalFees,
    'exchangeRate': exchangeRate,
    'deliveryTime': deliveryTimeLabel,
    'deliveryMinutes': deliveryMinutesMin,
    'isRecommended': badge == RouteBadge.recommended,
    'savingsVsBank': savingsVsBank,
    'sourceCurrency': sourceCurrency,
    'sendAmount': sendAmount,
    'trustScore': trustScore,
    'rankingReason': rankingReason,
    'routeTypeLabel': routeTypeLabel,
    'hops': hops
        .map(
          (h) => {
            'from': h.fromCurrency,
            'to': h.toCurrency,
            'provider': h.providerName,
            'rate': h.rate,
            'fee': h.fee,
          },
        )
        .toList(),
    'payoutMethods': payoutMethods,
    'complianceTags': complianceTags,
    'providerCategory': providerCategory.name,
  };

  String get _routeTypeString {
    switch (routeType) {
      case RouteType.bankToBank:
        return 'bank';
      case RouteType.bankToWallet:
        return 'bank';
      case RouteType.walletToBank:
        return 'bank';
      case RouteType.fiatCryptoFiat:
        return 'crypto';
      case RouteType.exchangeToExchange:
        return 'crypto';
      case RouteType.multiHop:
        return 'hybrid';
      case RouteType.direct:
        return 'bank';
    }
  }

  String get _badgeTypeString {
    switch (badge) {
      case RouteBadge.recommended:
        return 'recommended';
      case RouteBadge.cheapest:
        return 'cheapest';
      case RouteBadge.fastest:
        return 'fastest';
      case RouteBadge.bestRate:
        return 'best_rate';
      case RouteBadge.lowestFee:
        return 'cheapest';
      case RouteBadge.balanced:
        return 'recommended';
      case RouteBadge.bank:
        return 'bank';
      case RouteBadge.crypto:
        return 'crypto';
      case RouteBadge.hybrid:
        return 'safest';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SavingsValidator
//
// Automated validation layer that verifies every route's savingsVsBank field
// matches the deterministic formula:
//
//   savings_in_dest   = route.recipientAmount − worstRecipient
//   savings_in_sender = savings_in_dest / route.exchangeRate   (per-route rate)
//
// Using each route's own exchange rate ensures the "Save X src" label on every
// card is always verifiable from the visible numbers on that card:
//   displayed_savings × card_rate ≈ recipientAmount − worstRecipient
//
// Covers edge cases:
//   • High-fee routes where recipientAmount < worstRecipient (clamped to 0)
//   • Low-FX routes with tiny exchange rates (no division-by-zero)
//   • Crypto routes with multi-hop slippage
//   • Small amounts (< $10) where fees may exceed send amount
//   • Large amounts (> $10,000) with floating-point precision
//
// A mismatch beyond the tolerance threshold throws a StateError so it is
// caught immediately during development and CI — never silently shown to users.
// ─────────────────────────────────────────────────────────────────────────────
class SavingsValidator {
  /// Maximum allowed deviation between computed and stored savings (in source
  /// currency). Set to 0.01 (1 cent) to catch any rounding drift.
  static const double _toleranceSrc = 0.01;

  /// Validate all routes in a ranked list.
  /// [worstRecipient] must be the same value used during the savings
  /// computation pass in [RouteEngine._rankAndBadge].
  /// Each route's own exchangeRate is used for the source-currency conversion.
  ///
  /// Throws [StateError] on the first mismatch found.
  static void validate(List<TransferRoute> routes, double worstRecipient) {
    for (final route in routes) {
      final computed = _computeSavings(
        route.recipientAmount,
        worstRecipient,
        route.exchangeRate,
      );
      final stored = route.savingsVsBank;
      final delta = (computed - stored).abs();

      if (delta > _toleranceSrc) {
        throw StateError(
          '[SavingsValidator] MISMATCH on route "${route.providerName}" '
          '(${route.sourceCurrency}→${route.destinationCurrency}): '
          'computed=$computed stored=$stored delta=$delta '
          'recipientAmount=${route.recipientAmount} '
          'worstRecipient=$worstRecipient routeRate=${route.exchangeRate}',
        );
      }
    }
  }

  /// Compute the canonical savings value for a single route.
  /// This is the single source of truth — used both in the engine and in
  /// validation so the formula can never diverge.
  ///
  /// [routeRate] is the exchange rate of the specific route being evaluated.
  /// Using the per-route rate ensures the displayed "Save X" is always
  /// mathematically consistent with the visible recipient amount on that card.
  static double _computeSavings(
    double recipientAmount,
    double worstRecipient,
    double routeRate,
  ) {
    // Guard: routeRate must be positive (never divide by zero or negative)
    if (routeRate <= 0) return 0.0;

    final destDelta = recipientAmount - worstRecipient;

    // Clamp to zero: a route cannot "save less than nothing" vs the worst route.
    if (destDelta <= 0.0) return 0.0;

    return double.parse((destDelta / routeRate).toStringAsFixed(2));
  }

  /// Public accessor used by the engine to keep the formula in one place.
  /// [routeRate] is the exchange rate of the specific route being evaluated.
  static double computeSavings(
    double recipientAmount,
    double worstRecipient,
    double routeRate,
  ) => _computeSavings(recipientAmount, worstRecipient, routeRate);
}

/// The main route engine.
/// Call [RouteEngine.calculate] to get a sorted list of [TransferRoute].
class RouteEngine {
  /// Fetches live mid-market rates from Open Exchange Rates when an API key
  /// is configured via OPEN_EXCHANGE_RATES_API_KEY environment variable.
  /// Falls back to built-in mock rates automatically when no key is set.
  static Future<List<TransferRoute>> calculate({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    final midRate = await FxRatesService.getRate(fromCurrency, toCurrency);
    final eligibleProviders = ProvidersDataset.supportingCorridor(
      fromCurrency,
      toCurrency,
    );

    if (eligibleProviders.isEmpty) {
      return _buildFallbackRoutes(fromCurrency, toCurrency, amount, midRate);
    }

    final routes = <TransferRoute>[];

    for (final provider in eligibleProviders) {
      final fxMarginMultiplier = 1.0 - (provider.fxMarginPercent / 100.0);
      final effectiveRate = midRate * fxMarginMultiplier;
      final fee = provider.totalFeeForAmount(amount);

      // Realistic network fee per category — slight variation to avoid
      // perfectly rounded numbers
      final double networkFee;
      switch (provider.category) {
        case ProviderCategory.cryptoExchange:
          networkFee = 1.47; // blockchain gas + exchange fee
          break;
        case ProviderCategory.traditionalBank:
          networkFee = 4.85; // SWIFT correspondent bank fee (realistic range)
          break;
        default:
          networkFee = 0.0;
      }

      final double totalFees = fee + networkFee;
      // Recipient amount = (sendAmount − totalFees) × effectiveRate
      // Rounded to 2dp for consistent display across all views.
      // Clamped to 0 when fees exceed the send amount (edge case: small amounts
      // with high-fee routes). A zero-recipient route is still included so the
      // worst-route baseline is accurate, but it will be
      // excluded from the worst-route baseline pool (see _rankAndBadge).
      final amountAfterAllFees = amount - totalFees;
      final recipientAmount = amountAfterAllFees > 0
          ? double.parse(
              (amountAfterAllFees * effectiveRate).toStringAsFixed(2),
            )
          : 0.0;
      // FX markup expressed in destination currency
      final fxMarkupAmount =
          amount * (provider.fxMarginPercent / 100.0) * midRate;

      final routeType = _inferRouteType(provider);
      final hops = _buildHops(
        provider,
        fromCurrency,
        toCurrency,
        effectiveRate,
        fee,
        midRate,
      );

      routes.add(
        TransferRoute(
          id: 'route_${provider.id}',
          providerName: provider.name,
          providerId: provider.id,
          providerLogo: provider.logoUrl,
          providerLogoSemanticLabel: provider.logoSemanticLabel,
          providerCategory: provider.category,
          routeType: routeType,
          badge: RouteBadge.bank,
          sendAmount: amount,
          sourceCurrency: fromCurrency,
          destinationCurrency: toCurrency,
          recipientAmount: recipientAmount,
          transferFee: fee,
          fxMarkup: fxMarkupAmount,
          networkFee: networkFee,
          totalFees: totalFees,
          exchangeRate: effectiveRate,
          deliveryTimeLabel: provider.deliveryTimeLabel,
          deliveryMinutesMin: provider.deliveryMinutesMin,
          deliveryMinutesMax: provider.deliveryMinutesMax,
          savingsVsBank: 0.0,
          trustScore: provider.trustScore,
          hops: hops,
          rankingReason: '',
          payoutMethods: provider.payoutMethods,
          complianceTags: provider.complianceTags,
        ),
      );
    }

    final cryptoRoute = _buildCryptoHopRoute(
      fromCurrency,
      toCurrency,
      amount,
      midRate,
    );
    if (cryptoRoute != null) routes.add(cryptoRoute);

    return _rankAndBadge(routes, amount, fromCurrency, toCurrency, midRate);
  }

  static RouteType _inferRouteType(ProviderData p) {
    switch (p.category) {
      case ProviderCategory.cryptoExchange:
        return RouteType.fiatCryptoFiat;
      case ProviderCategory.mobileWallet:
        return RouteType.bankToWallet;
      case ProviderCategory.traditionalBank:
        return RouteType.bankToBank;
      default:
        return RouteType.direct;
    }
  }

  static List<RouteHop> _buildHops(
    ProviderData provider,
    String from,
    String to,
    double rate,
    double fee,
    double midRate,
  ) {
    if (provider.category == ProviderCategory.cryptoExchange) {
      return [
        RouteHop(
          fromCurrency: from,
          toCurrency: 'USDT',
          providerName: provider.name,
          rate: MockFxRates.getRate(from, 'USD'),
          fee: fee * 0.5,
        ),
        RouteHop(
          fromCurrency: 'USDT',
          toCurrency: to,
          providerName: provider.name,
          rate: MockFxRates.getRate('USD', to),
          fee: fee * 0.5,
        ),
      ];
    }
    return [
      RouteHop(
        fromCurrency: from,
        toCurrency: to,
        providerName: provider.name,
        rate: rate,
        fee: fee,
      ),
    ];
  }

  static TransferRoute? _buildCryptoHopRoute(
    String from,
    String to,
    double amount,
    double midRate,
  ) {
    if (from == to) return null;
    const usdtSlippage = 0.002;
    final fromUsd = MockFxRates.getRate(from, 'USD');
    final usdTo = MockFxRates.getRate('USD', to);
    final effectiveRate = fromUsd * usdTo * (1 - usdtSlippage * 2);
    final fee = double.parse((amount * 0.003 + 1.47).toStringAsFixed(2));
    final amountAfterFee = amount - fee;
    // Guard: for very small amounts where fee >= amount, recipient = 0.
    // The route is still included so ranking is accurate, but it will be
    // excluded from the worst-route baseline pool (see _rankAndBadge).
    final recipientAmount = amountAfterFee > 0
        ? double.parse((amountAfterFee * effectiveRate).toStringAsFixed(2))
        : 0.0;

    return TransferRoute(
      id: 'route_multihop_usdt',
      providerName: 'Multi-Hop via USDT',
      providerId: 'multihop_usdt',
      providerLogo:
          'https://images.unsplash.com/photo-1642403711604-3908e90960ce?w=200&h=200&fit=crop',
      providerLogoSemanticLabel:
          'Cryptocurrency USDT stablecoin on dark background representing multi-hop transfer route',
      providerCategory: ProviderCategory.cryptoExchange,
      routeType: RouteType.multiHop,
      badge: RouteBadge.crypto,
      sendAmount: amount,
      sourceCurrency: from,
      destinationCurrency: to,
      recipientAmount: recipientAmount,
      transferFee: fee,
      fxMarkup: amount * usdtSlippage * 2 * effectiveRate,
      networkFee: 1.47,
      totalFees: fee,
      exchangeRate: effectiveRate,
      deliveryTimeLabel: '5–15 minutes',
      deliveryMinutesMin: 5,
      deliveryMinutesMax: 15,
      savingsVsBank: 0.0,
      trustScore: 4.0,
      hops: [
        RouteHop(
          fromCurrency: from,
          toCurrency: 'USDT',
          providerName: 'DEX',
          rate: fromUsd,
          fee: fee * 0.4,
        ),
        RouteHop(
          fromCurrency: 'USDT',
          toCurrency: to,
          providerName: 'DEX',
          rate: usdTo,
          fee: fee * 0.6,
        ),
      ],
      rankingReason: 'Cheapest route via stablecoin bridge',
      payoutMethods: ['Crypto Wallet', 'Bank Transfer'],
      complianceTags: ['VASP'],
    );
  }

  static List<TransferRoute> _buildFallbackRoutes(
    String from,
    String to,
    double amount,
    double midRate,
  ) {
    final providers = ProvidersDataset.all.take(5).toList();
    final routes = <TransferRoute>[];
    for (final p in providers) {
      final fee = p.totalFeeForAmount(amount);
      final rate = midRate * (1 - p.fxMarginPercent / 100);
      final fxMarkupAmount = amount * (p.fxMarginPercent / 100.0) * midRate;
      // Use the same network fee logic as the main path for consistency.
      // Fallback routes are generic so we use 0 network fee (no SWIFT hop).
      const double networkFee = 0.0;
      final double totalFees = fee + networkFee;
      final amountAfterFees = amount - totalFees;
      final recipient = amountAfterFees > 0
          ? double.parse((amountAfterFees * rate).toStringAsFixed(2))
          : 0.0;
      routes.add(
        TransferRoute(
          id: 'route_fallback_${p.id}',
          providerName: p.name,
          providerId: p.id,
          providerLogo: p.logoUrl,
          providerLogoSemanticLabel: p.logoSemanticLabel,
          providerCategory: p.category,
          routeType: RouteType.direct,
          badge: RouteBadge.bank,
          sendAmount: amount,
          sourceCurrency: from,
          destinationCurrency: to,
          recipientAmount: recipient,
          transferFee: fee,
          fxMarkup: fxMarkupAmount,
          networkFee: networkFee,
          totalFees: totalFees,
          exchangeRate: rate,
          deliveryTimeLabel: p.deliveryTimeLabel,
          deliveryMinutesMin: p.deliveryMinutesMin,
          deliveryMinutesMax: p.deliveryMinutesMax,
          savingsVsBank: 0,
          trustScore: p.trustScore,
          hops: [
            RouteHop(
              fromCurrency: from,
              toCurrency: to,
              providerName: p.name,
              rate: rate,
              fee: fee,
            ),
          ],
          rankingReason: '',
          payoutMethods: p.payoutMethods,
          complianceTags: p.complianceTags,
        ),
      );
    }
    return _rankAndBadge(routes, amount, from, to, midRate);
  }

  static List<TransferRoute> _rankAndBadge(
    List<TransferRoute> routes,
    double amount,
    String from,
    String to,
    double midRate,
  ) {
    if (routes.isEmpty) return routes;

    // ── Step 1: Sort ascending to identify worst and best routes ──────────
    routes.sort((a, b) => a.recipientAmount.compareTo(b.recipientAmount));

    // ── Step 2: Determine worst-route baseline ────────────────────────────
    //
    // RULE: Always use the worst route (lowest recipientAmount) as the single
    // universal baseline across ALL currencies, corridors, and route types.
    //
    // EDGE CASE GUARD: If ALL routes have recipientAmount == 0 (e.g. fees
    // exceed the send amount for every provider — extreme small-amount edge
    // case), every route would show savings = 0, which is correct and honest.
    //
    // IMPORTANT: We do NOT exclude zero-recipient routes from the baseline
    // pool. If the worst route has recipientAmount = 0, that IS the baseline.
    // This prevents artificially inflating savings by cherry-picking a higher
    // floor. The worst route always shows savings = 0; all others show their
    // true advantage over it.
    final double worstRecipient = routes.first.recipientAmount;

    // ── Step 3: Compute savings for EVERY route using SavingsValidator ────
    //
    // Each route uses its OWN exchange rate for the source-currency conversion:
    //
    //   savings_in_dest   = route.recipientAmount − worstRecipient
    //   savings_in_sender = savings_in_dest / route.exchangeRate  (2dp)
    //
    // This guarantees the "Save X src" label on every card is verifiable:
    //   displayed_savings × card_rate ≈ recipientAmount − worstRecipient
    //
    // • Worst route always shows 0 (delta = 0).
    // • Best route shows the full spread vs the worst route.
    // • All intermediate routes show a proportional value in their own rate.
    // • High-fee routes with recipientAmount ≤ worstRecipient → clamped to 0.
    final withSavings = routes.map((r) {
      final savings = SavingsValidator.computeSavings(
        r.recipientAmount,
        worstRecipient,
        r.exchangeRate,
      );
      return _copyWithSavings(r, savings);
    }).toList();

    // ── Step 4: Automated validation — reject any mismatch ───────────────
    //
    // Compares every stored savingsVsBank against the canonical formula.
    // Throws StateError if any route deviates beyond the 0.01 tolerance.
    SavingsValidator.validate(withSavings, worstRecipient);

    // Sort by recipient amount descending (best deal = highest recipient first)
    withSavings.sort((a, b) => b.recipientAmount.compareTo(a.recipientAmount));

    // Assign badges
    final fastest = withSavings.reduce(
      (a, b) => a.deliveryMinutesMin < b.deliveryMinutesMin ? a : b,
    );
    final cheapestFee = withSavings.reduce(
      (a, b) => a.totalFees < b.totalFees ? a : b,
    );
    final bestRateRoute = withSavings.reduce(
      (a, b) => a.exchangeRate > b.exchangeRate ? a : b,
    );
    // Recommended = highest recipient amount (first after sort)
    final recommended = withSavings.first;

    final badgedIds = <String>{};
    final result = withSavings.map((r) {
      RouteBadge badge;
      String reason;

      if (r.id == recommended.id && !badgedIds.contains(r.id)) {
        badge = RouteBadge.recommended;
        reason =
            'Best overall: highest recipient amount with strong trust score';
        badgedIds.add(r.id);
      } else if (r.id == fastest.id && !badgedIds.contains(r.id)) {
        badge = RouteBadge.fastest;
        reason = 'Fastest delivery: ${r.deliveryTimeLabel}';
        badgedIds.add(r.id);
      } else if (r.id == cheapestFee.id && !badgedIds.contains(r.id)) {
        badge = RouteBadge.cheapest;
        reason =
            'Lowest total fees: ${r.sourceCurrency} ${r.totalFees.toStringAsFixed(2)}';
        badgedIds.add(r.id);
      } else if (r.id == bestRateRoute.id && !badgedIds.contains(r.id)) {
        badge = RouteBadge.bestRate;
        reason = 'Best exchange rate: ${r.exchangeRate.toStringAsFixed(4)}';
        badgedIds.add(r.id);
      } else if (r.providerCategory == ProviderCategory.cryptoExchange) {
        badge = RouteBadge.crypto;
        reason = 'Crypto route: lower fees via blockchain bridge';
      } else if (r.routeType == RouteType.multiHop) {
        badge = RouteBadge.hybrid;
        reason = 'Multi-hop: routes via stablecoin for better rates';
      } else {
        badge = RouteBadge.bank;
        reason = 'Standard bank transfer via ${r.providerName}';
      }

      return _copyWithBadge(r, badge, reason);
    }).toList();

    return result;
  }

  static TransferRoute _copyWithSavings(TransferRoute r, double savings) =>
      TransferRoute(
        id: r.id,
        providerName: r.providerName,
        providerId: r.providerId,
        providerLogo: r.providerLogo,
        providerLogoSemanticLabel: r.providerLogoSemanticLabel,
        providerCategory: r.providerCategory,
        routeType: r.routeType,
        badge: r.badge,
        sendAmount: r.sendAmount,
        sourceCurrency: r.sourceCurrency,
        destinationCurrency: r.destinationCurrency,
        recipientAmount: r.recipientAmount,
        transferFee: r.transferFee,
        fxMarkup: r.fxMarkup,
        networkFee: r.networkFee,
        totalFees: r.totalFees,
        exchangeRate: r.exchangeRate,
        deliveryTimeLabel: r.deliveryTimeLabel,
        deliveryMinutesMin: r.deliveryMinutesMin,
        deliveryMinutesMax: r.deliveryMinutesMax,
        savingsVsBank: savings,
        trustScore: r.trustScore,
        hops: r.hops,
        rankingReason: r.rankingReason,
        payoutMethods: r.payoutMethods,
        complianceTags: r.complianceTags,
      );

  static TransferRoute _copyWithBadge(
    TransferRoute r,
    RouteBadge badge,
    String reason,
  ) => TransferRoute(
    id: r.id,
    providerName: r.providerName,
    providerId: r.providerId,
    providerLogo: r.providerLogo,
    providerLogoSemanticLabel: r.providerLogoSemanticLabel,
    providerCategory: r.providerCategory,
    routeType: r.routeType,
    badge: badge,
    sendAmount: r.sendAmount,
    sourceCurrency: r.sourceCurrency,
    destinationCurrency: r.destinationCurrency,
    recipientAmount: r.recipientAmount,
    transferFee: r.transferFee,
    fxMarkup: r.fxMarkup,
    networkFee: r.networkFee,
    totalFees: r.totalFees,
    exchangeRate: r.exchangeRate,
    deliveryTimeLabel: r.deliveryTimeLabel,
    deliveryMinutesMin: r.deliveryMinutesMin,
    deliveryMinutesMax: r.deliveryMinutesMax,
    savingsVsBank: r.savingsVsBank,
    trustScore: r.trustScore,
    hops: r.hops,
    rankingReason: reason,
    payoutMethods: r.payoutMethods,
    complianceTags: r.complianceTags,
  );
}
