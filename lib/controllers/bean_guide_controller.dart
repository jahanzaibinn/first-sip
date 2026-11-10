import 'package:get/get.dart';

import '../data/coffee_beans.dart';
import '../models/coffee_bean_model.dart';
import '../models/milk_ratio_model.dart';

/// Tab state for the bean & health knowledge hub.
class BeanGuideController extends GetxController {
  final RxInt activeBeanIndex = 0.obs;
  final RxnString expandedMilkRatio = RxnString();

  List<CoffeeBeanModel> get beans => CoffeeBeansData.beans;
  List<MilkRatioModel> get milkRatios => CoffeeBeansData.milkRatios;

  CoffeeBeanModel get activeBean =>
      beans[activeBeanIndex.value.clamp(0, beans.length - 1).toInt()];

  bool get showingRobusta => activeBeanIndex.value == 1;

  void selectBean(int index) {
    if (index < 0 || index >= beans.length) return;
    activeBeanIndex.value = index;
  }

  void toggleMilkRatio(String name) {
    expandedMilkRatio.value = expandedMilkRatio.value == name ? null : name;
  }
}
