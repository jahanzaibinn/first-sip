import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/coffee_shop_model.dart';
import '../services/order_intent.dart';
import '../services/speech_driver.dart';
import '../theme/app_colors.dart';

/// Drives the "speak your order" screen: microphone state, the live transcript
/// and the suggested counter order in English and Urdu.
class VoiceOrderController extends GetxController {
  VoiceOrderController({SpeechDriver? driver})
      : _driver = driver ?? DeviceSpeechDriver();

  final SpeechDriver _driver;

  final RxBool isListening = false.obs;
  final RxBool isStarting = false.obs;
  final RxBool speechUnavailable = false.obs;
  final RxBool hasUrduLocale = false.obs;
  final RxString transcript = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxnString selectedExample = RxnString();
  final Rxn<OrderSuggestion> suggestion = Rxn<OrderSuggestion>();

  /// `ur` or `en`.
  final RxString language = 'ur'.obs;

  CoffeeShopModel? shop;

  bool _initialised = false;
  List<SpeechLocale> _locales = const [];

  static const List<String> urduExamples = [
    'ٹھنڈا اوٹ دودھ لیٹے کم میٹھا چاہیے',
    'کرامیل والا موکا چاہیے، بغیر چینی',
    'کولڈ بریو چاہیے، سستا ہو',
  ];

  static const List<String> englishExamples = [
    'Iced oat milk latte with caramel, less sugar',
    'A cheap cold brew with no sugar',
    'Hot cappuccino with extra caramel',
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is CoffeeShopModel) shop = args;
  }

  bool get isUrdu => language.value == 'ur';

  List<String> get examples => isUrdu ? urduExamples : englishExamples;

  String get localeId {
    final prefix = isUrdu ? 'ur' : 'en';
    for (final locale in _locales) {
      if (locale.localeId.toLowerCase().startsWith(prefix)) {
        return locale.localeId;
      }
    }
    return isUrdu ? 'ur_PK' : 'en_US';
  }

  String get languageLabel => isUrdu ? 'اردو' : 'English';

  void setLanguage(String value) {
    if (value != 'ur' && value != 'en') return;
    if (language.value == value) return;
    language.value = value;
    if (isListening.value) stopListening();
  }

  Future<void> startListening() async {
    if (isStarting.value || isListening.value) return;

    errorMessage.value = '';
    selectedExample.value = null;
    isStarting.value = true;

    try {
      if (!_initialised) {
        final ready = await _driver.initialize(
          onWords: _onWords,
          onError: _onError,
          onListening: _onListening,
        );
        _initialised = ready;
        if (ready) {
          _locales = await _driver.locales();
          hasUrduLocale.value = _locales
              .any((locale) => locale.localeId.toLowerCase().startsWith('ur'));
        }
      }

      if (!_initialised) {
        speechUnavailable.value = true;
        errorMessage.value =
            'Speech recognition is not available on this device. Tap an '
            'example below instead.';
        return;
      }

      transcript.value = '';
      suggestion.value = null;

      await _driver.listen(localeId);
      isListening.value = true;
    } catch (_) {
      errorMessage.value =
          'Could not start the microphone. Check the permission and try again.';
      isListening.value = false;
    } finally {
      isStarting.value = false;
    }
  }

  Future<void> stopListening() async {
    if (!isListening.value) return;
    await _driver.stop();
    isListening.value = false;
    _suggestFromTranscript();
  }

  Future<void> toggleListening() async {
    if (isListening.value) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  /// Lets the user try the feature when the mic or a locale is missing.
  void useExample(String text) {
    selectedExample.value = text;
    transcript.value = text;
    errorMessage.value = '';
    suggestion.value = OrderSuggestions.suggest(text, shop: shop);
  }

  void clear() {
    transcript.value = '';
    selectedExample.value = null;
    suggestion.value = null;
    errorMessage.value = '';
  }

  Future<void> copyPhrase() async {
    final order = suggestion.value;
    if (order == null) return;
    await Clipboard.setData(ClipboardData(text: order.englishPhrase));
    Get.snackbar(
      'Order copied',
      order.englishPhrase,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 18,
      backgroundColor: AppColors.espresso,
      colorText: AppColors.cream,
      icon: const Icon(Icons.content_copy_rounded, color: AppColors.caramel),
    );
  }

  void _onWords(String words, bool isFinal) {
    transcript.value = words;
    if (isFinal) {
      isListening.value = false;
      _suggestFromTranscript();
    }
  }

  void _onError(String message) {
    errorMessage.value = message;
    isListening.value = false;
  }

  void _onListening(bool listening) {
    isListening.value = listening;
    if (!listening) _suggestFromTranscript();
  }

  void _suggestFromTranscript() {
    final text = transcript.value.trim();
    if (text.isEmpty) return;
    suggestion.value = OrderSuggestions.suggest(text, shop: shop);
  }

  @override
  void onClose() {
    _driver.dispose();
    super.onClose();
  }
}
