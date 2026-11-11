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

  /// Maps an API category id onto the enum, ignoring unknown values.
  static ShopCategory? fromId(String id) => switch (id.trim().toLowerCase()) {
        'specialty' ||
        'specialty_coffee' ||
        'specialtycoffee' =>
          ShopCategory.specialtyCoffee,
        'workspace' ||
        'workspace_friendly' ||
        'workspacefriendly' =>
          ShopCategory.workspaceFriendly,
        'late_night' || 'latenight' || 'late-night' => ShopCategory.lateNight,
        'budget' ||
        'budget_friendly' ||
        'budgetfriendly' =>
          ShopCategory.budgetFriendly,
        _ => null,
      };
}

/// A single priced item from a shop's live menu.
class CoffeeMenuItemModel {
  const CoffeeMenuItemModel({
    required this.name,
    required this.price,
    this.note,
  });

  final String name;

  /// Price in PKR.
  final int price;
  final String? note;

  factory CoffeeMenuItemModel.fromJson(Map<String, dynamic> json) {
    return CoffeeMenuItemModel(
      name: (json['name'] as Object?)?.toString().trim() ?? '',
      price: (json['price'] as num?)?.round() ?? 0,
      note: (json['note'] as Object?)?.toString(),
    );
  }
}

/// A Karachi coffee outlet, parsed from the remote directory payload.
class CoffeeShopModel {
  const CoffeeShopModel({
    required this.id,
    required this.name,
    required this.area,
    required this.tagline,
    required this.description,
    required this.vibeTag,
    required this.openingHours,
    required this.rating,
    required this.categories,
    required this.signatureDrinks,
    required this.mustTry,
    required this.addressHint,
    required this.badges,
    this.menu = const [],
    String fallbackPriceRange = '',
  }) : _fallbackPriceRange = fallbackPriceRange;

  final String id;
  final String name;
  final String area;
  final String tagline;
  final String description;
  final String vibeTag;
  final String openingHours;
  final double rating;
  final List<ShopCategory> categories;
  final List<String> signatureDrinks;
  final List<String> mustTry;
  final String addressHint;
  final List<String> badges;
  final List<CoffeeMenuItemModel> menu;

  /// Only used when the payload carries no priced menu items.
  final String _fallbackPriceRange;

  bool get isLateNight => categories.contains(ShopCategory.lateNight);
  bool get isWorkspaceFriendly =>
      categories.contains(ShopCategory.workspaceFriendly);

  int get startingPrice {
    if (menu.isEmpty) return 0;
    var low = menu.first.price;
    for (final item in menu) {
      if (item.price > 0 && item.price < low) low = item.price;
    }
    return low;
  }

  int get topPrice {
    if (menu.isEmpty) return 0;
    var high = menu.first.price;
    for (final item in menu) {
      if (item.price > high) high = item.price;
    }
    return high;
  }

  /// Price band derived from the live menu, e.g. `PKR 500 – 900`.
  String get priceRange {
    if (menu.isEmpty) {
      return _fallbackPriceRange.isEmpty
          ? 'Price on request'
          : _fallbackPriceRange;
    }
    final low = startingPrice;
    final high = topPrice;
    if (low <= 0 && high <= 0) return 'Price on request';
    if (low == high) return 'PKR ${formatPkr(low)}';
    return 'PKR ${formatPkr(low)} – ${formatPkr(high)}';
  }

  /// `1250` → `1,250`.
  static String formatPkr(int amount) {
    final digits = amount.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return '${amount < 0 ? '-' : ''}$buffer';
  }

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
        menu.any((item) => item.name.toLowerCase().contains(needle)) ||
        categories
            .any((category) => category.label.toLowerCase().contains(needle));
  }

  factory CoffeeShopModel.fromJson(Map<String, dynamic> json) {
    final name = _string(json['name']);
    final categories = _stringList(json['categories'])
        .map(ShopCategoryX.fromId)
        .whereType<ShopCategory>()
        .toList(growable: false);

    final menu = <CoffeeMenuItemModel>[];
    final rawMenu = json['menu'];
    if (rawMenu is List) {
      for (final entry in rawMenu) {
        if (entry is! Map) continue;
        final item = CoffeeMenuItemModel.fromJson(
          Map<String, dynamic>.from(entry),
        );
        if (item.name.isNotEmpty) menu.add(item);
      }
    }

    return CoffeeShopModel(
      id: _string(json['id']).isEmpty ? _slug(name) : _string(json['id']),
      name: name,
      area: _string(json['area']),
      tagline: _string(json['tagline']),
      description: _string(json['description']),
      vibeTag: _string(json['vibeTag'] ?? json['vibe']),
      openingHours: _string(json['openingHours'] ?? json['hours']),
      rating: _double(json['rating']),
      categories: categories.isEmpty
          ? const [ShopCategory.specialtyCoffee]
          : categories,
      signatureDrinks: _stringList(json['signatureDrinks']),
      mustTry: _stringList(json['mustTry']),
      addressHint: _string(json['addressHint'] ?? json['address']),
      badges: _stringList(json['badges']),
      menu: List.unmodifiable(menu),
      fallbackPriceRange: _string(json['priceRange']),
    );
  }

  static String _string(Object? value) => value?.toString().trim() ?? '';

  static double _double(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static List<String> _stringList(Object? value) {
    if (value is! List) return const [];
    return value
        .map((entry) => entry?.toString().trim() ?? '')
        .where((entry) => entry.isNotEmpty)
        .toList(growable: false);
  }

  static String _slug(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}
