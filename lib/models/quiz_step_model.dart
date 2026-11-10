/// One answer option inside a quiz question.
class QuizOption {
  const QuizOption({
    required this.id,
    required this.label,
    required this.description,
    required this.hint,
  });

  final String id;
  final String label;
  final String description;
  final String hint;
}

/// One interactive question in the recommendation quiz.
class QuizStep {
  const QuizStep({
    required this.id,
    required this.question,
    required this.subtitle,
    required this.options,
  });

  final String id;
  final String question;
  final String subtitle;
  final List<QuizOption> options;
}
