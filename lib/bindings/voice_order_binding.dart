import 'package:get/get.dart';

import '../controllers/voice_order_controller.dart';

/// Fresh microphone state for every visit to the voice-order screen.
class VoiceOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceOrderController>(() => VoiceOrderController());
  }
}
