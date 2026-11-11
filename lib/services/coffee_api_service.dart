import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/coffee_shop_model.dart';

/// A user-safe failure while talking to the coffee directory.
class CoffeeApiException implements Exception {
  const CoffeeApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'CoffeeApiException($statusCode): $message';
}

/// The parsed directory payload plus the moment the bar last updated prices.
class CoffeeMenuSnapshot {
  const CoffeeMenuSnapshot({required this.shops, this.updatedAt});

  final List<CoffeeShopModel> shops;
  final DateTime? updatedAt;
}

/// Fetches live outlets, menus and PKR prices for the Karachi directory.
///
/// The endpoint is compiled in but can be pointed anywhere with
/// `--dart-define=COFFEE_MENU_URL=https://your.api/spots.json`.
class CoffeeApiService {
  CoffeeApiService({
    http.Client? client,
    String endpoint = defaultEndpoint,
    Duration timeout = const Duration(seconds: 12),
  })  : _client = client ?? http.Client(),
        _endpoint = endpoint,
        _timeout = timeout;

  static const String defaultEndpoint = String.fromEnvironment(
    'COFFEE_MENU_URL',
    defaultValue:
        'https://raw.githubusercontent.com/jahanzaibinn/first-sip/main/data/coffee_spots.json',
  );

  final http.Client _client;
  final String _endpoint;
  final Duration _timeout;

  String get endpoint => _endpoint;

  Future<CoffeeMenuSnapshot> fetchShops() async {
    final uri = Uri.parse(_endpoint);

    try {
      final response = await _client.get(uri,
          headers: const {'Accept': 'application/json'}).timeout(_timeout);

      if (response.statusCode != 200) {
        throw CoffeeApiException(
          'The coffee directory is unavailable right now '
          '(HTTP ${response.statusCode}).',
          statusCode: response.statusCode,
        );
      }

      return _parse(response.body);
    } on CoffeeApiException {
      rethrow;
    } on TimeoutException {
      throw const CoffeeApiException(
        'The request timed out. Check your connection and try again.',
      );
    } on FormatException {
      throw const CoffeeApiException(
        'The coffee directory sent data we could not read.',
      );
    } catch (_) {
      throw const CoffeeApiException(
        'Could not reach the coffee directory. Check your connection.',
      );
    }
  }

  CoffeeMenuSnapshot _parse(String body) {
    final dynamic decoded = jsonDecode(body);

    final List<dynamic> rawShops;
    DateTime? updatedAt;

    if (decoded is List) {
      rawShops = decoded;
    } else if (decoded is Map && decoded['shops'] is List) {
      rawShops = decoded['shops'] as List;
      final rawUpdatedAt = decoded['updatedAt']?.toString();
      if (rawUpdatedAt != null) updatedAt = DateTime.tryParse(rawUpdatedAt);
    } else {
      throw const CoffeeApiException(
        'The coffee directory format was not recognised.',
      );
    }

    final shops = <CoffeeShopModel>[];
    for (final entry in rawShops) {
      if (entry is! Map) continue;
      final shop = CoffeeShopModel.fromJson(Map<String, dynamic>.from(entry));
      if (shop.name.isNotEmpty) shops.add(shop);
    }

    if (shops.isEmpty) {
      throw const CoffeeApiException('The coffee directory came back empty.');
    }

    return CoffeeMenuSnapshot(shops: shops, updatedAt: updatedAt);
  }

  void dispose() => _client.close();
}
