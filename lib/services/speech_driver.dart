import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// A recognition language installed on the device.
class SpeechLocale {
  const SpeechLocale(this.localeId, this.name);

  final String localeId;
  final String name;
}

typedef SpeechWordsCallback = void Function(String words, bool isFinal);
typedef SpeechErrorCallback = void Function(String message);
typedef SpeechListeningCallback = void Function(bool listening);

/// Small seam over the speech plugin so controllers can be unit tested with a
/// fake instead of a microphone.
abstract class SpeechDriver {
  Future<bool> initialize({
    required SpeechWordsCallback onWords,
    required SpeechErrorCallback onError,
    required SpeechListeningCallback onListening,
  });

  Future<List<SpeechLocale>> locales();

  Future<void> listen(String localeId);

  Future<void> stop();

  Future<void> cancel();

  Future<void> dispose();
}

/// Real microphone recognition through `speech_to_text`.
class DeviceSpeechDriver implements SpeechDriver {
  final SpeechToText _speech = SpeechToText();

  SpeechWordsCallback? _onWords;
  SpeechErrorCallback? _onError;
  SpeechListeningCallback? _onListening;

  @override
  Future<bool> initialize({
    required SpeechWordsCallback onWords,
    required SpeechErrorCallback onError,
    required SpeechListeningCallback onListening,
  }) async {
    _onWords = onWords;
    _onError = onError;
    _onListening = onListening;

    return _speech.initialize(
      onError: (SpeechRecognitionError error) =>
          _onError?.call(_readableError(error)),
      onStatus: (_) => _onListening?.call(_speech.isListening),
    );
  }

  @override
  Future<List<SpeechLocale>> locales() async {
    final available = await _speech.locales();
    return available
        .map((locale) => SpeechLocale(locale.localeId, locale.name))
        .toList(growable: false);
  }

  @override
  Future<void> listen(String localeId) {
    return _speech.listen(
      onResult: (result) =>
          _onWords?.call(result.recognizedWords, result.finalResult),
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        partialResults: true,
        cancelOnError: true,
        listenFor: const Duration(seconds: 20),
        pauseFor: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Future<void> stop() => _speech.stop();

  @override
  Future<void> cancel() => _speech.cancel();

  @override
  Future<void> dispose() async {
    if (_speech.isListening) await _speech.cancel();
  }

  String _readableError(SpeechRecognitionError error) {
    switch (error.errorMsg) {
      case 'error_no_match':
        return 'Did not catch any words. Tap the mic and speak again.';
      case 'error_network':
        return 'Speech recognition needs an internet connection right now.';
      case 'error_permission':
      case 'error_audio_error':
        return 'Microphone permission is needed to hear your order.';
      case 'error_speech_timeout':
        return 'That was too quiet. Tap the mic and speak clearly.';
      default:
        return 'Could not hear that (${error.errorMsg}). Please try again.';
    }
  }
}
