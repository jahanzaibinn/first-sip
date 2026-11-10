import '../models/brew_option_model.dart';

class OrderOptions {
  const OrderOptions._();

  static const List<BrewOption> sizes = [
    BrewOption(id: 'Small', label: 'Small', detail: '8 oz'),
    BrewOption(id: 'Medium', label: 'Medium', detail: '12 oz'),
    BrewOption(id: 'Large', label: 'Large', detail: '16 oz'),
  ];

  static const List<BrewOption> bases = [
    BrewOption(
      id: 'espresso',
      label: 'Espresso Shot',
      detail: 'Single, 25–30 ml',
    ),
    BrewOption(
      id: 'double',
      label: 'Double Shot',
      detail: 'Two shots, 50–60 ml',
    ),
    BrewOption(
      id: 'cold_brew',
      label: 'Cold Brew',
      detail: '18-hour steep, served over ice',
    ),
    BrewOption(
      id: 'drip',
      label: 'Drip',
      detail: 'Filter batch brew',
    ),
  ];

  static const List<BrewOption> milks = [
    BrewOption(id: 'whole', label: 'Whole Milk', detail: 'Creamiest body'),
    BrewOption(id: 'skim', label: 'Skim Milk', detail: 'Lighter, still frothy'),
    BrewOption(id: 'oat', label: 'Oat Milk', detail: 'Nutty, barista-grade'),
    BrewOption(
        id: 'almond', label: 'Almond Milk', detail: 'Delicate and light'),
    BrewOption(
        id: 'water', label: 'Water Only', detail: 'Black coffee, no dairy'),
  ];

  static const List<BrewOption> sweetness = [
    BrewOption(id: 'none', label: 'Unsweetened', detail: '0% sugar'),
    BrewOption(id: 'half', label: 'Half-Sweet', detail: '50% sugar'),
    BrewOption(id: 'full', label: 'Full Sweet', detail: '100% sugar'),
  ];

  static const List<BrewOption> flavours = [
    BrewOption(id: 'none', label: 'None', detail: 'Keep it pure'),
    BrewOption(id: 'vanilla', label: 'Vanilla', detail: 'Soft and warm'),
    BrewOption(id: 'hazelnut', label: 'Hazelnut', detail: 'Nutty finish'),
    BrewOption(id: 'caramel', label: 'Caramel', detail: 'Burnt-sugar depth'),
    BrewOption(id: 'pistachio', label: 'Pistachio', detail: 'Roasted, buttery'),
  ];
}
