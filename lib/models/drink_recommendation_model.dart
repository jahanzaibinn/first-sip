/// The drink the quiz recommends, plus everything needed to render its card.
class DrinkRecommendationModel {
  const DrinkRecommendationModel({
    required this.id,
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.whyItMatches,
    required this.orderPhrase,
    required this.flavourNotes,
    required this.milkRatio,
    required this.beanSuggestion,
    required this.sweetness,
    required this.acidity,
    required this.bitterness,
    required this.body,
    required this.caffeineScore,
    required this.calories,
  });

  final String id;
  final String name;
  final String category;
  final String tagline;
  final String description;
  final String whyItMatches;

  /// The exact sentence to say at the counter.
  final String orderPhrase;
  final List<String> flavourNotes;
  final String milkRatio;
  final String beanSuggestion;

  /// Taste profile values are 0–1, used by the horizontal meters.
  final double sweetness;
  final double acidity;
  final double bitterness;
  final double body;

  /// 1–5 caffeine intensity and approximate kcal for a 12oz cup.
  final int caffeineScore;
  final int calories;
}
