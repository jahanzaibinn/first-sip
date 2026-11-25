import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/shop_directory.dart';
import '../models/coffee_shop_model.dart';
import '../routes/app_routes.dart';
import '../services/coffee_api_service.dart';
import '../services/location_service.dart';
import '../services/maps_service.dart';

/// Loads the live Karachi coffee directory and exposes it reactively.
///
/// `shops` starts empty and is filled by [fetchDynamicShops], which the screen
/// renders through a loading / error / populated state switch.
class ShopDirectoryController extends GetxController {
  ShopDirectoryController({
    CoffeeApiService? service,
    LocationService? locationService,
    MapsService? mapsService,
    void Function(String title, String message)? notify,
  })  : _service = service ?? CoffeeApiService(),
        _location = locationService ?? const LocationService(),
        _maps = mapsService ?? MapsService.instance,
        _notify = notify ?? _showSnack;

  final CoffeeApiService _service;
  final LocationService _location;
  final MapsService _maps;

  /// Overridable so unit tests do not need a widget tree for snackbars.
  final void Function(String title, String message) _notify;

  static void _showSnack(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
      borderRadius: 18,
    );
  }

  final RxList<CoffeeShopModel> shops = <CoffeeShopModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final Rx<DateTime?> lastSyncedAt = Rxn<DateTime>();
  final RxString activeFilterId = 'all'.obs;
  final RxString searchQuery = ''.obs;
  final Rxn<CoffeeShopModel> selectedShop = Rxn<CoffeeShopModel>();

  /// Live GPS fix, kept after the first lookup so distances stay on screen.
  final Rxn<GeoPoint> userLocation = Rxn<GeoPoint>();
  final RxBool isLocating = false.obs;
  final RxBool sortByDistance = false.obs;

  List<ShopFilter> get filters => ShopDirectoryData.filters;

  bool get hasData => shops.isNotEmpty;
  bool get hasError => errorMessage.value != null;
  bool get isInitialLoad => isLoading.value && shops.isEmpty;
  bool get nearMeActive => sortByDistance.value && userLocation.value != null;

  String get nearMeLabel {
    if (isLocating.value) return 'Locating…';
    return nearMeActive ? 'Nearest first' : 'Near me';
  }

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
        _notify('Could not refresh prices', error.message);
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
  ///
  /// When "Near me" is on, the closest outlets come first.
  List<CoffeeShopModel> get visibleShops {
    final result = shops
        .where((shop) =>
            shop.hasCategory(activeFilterId.value) &&
            shop.matches(searchQuery.value))
        .toList();

    if (sortByDistance.value && userLocation.value != null) {
      result.sort(
        (a, b) => (distanceKmFor(a) ?? double.infinity)
            .compareTo(distanceKmFor(b) ?? double.infinity),
      );
    }

    return List.unmodifiable(result);
  }

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

  /// Straight-line distance from the device to [shop], or null while the
  /// location is unknown.
  double? distanceKmFor(CoffeeShopModel shop) {
    final origin = userLocation.value;
    if (origin == null || !shop.hasCoordinates) return null;
    return LocationService.distanceKm(
      origin,
      GeoPoint(shop.latitude!, shop.longitude!),
    );
  }

  /// e.g. `850 m` or `4.2 km`, for the card and detail badges.
  String? distanceLabelFor(CoffeeShopModel shop) {
    final km = distanceKmFor(shop);
    if (km == null) return null;
    return LocationService.formatDistance(km);
  }

  /// Asks for a GPS fix; a second tap toggles the nearest-first ordering.
  Future<void> toggleNearMe() async {
    if (isLocating.value) return;

    if (userLocation.value != null) {
      sortByDistance.value = !sortByDistance.value;
      return;
    }

    isLocating.value = true;
    final result = await _location.currentLocation();
    isLocating.value = false;

    final point = result.point;
    if (point == null) {
      _notify('Location needed', result.message);
      return;
    }

    userLocation.value = point;
    sortByDistance.value = true;
  }

  /// Hands the shop to Google Maps for turn-by-turn directions.
  Future<void> openDirections(CoffeeShopModel shop) async {
    final opened = await _maps.openDirections(shop);
    if (opened) return;
    _notify(
      'Could not open Google Maps',
      'No app on this phone can open map links. Install Google Maps and try '
          'again.',
    );
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
