import 'package:flutter_test/flutter_test.dart';
import 'package:karachi_coffee_compass/controllers/order_builder_controller.dart';
import 'package:karachi_coffee_compass/data/order_options.dart';

void main() {
  group('OrderBuilderController', () {
    test('composes the exact counter phrase from the default flow', () {
      final controller = OrderBuilderController();

      controller.selectSize(OrderOptions.sizes[1]); // Medium
      controller.selectBase(OrderOptions.bases[1]); // Double Shot
      controller.selectMilk(OrderOptions.milks[2]); // Oat Milk
      controller.selectSweetness(OrderOptions.sweetness[1]); // Half-Sweet
      controller.selectFlavour(OrderOptions.flavours[3]); // Caramel
      controller.setIced(true);

      expect(controller.drinkName, 'Medium Iced Oat Milk Latte');
      expect(
        controller.orderPhrase,
        "I'd like a Medium Iced Oat Milk Latte with half-sweet Caramel, please.",
      );
    });

    test('black coffee drops the milk word and keeps the espresso name', () {
      final controller = OrderBuilderController();

      controller.selectMilk(OrderOptions.milks.last); // Water Only

      expect(controller.hasMilk, isFalse);
      expect(controller.drinkName, 'Medium Iced Espresso');
      expect(
        controller.orderPhrase,
        "I'd like a Medium Iced Espresso, please.",
      );
    });

    test('cold brew is always iced and large sizes scale caffeine', () {
      final controller = OrderBuilderController();

      controller.setIced(false);
      expect(controller.isIced.value, isFalse);

      controller.selectBase(OrderOptions.bases[2]); // Cold Brew
      expect(controller.canChooseTemperature, isFalse);
      expect(controller.isIced.value, isTrue);

      controller.setIced(false);
      expect(controller.isIced.value, isTrue);

      controller.selectSize(OrderOptions.sizes.last); // Large
      expect(controller.caffeineMg, 260);
    });

    test('reset returns every chip to its default', () {
      final controller = OrderBuilderController();

      controller.selectMilk(OrderOptions.milks[2]);
      controller.selectFlavour(OrderOptions.flavours[4]);
      controller.reset();

      expect(controller.milkOption.value.id, 'whole');
      expect(controller.flavourOption.value.id, 'none');
      expect(controller.orderPhrase,
          "I'd like a Medium Iced Whole Milk Cortado, please.");
    });
  });
}
