import 'package:flutter_test/flutter_test.dart';
import 'package:karachi_coffee_compass/controllers/shop_directory_controller.dart';
import 'package:karachi_coffee_compass/models/coffee_shop_model.dart';
import 'package:karachi_coffee_compass/services/coffee_api_service.dart';
import 'package:karachi_coffee_compass/services/location_service.dart';
import 'package:karachi_coffee_compass/services/maps_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

CoffeeShopModel _mazi() => CoffeeShopModel.fromJson(const {
      'id': 'mazi',
      'name': 'Mazi Specialty Coffee',
      'area': 'North Nazimabad',
      'lat': 24.94201,
      'lng': 67.03257,
    });

CoffeeShopModel _drop() => CoffeeShopModel.fromJson(const {
      'id': 'drop',
      'name': 'Drop Coffee',
      'area': 'Clifton',
      'lat': 24.81345,
      'lng': 67.02986,
    });

class _FakeLocationService extends LocationService {
  const _FakeLocationService(this.result);

  final LocationResult result;

  @override
  Future<LocationResult> currentLocation() async => result;
}

ShopDirectoryController _controller() => ShopDirectoryController(
      service: CoffeeApiService(
        client: MockClient((_) async => http.Response('{}', 200)),
        endpoint: 'https://example.test/spots.json',
      ),
      locationService: const _FakeLocationService(
        LocationResult.success(GeoPoint(24.8130, 67.0300)),
      ),
      mapsService: MapsService(launch: (_) async => true),
      notify: (_, __) {},
    );

void main() {
  group('CoffeeShopModel coordinates', () {
    test('parses lat/lng and exposes a maps query', () {
      final shop = CoffeeShopModel.fromJson(const {
        'name': 'Drop Coffee',
        'area': 'Clifton',
        'addressHint': 'Clifton Block 4',
        'lat': 24.81345,
        'lng': '67.02986',
      });

      expect(shop.hasCoordinates, isTrue);
      expect(shop.latitude, closeTo(24.81345, 1e-6));
      expect(shop.longitude, closeTo(67.02986, 1e-6));
      expect(shop.mapsQuery, contains('Karachi'));
    });

    test('reports missing coordinates for older payloads', () {
      final shop = CoffeeShopModel.fromJson(const {'name': 'Old Spot'});
      expect(shop.hasCoordinates, isFalse);
    });
  });

  group('LocationService.distanceKm', () {
    test('is zero for the same point', () {
      const point = GeoPoint(24.8130, 67.0300);
      expect(LocationService.distanceKm(point, point), closeTo(0, 1e-9));
    });

    test('measures Clifton to North Nazimabad as roughly 14 km', () {
      const clifton = GeoPoint(24.8130, 67.0300);
      const northNazimabad = GeoPoint(24.94201, 67.03257);

      final km = LocationService.distanceKm(clifton, northNazimabad);
      expect(km, greaterThan(13));
      expect(km, lessThan(16));
    });

    test('formats metres and kilometres for the UI', () {
      expect(LocationService.formatDistance(0.85), '850 m');
      expect(LocationService.formatDistance(4.24), '4.2 km');
      expect(LocationService.formatDistance(23.6), '24 km');
    });
  });

  group('ShopDirectoryController near me', () {
    test('sorts the closest shop first once a GPS fix lands', () async {
      final controller = _controller();
      controller.shops.assignAll([_mazi(), _drop()]);

      expect(controller.visibleShops.first.name, 'Mazi Specialty Coffee');
      expect(controller.nearMeActive, isFalse);

      await controller.toggleNearMe();

      expect(controller.userLocation.value, isNotNull);
      expect(controller.nearMeActive, isTrue);
      expect(controller.visibleShops.first.name, 'Drop Coffee');
      expect(controller.distanceLabelFor(controller.visibleShops.first),
          endsWith('m'));

      // A second tap flips back to the directory's natural order.
      await controller.toggleNearMe();
      expect(controller.nearMeActive, isFalse);
      expect(controller.visibleShops.first.name, 'Mazi Specialty Coffee');
    });

    test('surfaces a readable message when location is refused', () async {
      final messages = <String>[];
      final controller = ShopDirectoryController(
        service: CoffeeApiService(
          client: MockClient((_) async => http.Response('{}', 200)),
          endpoint: 'https://example.test/spots.json',
        ),
        locationService: const _FakeLocationService(
          LocationResult.failure(LocationFailure.permissionDenied),
        ),
        notify: (title, message) => messages.add('$title: $message'),
      );

      await controller.toggleNearMe();

      expect(controller.userLocation.value, isNull);
      expect(controller.nearMeActive, isFalse);
      expect(messages.single, contains('Location permission'));
    });
  });

  group('MapsService', () {
    test('builds a driving-directions link with coordinates', () {
      final shop = CoffeeShopModel.fromJson(const {
        'name': 'FLOC',
        'lat': 24.80242,
        'lng': 67.06351,
      });

      final uri = MapsService().directionsUri(shop);
      expect(uri.host, 'www.google.com');
      expect(uri.path, '/maps/dir/');
      expect(uri.queryParameters['destination'], '24.80242,67.06351');
      expect(uri.queryParameters['travelmode'], 'driving');
    });

    test('falls back to a name and address search without coordinates', () {
      final shop = CoffeeShopModel.fromJson(const {
        'name': 'Coffee Wagera',
        'area': 'Gulshan',
        'addressHint': 'Bahadurabad',
      });

      final uri = MapsService().directionsUri(shop);
      expect(
        Uri.decodeQueryComponent(uri.queryParameters['destination']!),
        contains('Coffee Wagera'),
      );
    });
  });
}
