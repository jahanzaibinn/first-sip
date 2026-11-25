import 'package:url_launcher/url_launcher.dart';

import '../models/coffee_shop_model.dart';

/// Builds Google Maps links and hands them to the phone's Maps app.
///
/// Directions use the documented `maps/dir` universal link, so no API key is
/// required: Google Maps opens with the user's current position as the origin
/// and the shop as the destination.
class MapsService {
  MapsService({Future<bool> Function(Uri uri)? launch})
      : _launch = launch ?? _launchExternally;

  /// Shared instance for screens that do not manage their own wiring.
  static final MapsService instance = MapsService();

  final Future<bool> Function(Uri uri) _launch;

  static Future<bool> _launchExternally(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);

  /// Turn-by-turn directions to the shop, falling back to its address when the
  /// payload has no coordinates.
  Uri directionsUri(CoffeeShopModel shop) {
    final destination =
        shop.hasCoordinates ? '${shop.latitude},${shop.longitude}' : _query(shop);
    return Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=$destination&travelmode=driving',
    );
  }

  /// Drops a pin on the shop (or searches for it by name and address).
  Uri searchUri(CoffeeShopModel shop) {
    final target = shop.hasCoordinates ? '${shop.latitude},${shop.longitude}' : _query(shop);
    return Uri.parse('https://www.google.com/maps/search/?api=1&query=$target');
  }

  Future<bool> openDirections(CoffeeShopModel shop) =>
      _launch(directionsUri(shop));

  Future<bool> openMap(CoffeeShopModel shop) => _launch(searchUri(shop));

  String _query(CoffeeShopModel shop) => Uri.encodeComponent(shop.mapsQuery);
}
