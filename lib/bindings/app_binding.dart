import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../controllers/shop_directory_controller.dart';

/// Injected once at app start and kept alive for the whole session.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController(), permanent: true);
    Get.put(ShopDirectoryController(), permanent: true);
  }
}
