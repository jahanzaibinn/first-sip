import 'package:flutter_test/flutter_test.dart';
import 'package:karachi_coffee_compass/models/coffee_shop_model.dart';
import 'package:karachi_coffee_compass/services/order_intent.dart';

CoffeeShopModel _floc() => CoffeeShopModel.fromJson(const {
      'id': 'floc',
      'name': 'FLOC',
      'area': 'DHA Phase 5',
      'menu': [
        {'name': 'Flat White', 'price': 750},
        {'name': 'Pistachio Latte', 'price': 1400},
        {'name': 'Iced Filter', 'price': 1200},
        {'name': 'Cold Brew', 'price': 950},
      ],
    });

void main() {
  const parser = OrderIntentParser();

  group('OrderIntentParser', () {
    test('reads an Urdu sentence end to end', () {
      final intent = parser.parse('ٹھنڈا اوٹ دودھ لیٹے کم میٹھا چاہیے');

      expect(intent.temperature, CoffeeTemperature.iced);
      expect(intent.milk, MilkChoice.oat);
      expect(intent.drink, 'Latte');
      expect(intent.sweetness, Sweetness.half);
      expect(intent.signals, contains('cold'));
      expect(intent.signals, contains('oat milk'));
      expect(intent.signals, contains('less sugar'));
    });

    test('reads roman Urdu typed on an English keyboard', () {
      final intent = parser.parse('thanda oat doodh latte kam meetha chahiye');

      expect(intent.temperature, CoffeeTemperature.iced);
      expect(intent.milk, MilkChoice.oat);
      expect(intent.drink, 'Latte');
      expect(intent.sweetness, Sweetness.half);
    });

    test('reads plain English', () {
      final intent = parser.parse('hot cappuccino with caramel and no sugar');

      expect(intent.temperature, CoffeeTemperature.hot);
      expect(intent.drink, 'Cappuccino');
      expect(intent.flavour, 'caramel');
      expect(intent.sweetness, Sweetness.none);
    });

    test('treats "no milk" as black rather than whole milk', () {
      final intent = parser.parse('بغیر دودھ کافی چاہیے');

      expect(intent.milk, MilkChoice.none);
    });

    test('pulls a budget out of the sentence', () {
      final intent = parser.parse('سستا کولڈ بریو 800 روپے');

      expect(intent.maxPrice, 800);
      expect(intent.drink, 'Cold Brew');
      expect(intent.signals, contains('under PKR 800'));
    });

    test('ignores punctuation and Arabic letter variants', () {
      final intent = parser.parse('ٹھنڈی كافی، please!');
      expect(intent.temperature, CoffeeTemperature.iced);
    });
  });

  group('OrderSuggestions', () {
    test('builds the app\'s canonical counter phrase', () {
      final order = OrderSuggestions.suggest(
        'ٹھنڈا اوٹ دودھ لیٹے کم میٹھا کرامیل چاہیے',
      );

      expect(order.drinkName, 'Medium Iced Oat Milk Latte');
      expect(
        order.englishPhrase,
        'I\'d like a Medium Iced Oat Milk Latte with half-sweet Caramel, '
        'please.',
      );
      expect(order.urduPhrase, contains('میڈیم'));
      expect(order.urduPhrase, contains('لیٹے'));
      expect(order.urduPhrase, contains('کرامیل'));
    });

    test('defaults to a medium latte when nothing specific was said', () {
      final order = OrderSuggestions.suggest('کافی چاہیے');

      expect(order.drinkName, 'Medium Latte');
      expect(order.englishPhrase, 'I\'d like a Medium Latte, please.');
    });

    test('matches the closest row on the shop\'s live menu', () {
      final order = OrderSuggestions.suggest(
        'ٹھنڈا پستہ لیٹے چاہیے',
        shop: _floc(),
      );

      expect(order.drinkName, 'Pistachio Latte');
      expect(order.pricePkr, 1400);
      expect(order.menuItem?.name, 'Pistachio Latte');
      expect(order.reason, contains('live menu'));
    });

    test('will not suggest a menu item above the spoken budget', () {
      final order = OrderSuggestions.suggest(
        'cold brew under 900',
        shop: _floc(),
      );

      // The only cold brew on the menu is PKR 950, so it is left out.
      expect(order.menuItem, isNull);
      expect(order.pricePkr, isNull);
      expect(order.drinkName, contains('Cold Brew'));
    });

    test('does not duplicate a flavour that is already in the drink name', () {
      final order = OrderSuggestions.suggest(
        'پستہ لیٹے ٹھنڈا',
        shop: _floc(),
      );

      expect(order.englishPhrase.toLowerCase(), isNot(contains('with pistachio')));
    });

    test('explains why the order was picked', () {
      final order = OrderSuggestions.suggest('بنانا نہیں، سادہ کافی');
      expect(order.reason, isNotEmpty);
    });
  });
}
