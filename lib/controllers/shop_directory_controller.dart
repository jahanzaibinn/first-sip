import 'package:get/get.dart';

import '../data/shop_directory.dart';
import '../models/coffee_shop_model.dart';
import '../routes/app_routes.dart';

/// Filters and searches the curated Karachi coffee directory.
class ShopDirectoryController extends GetxController {
  final RxString activeFilterId = 'all'.obs;
  final RxString searchQuery = ''.obs;
  final Rxn<CoffeeShopModel> selectedShop = Rxn<CoffeeShopModel>();

  List<ShopFilter> get filters => ShopDirectoryData.filters;
  List<CoffeeShopModel> get allShops => ShopDirectoryData.shops;

  String get activeFilterLabel => filters
      .firstWhere(
        (filter) => filter.id == activeFilterId.value,
        orElse: () => filters.first,
      )
      .label;

  /// Reactive result list — read inside an `Obx` for live filtering.
  List<CoffeeShopModel> get visibleShops => allShops
      .where((shop) =>
          shop.hasCategory(activeFilterId.value) &&
          shop.matches(searchQuery.value))
      .toList(growable: false);

  int countFor(String filterId) =>
      allShops.where((shop) => shop.hasCategory(filterId)).length;

  void selectFilter(String filterId) => activeFilterId.value = filterId;

  void setQuery(String value) => searchQuery.value = value;

  void clearSearch() => searchQuery.value = '';

  void resetFilters() {
    activeFilterId.value = 'all';
    searchQuery.value = '';
  }

  void openShop(CoffeeShopModel shop) {
    selectedShop.value = shop;
    Get.toNamed(AppRoutes.shopDetail, arguments: shop);
  }
}
