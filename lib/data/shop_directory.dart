import '../models/coffee_shop_model.dart';

class ShopFilter {
  const ShopFilter({required this.id, required this.label});

  final String id;
  final String label;
}

/// Filter definitions for the directory. The outlets themselves now come from
/// [CoffeeApiService]; only the taxonomy lives in the app.
class ShopDirectoryData {
  const ShopDirectoryData._();

  static const List<ShopFilter> filters = [
    ShopFilter(id: 'all', label: 'All Spots'),
    ShopFilter(id: 'specialty', label: 'Specialty Coffee'),
    ShopFilter(id: 'workspace', label: 'Workspace Friendly'),
    ShopFilter(id: 'late_night', label: 'Late Night'),
    ShopFilter(id: 'budget', label: 'Budget Friendly'),
  ];

  /// Fallback labels used if the remote payload omits categories.
  static const List<ShopCategory> defaultCategories = [
    ShopCategory.specialtyCoffee,
  ];
}
