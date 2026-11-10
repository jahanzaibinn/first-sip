import 'package:get/get.dart';

import '../data/drink_catalog.dart';
import '../data/shop_directory.dart';
import '../models/coffee_shop_model.dart';
import '../models/drink_recommendation_model.dart';
import '../routes/app_routes.dart';
import 'navigation_controller.dart';

/// Home dashboard state: greeting, daily pour and spotlight outlets.
class HomeController extends GetxController {
  final Rx<DrinkRecommendationModel> dailyPour =
      DrinkCatalog.resolve(taste: 'sweet_milky', energy: 'casual').obs;

  final RxList<CoffeeShopModel> spotlight =
      ShopDirectoryData.shops.take(4).toList(growable: false).obs;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get dateLine {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final now = DateTime.now();
    return '${now.day} ${months[now.month - 1]} · Karachi';
  }

  void startQuiz() => Get.toNamed(AppRoutes.quiz);

  void openTab(int index) {
    final navigation = Get.find<NavigationController>();
    navigation.goToTab(index);
  }

  void openShop(CoffeeShopModel shop) =>
      Get.toNamed(AppRoutes.shopDetail, arguments: shop);

  void refreshSpotlight() {
    spotlight.assignAll(ShopDirectoryData.shops.reversed.take(4));
  }
}
