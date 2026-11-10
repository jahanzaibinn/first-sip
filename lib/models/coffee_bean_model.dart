/// Species of coffee plant used for the bean knowledge hub.
enum BeanSpecies { arabica, robusta }

extension BeanSpeciesX on BeanSpecies {
  String get label => switch (this) {
        BeanSpecies.arabica => 'Arabica',
        BeanSpecies.robusta => 'Robusta',
      };

  String get scientificName => switch (this) {
        BeanSpecies.arabica => 'Coffea arabica',
        BeanSpecies.robusta => 'Coffea canephora',
      };
}

/// A single bean profile shown in the "Bean & Health Knowledge Hub".
class CoffeeBeanModel {
  const CoffeeBeanModel({
    required this.species,
    required this.tagline,
    required this.origin,
    required this.altitude,
    required this.roastLevel,
    required this.aroma,
    required this.tasteSummary,
    required this.crema,
    required this.antioxidantNote,
    required this.flavourNotes,
    required this.bestFor,
    required this.funFact,
    required this.caffeineScore,
    required this.acidityScore,
    required this.sweetnessScore,
    required this.bitternessScore,
    required this.bodyScore,
  });

  final BeanSpecies species;
  final String tagline;
  final String origin;
  final String altitude;
  final String roastLevel;
  final String aroma;
  final String tasteSummary;
  final String crema;
  final String antioxidantNote;
  final List<String> flavourNotes;
  final List<String> bestFor;
  final String funFact;

  /// All scores are 0–5 for consistent indicator rendering.
  final int caffeineScore;
  final int acidityScore;
  final int sweetnessScore;
  final int bitternessScore;
  final int bodyScore;

  String get name => species.label;
  String get fullName => '${species.label} · ${species.scientificName}';
}
