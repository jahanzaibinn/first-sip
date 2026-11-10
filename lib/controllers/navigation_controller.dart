import 'package:get/get.dart';

/// Bottom-navigation state shared by the home dashboard and the shell.
class NavigationController extends GetxController {
  final RxInt tabIndex = 0.obs;

  void goToTab(int index) {
    if (index < 0 || index > 3) return;
    tabIndex.value = index;
  }

  void openBeanGuide() => goToTab(1);
  void openOrderBuilder() => goToTab(2);
  void openSpots() => goToTab(3);
}
