import 'package:get/get.dart';

import '../controllers/quiz_controller.dart';

/// A fresh quiz session every time the screen is opened.
class QuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizController>(() => QuizController());
  }
}
