/// A selectable option used by the order builder chips.
class BrewOption {
  const BrewOption({
    required this.id,
    required this.label,
    required this.detail,
  });

  final String id;
  final String label;
  final String detail;

  @override
  bool operator ==(Object other) => other is BrewOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
