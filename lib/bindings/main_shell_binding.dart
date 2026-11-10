import 'package:get/get.dart';

import '../controllers/bean_guide_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/order_builder_controller.dart';

/// Screen-level binding for the tabbed shell.
class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BeanGuideController>(() => BeanGuideController());
    Get.lazyPut<OrderBuilderController>(() => OrderBuilderController());
  }
}
