import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Affiliate link configuration per provider
class AffiliateProvider {
  final String providerId;
  final String providerName;
  final String affiliateUrl;
  final String fallbackUrl;

  const AffiliateProvider({
    required this.providerId,
    required this.providerName,
    required this.affiliateUrl,
    required this.fallbackUrl,
  });
}

/// Click event logged locally and ready for backend submission
class ClickEvent {
  final String id;
  final DateTime timestamp;
  final String provider;
  final String routeType; // bank / crypto / multi-hop
  final double amount;
  final String sourceCurrency;
  final String destinationCurrency;
  final String affiliateUrl;

  ClickEvent({
    required this.id,
    required this.timestamp,
    required this.provider,
    required this.routeType,
    required this.amount,
    required this.sourceCurrency,
    required this.destinationCurrency,
    required this.affiliateUrl,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'provider': provider,
    'routeType': routeType,
    'amount': amount,
    'sourceCurrency': sourceCurrency,
    'destinationCurrency': destinationCurrency,
    'affiliateUrl': affiliateUrl,
  };

  factory ClickEvent.fromMap(Map<String, dynamic> m) => ClickEvent(
    id: m['id'] as String,
    timestamp: DateTime.parse(m['timestamp'] as String),
    provider: m['provider'] as String,
    routeType: m['routeType'] as String,
    amount: (m['amount'] as num).toDouble(),
    sourceCurrency: m['sourceCurrency'] as String,
    destinationCurrency: m['destinationCurrency'] as String,
    affiliateUrl: m['affiliateUrl'] as String,
  );
}

class AffiliateService {
  static const String _clickLogKey = 'globalx_click_log';

  /// Provider affiliate link registry.
  /// Replace affiliateUrl values with real affiliate/tracking URLs.
  static const Map<String, AffiliateProvider> _providers = {
    'wise': AffiliateProvider(
      providerId: 'wise',
      providerName: 'Wise',
      affiliateUrl: 'https://wise.com/invite/globalx',
      fallbackUrl: 'https://wise.com',
    ),
    'remitly': AffiliateProvider(
      providerId: 'remitly',
      providerName: 'Remitly',
      affiliateUrl: 'https://www.remitly.com/?utm_source=globalx',
      fallbackUrl: 'https://www.remitly.com',
    ),
    'worldremit': AffiliateProvider(
      providerId: 'worldremit',
      providerName: 'WorldRemit',
      affiliateUrl: 'https://www.worldremit.com/?utm_source=globalx',
      fallbackUrl: 'https://www.worldremit.com',
    ),
    'revolut': AffiliateProvider(
      providerId: 'revolut',
      providerName: 'Revolut',
      affiliateUrl: 'https://revolut.com/referral/globalx',
      fallbackUrl: 'https://www.revolut.com',
    ),
    'xe': AffiliateProvider(
      providerId: 'xe',
      providerName: 'XE',
      affiliateUrl: 'https://www.xe.com/?utm_source=globalx',
      fallbackUrl: 'https://www.xe.com',
    ),
    'transferwise': AffiliateProvider(
      providerId: 'transferwise',
      providerName: 'TransferWise',
      affiliateUrl: 'https://wise.com/invite/globalx',
      fallbackUrl: 'https://wise.com',
    ),
    'moneygram': AffiliateProvider(
      providerId: 'moneygram',
      providerName: 'MoneyGram',
      affiliateUrl: 'https://www.moneygram.com/?utm_source=globalx',
      fallbackUrl: 'https://www.moneygram.com',
    ),
    'westernunion': AffiliateProvider(
      providerId: 'westernunion',
      providerName: 'Western Union',
      affiliateUrl: 'https://www.westernunion.com/?utm_source=globalx',
      fallbackUrl: 'https://www.westernunion.com',
    ),
    'paypal': AffiliateProvider(
      providerId: 'paypal',
      providerName: 'PayPal',
      affiliateUrl: 'https://www.paypal.com/?utm_source=globalx',
      fallbackUrl: 'https://www.paypal.com',
    ),
    'skrill': AffiliateProvider(
      providerId: 'skrill',
      providerName: 'Skrill',
      affiliateUrl: 'https://www.skrill.com/?utm_source=globalx',
      fallbackUrl: 'https://www.skrill.com',
    ),
    'coinbase': AffiliateProvider(
      providerId: 'coinbase',
      providerName: 'Coinbase',
      affiliateUrl: 'https://www.coinbase.com/join/globalx',
      fallbackUrl: 'https://www.coinbase.com',
    ),
    'binance': AffiliateProvider(
      providerId: 'binance',
      providerName: 'Binance',
      affiliateUrl: 'https://www.binance.com/en/register?ref=globalx',
      fallbackUrl: 'https://www.binance.com',
    ),
  };

  /// Get affiliate config for a provider (by id or name match)
  static AffiliateProvider? getProvider(String providerIdOrName) {
    final key = providerIdOrName.toLowerCase().replaceAll(' ', '');
    if (_providers.containsKey(key)) return _providers[key];
    // Fuzzy match by name
    for (final entry in _providers.entries) {
      if (entry.value.providerName.toLowerCase() ==
          providerIdOrName.toLowerCase()) {
        return entry.value;
      }
    }
    return null;
  }

  /// Track click and launch affiliate URL
  static Future<void> trackAndRedirect({
    required String providerId,
    required String providerName,
    required String routeType,
    required double amount,
    required String sourceCurrency,
    required String destinationCurrency,
  }) async {
    final affiliate = getProvider(providerId) ?? getProvider(providerName);
    final targetUrl = affiliate?.affiliateUrl ?? affiliate?.fallbackUrl ?? '';

    // Log click event
    await _logClick(
      ClickEvent(
        id: '${DateTime.now().millisecondsSinceEpoch}_$providerId',
        timestamp: DateTime.now(),
        provider: providerName,
        routeType: routeType,
        amount: amount,
        sourceCurrency: sourceCurrency,
        destinationCurrency: destinationCurrency,
        affiliateUrl: targetUrl,
      ),
    );

    if (kDebugMode) {
      debugPrint(
        '[AffiliateService] Click: $providerName | $routeType | $amount $sourceCurrency→$destinationCurrency | $targetUrl',
      );
    }

    if (targetUrl.isEmpty) return;

    final uri = Uri.parse(targetUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback
        final fallback = affiliate?.fallbackUrl ?? '';
        if (fallback.isNotEmpty) {
          await launchUrl(
            Uri.parse(fallback),
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[AffiliateService] Launch error: $e');
    }
  }

  /// Persist click event to local storage
  static Future<void> _logClick(ClickEvent event) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_clickLogKey) ?? '[]';
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      list.add(event.toMap());
      // Keep last 500 events
      final trimmed = list.length > 500
          ? list.sublist(list.length - 500)
          : list;
      await prefs.setString(_clickLogKey, jsonEncode(trimmed));
    } catch (e) {
      if (kDebugMode) debugPrint('[AffiliateService] Log error: $e');
    }
  }

  /// Retrieve all logged click events (for analytics / backend sync)
  static Future<List<ClickEvent>> getClickLog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_clickLogKey) ?? '[]';
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ClickEvent.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Clear click log
  static Future<void> clearClickLog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_clickLogKey);
  }
}
