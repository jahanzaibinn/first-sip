import '../models/quiz_step_model.dart';

class QuizData {
  const QuizData._();

  static const List<QuizStep> steps = [
    QuizStep(
      id: 'taste',
      question: 'How do you like your drink?',
      subtitle: 'Pick the cup you reach for on a good day.',
      options: [
        QuizOption(
          id: 'bold_black',
          label: 'Bold & Black',
          description: 'No milk, no sugar. Just the bean.',
          hint: 'Espresso · Filter',
        ),
        QuizOption(
          id: 'sweet_milky',
          label: 'Sweet & Milky',
          description: 'Creamy, dessert-adjacent, comforting.',
          hint: 'Latte · Spanish',
        ),
        QuizOption(
          id: 'smooth_creamy',
          label: 'Smooth & Creamy',
          description: 'Velvety texture with a gentle finish.',
          hint: 'Flat White · Cortado',
        ),
        QuizOption(
          id: 'chilled_iced',
          label: 'Chilled & Iced',
          description: 'Cold, refreshing, made for Karachi heat.',
          hint: 'Cold Brew · Iced',
        ),
      ],
    ),
    QuizStep(
      id: 'energy',
      question: 'What is your energy goal?',
      subtitle: 'This decides how hard your cup should hit.',
      options: [
        QuizOption(
          id: 'intense',
          label: 'Intense Caffeine Kick',
          description: 'Deadline mode. Wake me up properly.',
          hint: 'Highest caffeine',
        ),
        QuizOption(
          id: 'casual',
          label: 'Casual Sipper',
          description: 'A companion to conversation, not a jolt.',
          hint: 'Moderate caffeine',
        ),
        QuizOption(
          id: 'dessert',
          label: 'Sweet Treat',
          description: 'Replacing dessert with something better.',
          hint: 'Sweet & rich',
        ),
        QuizOption(
          id: 'light',
          label: 'Light & Antioxidant-Rich',
          description: 'Gentle lift, more good-for-you compounds.',
          hint: 'Light roast',
        ),
      ],
    ),
  ];
}
