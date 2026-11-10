import 'package:get/get.dart';

import '../bindings/main_shell_binding.dart';
import '../bindings/quiz_binding.dart';
import '../views/main_shell.dart';
import '../views/quiz_screen.dart';
import '../views/shop_detail_screen.dart';
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.shell,
      page: () => const MainShell(),
      binding: MainShellBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () => const QuizScreen(),
      binding: QuizBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 340),
    ),
    GetPage(
      name: AppRoutes.shopDetail,
      page: () => const ShopDetailScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 320),
    ),
  ];
}
