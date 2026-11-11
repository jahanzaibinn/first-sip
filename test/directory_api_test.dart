import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:karachi_coffee_compass/controllers/shop_directory_controller.dart';
import 'package:karachi_coffee_compass/models/coffee_shop_model.dart';
import 'package:karachi_coffee_compass/services/coffee_api_service.dart';

const Map<String, dynamic> _payload = {
  'updatedAt': '2026-11-11T08:30:00Z',
  'currency': 'PKR',
  'shops': [
    {
      'id': 'floc',
      'name': 'FLOC',
      'area': 'DHA Phase 5',
      'tagline': 'For the Love of Coffee',
      'description': 'Single-origin bar.',
      'vibe': 'Quiet',
      'hours': '8:00 AM – 12:00 AM',
      'rating': 4.7,
      'categories': ['specialty', 'workspace'],
      'signatureDrinks': ['V60 Pour Over'],
      'mustTry': ['Ethiopian V60'],
      'address': 'Khayaban-e-Ittehad',
      'badges': ['Single Origin'],
      'menu': [
        {'name': 'Flat White', 'price': 750},
        {'name': 'V60 Pour Over', 'price': 1200, 'note': 'Single origin'},
      ],
    },
  ],
};

http.Client _clientFor(Object body, {int status = 200}) => MockClient(
      (_) async => http.Response(
        body is String ? body : jsonEncode(body),
        status,
        headers: const {'content-type': 'application/json'},
      ),
    );

void main() {
  group('CoffeeApiService', () {
    test('parses shops, menus and the update timestamp', () async {
      final service = CoffeeApiService(
        client: _clientFor(_payload),
        endpoint: 'https://example.test/spots.json',
      );

      final snapshot = await service.fetchShops();
      final shop = snapshot.shops.single;

      expect(shop.name, 'FLOC');
      expect(shop.area, 'DHA Phase 5');
      expect(shop.vibeTag, 'Quiet');
      expect(shop.openingHours, '8:00 AM – 12:00 AM');
      expect(shop.categories, hasLength(2));
      expect(shop.menu, hasLength(2));
      expect(shop.menu.last.note, 'Single origin');
      expect(snapshot.updatedAt, DateTime.utc(2026, 11, 11, 8, 30));
    });

    test('derives the PKR band from the live menu', () async {
      final service = CoffeeApiService(
        client: _clientFor(_payload),
        endpoint: 'https://example.test/spots.json',
      );

      final shop = (await service.fetchShops()).shops.single;

      expect(shop.startingPrice, 750);
      expect(shop.topPrice, 1200);
      expect(shop.priceRange, 'PKR 750 – 1,200');
    });

    test('accepts a bare list payload without a timestamp', () async {
      final service = CoffeeApiService(
        client: _clientFor(_payload['shops']),
        endpoint: 'https://example.test/spots.json',
      );

      final snapshot = await service.fetchShops();

      expect(snapshot.shops.single.name, 'FLOC');
      expect(snapshot.updatedAt, isNull);
    });

    test('throws a readable error for a non-200 response', () async {
      final service = CoffeeApiService(
        client: _clientFor({'error': 'down'}, status: 503),
        endpoint: 'https://example.test/spots.json',
      );

      await expectLater(
        service.fetchShops(),
        throwsA(
          isA<CoffeeApiException>()
              .having((e) => e.statusCode, 'statusCode', 503)
              .having((e) => e.message, 'message', contains('unavailable')),
        ),
      );
    });

    test('throws for an unrecognised payload shape', () async {
      final service = CoffeeApiService(
        client: _clientFor({'unexpected': true}),
        endpoint: 'https://example.test/spots.json',
      );

      expect(service.fetchShops(), throwsA(isA<CoffeeApiException>()));
    });

    test('reports an empty directory instead of a blank list', () async {
      final service = CoffeeApiService(
        client: _clientFor({'shops': []}),
        endpoint: 'https://example.test/spots.json',
      );

      await expectLater(
        service.fetchShops(),
        throwsA(
          isA<CoffeeApiException>()
              .having((e) => e.message, 'message', contains('empty')),
        ),
      );
    });
  });

  group('ShopDirectoryController', () {
    test('loads shops into the reactive list and clears loading', () async {
      final controller = ShopDirectoryController(
        service: CoffeeApiService(
          client: _clientFor(_payload),
          endpoint: 'https://example.test/spots.json',
        ),
      );

      expect(controller.shops, isEmpty);
      await controller.fetchDynamicShops();

      expect(controller.isLoading.value, isFalse);
      expect(controller.hasError, isFalse);
      expect(controller.shops, hasLength(1));
      expect(controller.lastSyncedAt.value, isNotNull);
      expect(controller.visibleShops, hasLength(1));
      expect(controller.lastSyncLabel, contains('Live prices'));

      controller.selectFilter('budget');
      expect(controller.visibleShops, isEmpty);

      controller.selectFilter('all');
      controller.setQuery('clifton');
      expect(controller.visibleShops, isEmpty);

      controller.setQuery('floc');
      expect(controller.visibleShops, hasLength(1));
    });

    test('surfaces the error message when the fetch fails', () async {
      final controller = ShopDirectoryController(
        service: CoffeeApiService(
          client: _clientFor({'error': 'down'}, status: 500),
          endpoint: 'https://example.test/spots.json',
        ),
      );

      await controller.fetchDynamicShops();

      expect(controller.isLoading.value, isFalse);
      expect(controller.hasError, isTrue);
      expect(controller.shops, isEmpty);
      expect(controller.errorMessage.value, contains('unavailable'));
    });
  });

  group('CoffeeShopModel.fromJson', () {
    test('falls back to a stored range when no menu is present', () {
      final shop = CoffeeShopModel.fromJson(const {
        'id': 'drop',
        'name': 'Drop Coffee',
        'priceRange': 'PKR 800 – 1,300',
      });

      expect(shop.priceRange, 'PKR 800 – 1,300');
      expect(shop.categories, [ShopCategory.specialtyCoffee]);
      expect(shop.menu, isEmpty);
    });

    test('formats thousands without an intl dependency', () {
      expect(CoffeeShopModel.formatPkr(950), '950');
      expect(CoffeeShopModel.formatPkr(1250), '1,250');
      expect(CoffeeShopModel.formatPkr(10450), '10,450');
    });
  });
}
