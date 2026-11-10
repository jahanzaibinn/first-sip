/// Espresso-to-milk ratio used by the bean guide visual breakdown.
class MilkRatioModel {
  const MilkRatioModel({
    required this.name,
    required this.espressoPercent,
    required this.milkPercent,
    required this.description,
    required this.strengthLabel,
  });

  final String name;

  /// Shares must add up to 100.
  final int espressoPercent;
  final int milkPercent;
  final String description;
  final String strengthLabel;
}
