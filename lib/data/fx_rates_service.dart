import 'package:dio/dio.dart';

/// GlobalX – FX Rates Service
///
/// Fetches mid-market exchange rates from Open Exchange Rates API.
/// Falls back to built-in mock rates when:
///   - [useMockRates] is true (default when no API key configured), OR
///   - The API key is missing/placeholder, OR
///   - The network request fails.
///
/// To activate live rates:
///   1. Get a free App ID at https://openexchangerates.org/signup/free
///   2. Set OPEN_EXCHANGE_RATES_API_KEY in your env.json / build config.
///   3. The service will automatically switch to live mode.
class FxRatesService {
  static const String _appId = String.fromEnvironment(
    'OPEN_EXCHANGE_RATES_API_KEY',
    defaultValue: '',
  );

  static const String _baseUrl = 'https://openexchangerates.org/api';

  /// Set to true to force mock rates regardless of API key.
  /// Automatically true when no valid API key is configured.
  static bool get useMockRates =>
      _appId.isEmpty || _appId == 'your-open-exchange-rates-app-id-here';

  // Cached rates: base currency → {target: rate}
  static Map<String, double>? _cachedRates;
  static DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(minutes: 30);

  /// Returns the mid-market rate from [from] to [to].
  /// Uses live API when configured, otherwise falls back to mock rates.
  static Future<double> getRate(String from, String to) async {
    if (from == to) return 1.0;

    if (useMockRates) {
      return MockFxRates.getRate(from, to);
    }

    try {
      final rates = await _fetchRates();
      return _crossRate(rates, from, to);
    } catch (_) {
      // Graceful fallback to mock on any network/parse error
      return MockFxRates.getRate(from, to);
    }
  }

  /// Fetches all rates from Open Exchange Rates (base: USD).
  /// Caches results for [_cacheDuration] to avoid excessive API calls.
  static Future<Map<String, double>> _fetchRates() async {
    final now = DateTime.now();
    if (_cachedRates != null &&
        _cacheTime != null &&
        now.difference(_cacheTime!) < _cacheDuration) {
      return _cachedRates!;
    }

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );

    final response = await dio.get(
      '$_baseUrl/latest.json',
      queryParameters: {'app_id': _appId},
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final rawRates = data['rates'] as Map<String, dynamic>;
      _cachedRates = rawRates.map((k, v) => MapEntry(k, (v as num).toDouble()));
      _cacheTime = now;
      return _cachedRates!;
    }

    throw Exception('Open Exchange Rates API error: ${response.statusCode}');
  }

  /// Cross-rate calculation: all OXR rates are USD-based.
  /// rate(from→to) = rate(USD→to) / rate(USD→from)
  static double _crossRate(
    Map<String, double> usdRates,
    String from,
    String to,
  ) {
    if (from == 'USD') {
      return usdRates[to] ?? MockFxRates.getRate(from, to);
    }
    if (to == 'USD') {
      final fromRate = usdRates[from];
      if (fromRate == null || fromRate == 0) {
        return MockFxRates.getRate(from, to);
      }
      return 1.0 / fromRate;
    }
    final fromRate = usdRates[from];
    final toRate = usdRates[to];
    if (fromRate == null || toRate == null || fromRate == 0) {
      return MockFxRates.getRate(from, to);
    }
    return toRate / fromRate;
  }

  /// Clears the cached rates (useful for forced refresh).
  static void clearCache() {
    _cachedRates = null;
    _cacheTime = null;
  }
}

/// Built-in mock FX rates (mid-market approximations).
/// Used when no API key is configured or as a fallback on network failure.
class MockFxRates {
  static const Map<String, Map<String, double>> _rates = {
    'USD': {
      'EUR': 0.9210,
      'GBP': 0.7890,
      'CHF': 0.8980,
      'JPY': 149.80,
      'AUD': 1.5420,
      'CAD': 1.3650,
      'SGD': 1.3420,
      'HKD': 7.8210,
      'INR': 83.45,
      'PHP': 57.42,
      'THB': 35.80,
      'MXN': 17.25,
      'BRL': 4.98,
      'NGN': 1580.0,
      'KES': 129.50,
      'ZAR': 18.65,
      'AED': 3.6730,
      'SAR': 3.7500,
      'KRW': 1325.0,
      'CNY': 7.2450,
      'IDR': 15750.0,
      'MYR': 4.7200,
      'VND': 24850.0,
      'GHS': 15.20,
      'EGP': 48.50,
      'MAD': 10.05,
      'TZS': 2580.0,
      'UGX': 3750.0,
      'PKR': 278.0,
      'BDT': 110.0,
      'LKR': 305.0,
      'NZD': 1.6350,
      'SEK': 10.45,
      'NOK': 10.62,
      'DKK': 6.88,
      'PLN': 4.02,
      'CZK': 22.85,
      'HUF': 358.0,
      'RON': 4.58,
      'TRY': 32.50,
      'ILS': 3.72,
      'QAR': 3.6400,
      'KWD': 0.3080,
      'BHD': 0.3770,
      'OMR': 0.3850,
      'JOD': 0.7090,
      'COP': 3950.0,
      'PEN': 3.72,
      'CLP': 920.0,
      'ARS': 870.0,
      'UAH': 39.50,
      'RUB': 90.0,
      'GEL': 2.68,
      'AMD': 388.0,
      'AZN': 1.70,
      'KZT': 450.0,
    },
    'EUR': {
      'USD': 1.0860,
      'GBP': 0.8570,
      'CHF': 0.9750,
      'JPY': 162.50,
      'AUD': 1.6750,
      'CAD': 1.4820,
      'SGD': 1.4580,
      'HKD': 8.4920,
      'INR': 90.60,
      'PHP': 62.35,
      'THB': 38.90,
      'MXN': 18.72,
      'BRL': 5.41,
      'NGN': 1715.0,
      'KES': 140.60,
      'ZAR': 20.25,
      'AED': 3.9880,
      'SAR': 4.0720,
      'KRW': 1438.0,
      'CNY': 7.8650,
      'PLN': 4.37,
      'CZK': 24.82,
      'HUF': 388.0,
      'RON': 4.97,
      'SEK': 11.35,
      'NOK': 11.53,
      'DKK': 7.47,
    },
    'GBP': {
      'USD': 1.2680,
      'EUR': 1.1670,
      'CHF': 1.1380,
      'JPY': 189.70,
      'AUD': 1.9550,
      'CAD': 1.7290,
      'SGD': 1.7020,
      'HKD': 9.9120,
      'INR': 105.70,
      'PHP': 72.75,
      'THB': 45.40,
      'MXN': 21.85,
      'BRL': 6.31,
      'NGN': 2000.0,
      'KES': 164.0,
      'ZAR': 23.62,
      'AED': 4.6530,
      'SAR': 4.7520,
      'KRW': 1678.0,
      'CNY': 9.1750,
      'PLN': 5.10,
      'CZK': 28.95,
      'HUF': 453.0,
      'RON': 5.80,
    },
    'CHF': {
      'USD': 1.1140,
      'EUR': 1.0260,
      'GBP': 0.8790,
      'JPY': 166.80,
      'THB': 39.90,
      'PHP': 63.95,
      'AUD': 1.7180,
      'CAD': 1.5210,
      'SGD': 1.4960,
      'HKD': 8.7180,
      'INR': 92.95,
      'BRL': 5.55,
      'AED': 4.0920,
      'SAR': 4.1790,
      'KRW': 1476.0,
      'CNY': 8.0720,
    },
    'AUD': {
      'USD': 0.6490,
      'EUR': 0.5970,
      'GBP': 0.5120,
      'JPY': 97.20,
      'PHP': 37.25,
      'INR': 54.15,
      'SGD': 0.8710,
      'HKD': 5.0760,
      'NZD': 1.0610,
      'CAD': 0.8860,
      'CHF': 0.5820,
      'CNY': 4.7020,
    },
    'CAD': {
      'USD': 0.7330,
      'EUR': 0.6750,
      'GBP': 0.5790,
      'JPY': 109.80,
      'PHP': 42.10,
      'INR': 61.15,
      'AUD': 1.1290,
      'SGD': 0.9840,
      'HKD': 5.7320,
      'CHF': 0.6580,
      'CNY': 5.3120,
    },
    'SGD': {
      'USD': 0.7450,
      'EUR': 0.6860,
      'GBP': 0.5880,
      'JPY': 111.60,
      'PHP': 42.80,
      'INR': 62.15,
      'AUD': 1.1480,
      'CAD': 1.0160,
      'HKD': 5.8290,
      'CHF': 0.6690,
      'CNY': 5.3980,
      'MYR': 3.5180,
      'THB': 26.68,
      'IDR': 11740.0,
    },
    'AED': {
      'USD': 0.2723,
      'EUR': 0.2508,
      'GBP': 0.2149,
      'INR': 22.72,
      'PHP': 15.63,
      'PKR': 75.72,
      'BDT': 29.96,
      'LKR': 83.05,
      'EGP': 13.21,
      'NGN': 430.0,
      'KES': 35.26,
    },
    'JPY': {
      'USD': 0.006676,
      'EUR': 0.006154,
      'GBP': 0.005271,
      'CHF': 0.005994,
      'AUD': 0.01029,
      'CAD': 0.009107,
      'SGD': 0.008961,
      'HKD': 0.05221,
      'CNY': 0.04834,
      'KRW': 8.847,
    },
    'INR': {
      'USD': 0.01198,
      'EUR': 0.01104,
      'GBP': 0.009461,
      'AED': 0.04400,
      'SGD': 0.01609,
      'AUD': 0.01847,
      'CAD': 0.01635,
      'JPY': 1.7950,
      'PHP': 0.6882,
      'BDT': 1.3190,
      'LKR': 3.6570,
      'NPR': 1.6020,
    },
  };

  /// Returns a mock mid-market rate for [from] → [to].
  /// Triangulates via USD when a direct pair is not available.
  static double getRate(String from, String to) {
    if (from == to) return 1.0;
    final direct = _rates[from]?[to];
    if (direct != null) return direct;
    // Triangulate via USD
    final fromUsd =
        _rates[from]?['USD'] ?? (1.0 / (_rates['USD']?[from] ?? 1.0));
    final usdTo = _rates['USD']?[to] ?? (1.0 / (_rates[to]?['USD'] ?? 1.0));
    return fromUsd * usdTo;
  }
}
