/// Categories powering the Karachi spot finder filter chips.
enum ShopCategory {
  specialtyCoffee,
  workspaceFriendly,
  lateNight,
  budgetFriendly
}

extension ShopCategoryX on ShopCategory {
  String get id => switch (this) {
        ShopCategory.specialtyCoffee => 'specialty',
        ShopCategory.workspaceFriendly => 'workspace',
        ShopCategory.lateNight => 'late_night',
        ShopCategory.budgetFriendly => 'budget',
      };

  String get label => switch (this) {
        ShopCategory.specialtyCoffee => 'Specialty Coffee',
        ShopCategory.workspaceFriendly => 'Workspace Friendly',
        ShopCategory.lateNight => 'Late Night',
        ShopCategory.budgetFriendly => 'Budget Friendly',
      };

  String get shortLabel => switch (this) {
        ShopCategory.specialtyCoffee => 'Specialty',
        ShopCategory.workspaceFriendly => 'Workspace',
        ShopCategory.lateNight => 'Late Night',
        ShopCategory.budgetFriendly => 'Budget',
      };
}

/// A Karachi coffee outlet in the curated directory.
class CoffeeShopModel {
  const CoffeeShopModel({
    required this.id,
    required this.name,
    required this.area,
    required this.tagline,
    required this.description,
    required this.vibeTag,
    required this.openingHours,
    required this.priceRange,
    required this.rating,
    required this.categories,
    required this.signatureDrinks,
    required this.mustTry,
    required this.addressHint,
    required this.badges,
    this.priceFrom = 0,
    this.priceTo = 0,
  });

  final String id;
  final String name;
  final String area;
  final String tagline;
  final String description;
  final String vibeTag;
  final String openingHours;
  final String priceRange;
  final double rating;
  final List<ShopCategory> categories;
  final List<String> signatureDrinks;
  final List<String> mustTry;
  final String addressHint;
  final List<String> badges;

  /// Numeric range (PKR) so the controller can sort by affordability.
  final int priceFrom;
  final int priceTo;

  bool get isLateNight => categories.contains(ShopCategory.lateNight);
  bool get isWorkspaceFriendly =>
      categories.contains(ShopCategory.workspaceFriendly);

  bool hasCategory(String categoryId) {
    if (categoryId == 'all') return true;
    return categories.any((category) => category.id == categoryId);
  }

  bool matches(String query) {
    if (query.trim().isEmpty) return true;
    final needle = query.toLowerCase();
    return name.toLowerCase().contains(needle) ||
        area.toLowerCase().contains(needle) ||
        vibeTag.toLowerCase().contains(needle) ||
        signatureDrinks.any((drink) => drink.toLowerCase().contains(needle)) ||
        categories
            .any((category) => category.label.toLowerCase().contains(needle));
  }
}
