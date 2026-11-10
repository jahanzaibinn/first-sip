import 'package:get/get.dart';

import '../data/drink_catalog.dart';
import '../data/quiz_data.dart';
import '../models/drink_recommendation_model.dart';
import '../models/quiz_step_model.dart';

/// Drives the two-step coffee recommendation quiz.
///
/// State is deliberately tiny and reactive: a step index, a reactive answer map
/// and the resulting drink. Every screen widget reads these through `Obx`.
class QuizController extends GetxController {
  final RxInt currentStep = 0.obs;
  final RxMap<String, String> userAnswers = <String, String>{}.obs;
  final Rxn<DrinkRecommendationModel> recommendation =
      Rxn<DrinkRecommendationModel>();

  List<QuizStep> get steps => QuizData.steps;
  int get questionCount => steps.length;
  bool get showingResult => recommendation.value != null;
  bool get isOnLastQuestion => currentStep.value == steps.length - 1;
  int get resultStepIndex => steps.length;

  QuizStep get activeStep {
    final index = currentStep.value;
    if (index < 0 || index >= steps.length) return steps.first;
    return steps[index];
  }

  double get progress {
    if (showingResult) return 1;
    return (currentStep.value + (selectedFor(activeStep.id).isEmpty ? 0 : 1)) /
        questionCount;
  }

  String selectedFor(String stepId) => userAnswers[stepId] ?? '';

  /// Records an answer and either advances or computes the recommendation.
  void answer(String optionId) {
    userAnswers[activeStep.id] = optionId;
    userAnswers.refresh();

    if (isOnLastQuestion) {
      _computeRecommendation();
      currentStep.value = resultStepIndex;
    } else {
      currentStep.value = currentStep.value + 1;
    }
  }

  void next() {
    if (selectedFor(activeStep.id).isEmpty) return;
    if (isOnLastQuestion) {
      _computeRecommendation();
      currentStep.value = resultStepIndex;
    } else {
      currentStep.value = currentStep.value + 1;
    }
  }

  void back() {
    if (showingResult) {
      recommendation.value = null;
      currentStep.value = steps.length - 1;
      return;
    }
    if (currentStep.value == 0) {
      Get.back();
      return;
    }
    currentStep.value = currentStep.value - 1;
  }

  void reset() {
    currentStep.value = 0;
    userAnswers.clear();
    userAnswers.refresh();
    recommendation.value = null;
  }

  void _computeRecommendation() {
    final taste = userAnswers['taste'];
    final energy = userAnswers['energy'];
    if (taste == null || energy == null) return;
    recommendation.value = DrinkCatalog.resolve(taste: taste, energy: energy);
  }

  String answerLabel(String stepId, String optionId) {
    for (final step in steps) {
      if (step.id != stepId) continue;
      for (final option in step.options) {
        if (option.id == optionId) return option.label;
      }
    }
    return '';
  }
}
