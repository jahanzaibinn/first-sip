import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/shop_directory.dart';
import '../models/coffee_shop_model.dart';
import '../routes/app_routes.dart';
import '../services/coffee_api_service.dart';

/// Loads the live Karachi coffee directory and exposes it reactively.
///
/// `shops` starts empty and is filled by [fetchDynamicShops], which the screen
/// renders through a loading / error / populated state switch.
class ShopDirectoryController extends GetxController {
  ShopDirectoryController({CoffeeApiService? service})
      : _service = service ?? CoffeeApiService();

  final CoffeeApiService _service;

  final RxList<CoffeeShopModel> shops = <CoffeeShopModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final Rx<DateTime?> lastSyncedAt = Rxn<DateTime>();
  final RxString activeFilterId = 'all'.obs;
  final RxString searchQuery = ''.obs;
  final Rxn<CoffeeShopModel> selectedShop = Rxn<CoffeeShopModel>();

  List<ShopFilter> get filters => ShopDirectoryData.filters;

  bool get hasData => shops.isNotEmpty;
  bool get hasError => errorMessage.value != null;
  bool get isInitialLoad => isLoading.value && shops.isEmpty;

  @override
  void onInit() {
    super.onInit();
    fetchDynamicShops();
  }

  /// Pulls outlets, live menus and current PKR prices.
  ///
  /// [showLoader] is false for pull-to-refresh, where [RefreshIndicator] owns
  /// the spinner; a failed refresh keeps the existing list and surfaces a
  /// snackbar instead of wiping the screen.
  Future<void> fetchDynamicShops({bool showLoader = true}) async {
    if (isLoading.value) return;
    if (showLoader) isLoading.value = true;
    errorMessage.value = null;

    try {
      final snapshot = await _service.fetchShops();
      shops.assignAll(snapshot.shops);
      lastSyncedAt.value = snapshot.updatedAt ?? DateTime.now();
    } on CoffeeApiException catch (error) {
      if (!showLoader && shops.isNotEmpty) {
        Get.snackbar(
          'Could not refresh prices',
          error.message,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 18,
        );
      } else {
        errorMessage.value = error.message;
      }
    } catch (_) {
      errorMessage.value =
          'Something went wrong loading the directory. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDirectory() => fetchDynamicShops(showLoader: false);

  void retry() => fetchDynamicShops();

  String get activeFilterLabel => filters
      .firstWhere(
        (filter) => filter.id == activeFilterId.value,
        orElse: () => filters.first,
      )
      .label;

  /// Reactive result list — read inside an `Obx` for live filtering.
  List<CoffeeShopModel> get visibleShops => shops
      .where((shop) =>
          shop.hasCategory(activeFilterId.value) &&
          shop.matches(searchQuery.value))
      .toList(growable: false);

  int countFor(String filterId) =>
      shops.where((shop) => shop.hasCategory(filterId)).length;

  /// Short label for the "live prices" status line.
  String get lastSyncLabel {
    final time = lastSyncedAt.value;
    if (time == null) return 'Live menu';
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'Live prices · just updated';
    if (diff.inMinutes < 60) return 'Live prices · ${diff.inMinutes} min ago';
    if (diff.inHours < 24) return 'Live prices · ${diff.inHours} h ago';
    return 'Live prices · ${time.day}/${time.month}';
  }

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

  @override
  void onClose() {
    _service.dispose();
    super.onClose();
  }
}
