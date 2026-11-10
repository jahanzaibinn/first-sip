import 'package:flutter_test/flutter_test.dart';
import 'package:karachi_coffee_compass/controllers/quiz_controller.dart';

void main() {
  group('QuizController', () {
    test('records both answers and resolves a recommendation', () {
      final controller = QuizController();

      controller.answer('bold_black');
      expect(controller.currentStep.value, 1);
      expect(controller.showingResult, isFalse);

      controller.answer('intense');

      expect(controller.showingResult, isTrue);
      expect(controller.recommendation.value?.name, 'Double Espresso');
      expect(controller.userAnswers['taste'], 'bold_black');
      expect(controller.userAnswers['energy'], 'intense');
      expect(controller.progress, 1);
    });

    test('back from the result returns to the last question', () {
      final controller = QuizController();

      controller.answer('chilled_iced');
      controller.answer('dessert');
      expect(controller.recommendation.value?.name, 'Iced Spanish Latte');

      controller.back();

      expect(controller.showingResult, isFalse);
      expect(controller.currentStep.value, 1);

      controller.reset();
      expect(controller.currentStep.value, 0);
      expect(controller.userAnswers, isEmpty);
    });

    test('label lookup resolves option copy for the result chips', () {
      final controller = QuizController();

      expect(
          controller.answerLabel('taste', 'smooth_creamy'), 'Smooth & Creamy');
      expect(controller.answerLabel('taste', 'missing'), '');
    });
  });
}
