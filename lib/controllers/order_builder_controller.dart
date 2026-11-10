import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../data/order_options.dart';
import '../models/brew_option_model.dart';
import '../theme/app_colors.dart';

/// Builds the exact phrase a customer reads or speaks at the counter.
///
/// Every getter below reads Rx values, so wrapping `orderPhrase` in an `Obx`
/// keeps the live banner in sync with the chips automatically.
class OrderBuilderController extends GetxController {
  final Rx<BrewOption> sizeOption = OrderOptions.sizes[1].obs;
  final Rx<BrewOption> baseOption = OrderOptions.bases.first.obs;
  final Rx<BrewOption> milkOption = OrderOptions.milks.first.obs;
  final Rx<BrewOption> sweetnessOption = OrderOptions.sweetness.first.obs;
  final Rx<BrewOption> flavourOption = OrderOptions.flavours.first.obs;
  final RxBool isIced = true.obs;

  List<BrewOption> get sizes => OrderOptions.sizes;
  List<BrewOption> get bases => OrderOptions.bases;
  List<BrewOption> get milks => OrderOptions.milks;
  List<BrewOption> get sweetnessLevels => OrderOptions.sweetness;
  List<BrewOption> get flavours => OrderOptions.flavours;

  bool get hasMilk => milkOption.value.id != 'water';
  bool get isColdBrew => baseOption.value.id == 'cold_brew';
  bool get canChooseTemperature => !isColdBrew;

  String get milkLabel => hasMilk ? milkOption.value.label : '';

  /// The espresso-bar name implied by the base + milk combination.
  String get drinkCore {
    switch (baseOption.value.id) {
      case 'espresso':
        return hasMilk ? 'Cortado' : 'Espresso';
      case 'double':
        return hasMilk ? 'Latte' : 'Doppio';
      case 'cold_brew':
        return 'Cold Brew';
      case 'drip':
        return hasMilk ? 'Café au Lait' : 'Filter Coffee';
      default:
        return 'Coffee';
    }
  }

  String get temperatureLabel => isIced.value ? 'Iced' : 'Hot';

  /// e.g. "Medium Iced Oat Milk Latte"
  String get drinkName {
    final parts = <String>[
      sizeOption.value.label,
      temperatureLabel,
      if (hasMilk) milkLabel,
      drinkCore,
    ];
    return parts.join(' ');
  }

  /// e.g. "I'd like a Medium Iced Oat Milk Latte with half-sweet Caramel, please."
  String get orderPhrase {
    final flavour = flavourOption.value;
    final hasFlavour = flavour.id != 'none';
    final sweetId = sweetnessOption.value.id;

    if (!hasFlavour && sweetId == 'none') {
      return 'I\'d like a $drinkName, please.';
    }
    if (hasFlavour && sweetId == 'none') {
      return 'I\'d like a $drinkName with unsweetened ${flavour.label}, please.';
    }
    if (!hasFlavour) {
      final sweetness = sweetId == 'half' ? 'half sweetness' : 'full sweetness';
      return 'I\'d like a $drinkName with $sweetness, please.';
    }
    final sweetWord = sweetId == 'half' ? 'half-sweet' : 'fully sweet';
    return 'I\'d like a $drinkName with $sweetWord ${flavour.label}, please.';
  }

  /// Short badge used under the live banner, e.g. "Half-Sweet Caramel".
  String get toppingLabel {
    final flavour = flavourOption.value;
    final sweetId = sweetnessOption.value.id;
    if (flavour.id == 'none' && sweetId == 'none') return 'Unsweetened';
    if (flavour.id == 'none') {
      return sweetId == 'half' ? 'Half-Sweet' : 'Full Sweet';
    }
    if (sweetId == 'none') return 'Unsweetened ${flavour.label}';
    return '${sweetId == 'half' ? 'Half-Sweet' : 'Fully Sweet'} ${flavour.label}';
  }

  double get _sizeFactor => switch (sizeOption.value.id) {
        'Small' => 0.8,
        'Large' => 1.3,
        _ => 1.0,
      };

  int get caffeineMg {
    final base = switch (baseOption.value.id) {
      'espresso' => 75,
      'double' => 150,
      'cold_brew' => 200,
      'drip' => 120,
      _ => 80,
    };
    return (base * _sizeFactor).round();
  }

  int get calories {
    final base = switch (baseOption.value.id) {
      'cold_brew' => 15,
      'drip' => 5,
      'double' => 10,
      _ => 5,
    };
    final milk = switch (milkOption.value.id) {
      'whole' => 90,
      'skim' => 60,
      'oat' => 100,
      'almond' => 45,
      _ => 0,
    };
    final sugar = switch (sweetnessOption.value.id) {
      'half' => 30,
      'full' => 60,
      _ => 0,
    };
    final syrup = flavourOption.value.id == 'none' ? 0 : 25;
    return ((base + milk) * _sizeFactor + sugar + syrup).round();
  }

  int get selectionsMade => 5;

  void selectSize(BrewOption option) => sizeOption.value = option;

  void selectBase(BrewOption option) {
    baseOption.value = option;
    if (option.id == 'cold_brew') isIced.value = true;
  }

  void selectMilk(BrewOption option) => milkOption.value = option;

  void selectSweetness(BrewOption option) => sweetnessOption.value = option;

  void selectFlavour(BrewOption option) => flavourOption.value = option;

  void setIced(bool value) {
    if (isColdBrew) {
      isIced.value = true;
      return;
    }
    isIced.value = value;
  }

  void reset() {
    sizeOption.value = OrderOptions.sizes[1];
    baseOption.value = OrderOptions.bases.first;
    milkOption.value = OrderOptions.milks.first;
    sweetnessOption.value = OrderOptions.sweetness.first;
    flavourOption.value = OrderOptions.flavours.first;
    isIced.value = true;
  }

  Future<void> copyOrderPhrase() async {
    await Clipboard.setData(ClipboardData(text: orderPhrase));
    Get.snackbar(
      'Copied for the counter',
      orderPhrase,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 18,
      backgroundColor: AppColors.espresso,
      colorText: AppColors.cream,
      icon: const Icon(Icons.content_copy_rounded, color: AppColors.caramel),
    );
  }
}
