import '../models/coffee_shop_model.dart';

class ShopFilter {
  const ShopFilter({required this.id, required this.label});

  final String id;
  final String label;
}

class ShopDirectoryData {
  const ShopDirectoryData._();

  static const List<ShopFilter> filters = [
    ShopFilter(id: 'all', label: 'All Spots'),
    ShopFilter(id: 'specialty', label: 'Specialty Coffee'),
    ShopFilter(id: 'workspace', label: 'Workspace Friendly'),
    ShopFilter(id: 'late_night', label: 'Late Night'),
    ShopFilter(id: 'budget', label: 'Budget Friendly'),
  ];

  static const List<CoffeeShopModel> shops = [
    CoffeeShopModel(
      id: 'floc',
      name: 'FLOC',
      area: 'DHA Phase 5',
      tagline: 'For the Love of Coffee',
      description:
          'The address that turned Karachi onto single-origin coffee. Expect rotating Ethiopian '
          'and Colombian beans, hand-poured V60s and a bar team happy to talk you through tasting notes.',
      vibeTag: 'Quiet · Plant-filled · Laptop friendly',
      openingHours: '8:00 AM – 12:00 AM (daily)',
      priceRange: 'PKR 700 – 1,200',
      rating: 4.7,
      priceFrom: 700,
      priceTo: 1200,
      categories: [
        ShopCategory.specialtyCoffee,
        ShopCategory.workspaceFriendly
      ],
      signatureDrinks: [
        'V60 Pour Over',
        'Ethiopian Single Origin',
        'Flat White'
      ],
      mustTry: ['Ethiopian V60', 'Cardamom Bun', 'Iced Filter'],
      addressHint: 'Khayaban-e-Ittehad, DHA Phase 5',
      badges: ['Specialty Pour Over', 'Single Origin'],
    ),
    CoffeeShopModel(
      id: 'drop',
      name: 'Drop Coffee',
      area: 'Clifton',
      tagline: 'Minimalist specialty espresso',
      description:
          'A tiny, white-walled espresso bar obsessed with consistency. Premium Arabica, '
          'dialled-in flat whites and a short menu that never misses.',
      vibeTag: 'Minimal · Standing bar · Quick catch-up',
      openingHours: '9:00 AM – 1:00 AM (daily)',
      priceRange: 'PKR 800 – 1,300',
      rating: 4.6,
      priceFrom: 800,
      priceTo: 1300,
      categories: [ShopCategory.specialtyCoffee, ShopCategory.lateNight],
      signatureDrinks: ['Flat White', 'Cortado', 'Iced Latte'],
      mustTry: ['Flat White', 'Cortado', 'Cold Brew'],
      addressHint: 'Off Main Clifton Road, Clifton Block 4',
      badges: ['Premium Arabica', 'Espresso Bar'],
    ),
    CoffeeShopModel(
      id: 'routine',
      name: 'Routine Specialty Coffee',
      area: 'Shahbaz Commercial',
      tagline: 'High-end espresso, balanced syrups',
      description:
          'Karachi\'s precision shop. Routine pulls high-end specialty espresso and balances '
          'every syrup so a flavoured drink still tastes like coffee, not candy.',
      vibeTag: 'Polished · Date-night · Detail obsessed',
      openingHours: '8:30 AM – 12:30 AM (daily)',
      priceRange: 'PKR 850 – 1,400',
      rating: 4.6,
      priceFrom: 850,
      priceTo: 1400,
      categories: [
        ShopCategory.specialtyCoffee,
        ShopCategory.workspaceFriendly
      ],
      signatureDrinks: ['Spanish Latte', 'Pistachio Latte', 'Double Espresso'],
      mustTry: ['Pistachio Latte', 'Spanish Latte', 'Batch Brew'],
      addressHint: 'Shahbaz Commercial Area, DHA Phase 6',
      badges: ['Specialty Espresso', 'Balanced Syrups'],
    ),
    CoffeeShopModel(
      id: 'luna',
      name: 'Luna Coffee',
      area: 'DHA Phase 8',
      tagline: 'Karachi\'s 24-hour coffee hotspot',
      description:
          'Open around the clock with a custom bean roast selection — choose Light, Medium or Dark '
          'and the barista grinds to order. The default late-night study and shift-work stop.',
      vibeTag: 'Buzzing · 24/7 · Late-night study',
      openingHours: 'Open 24 hours, 7 days',
      priceRange: 'PKR 800 – 1,400',
      rating: 4.5,
      priceFrom: 800,
      priceTo: 1400,
      categories: [
        ShopCategory.specialtyCoffee,
        ShopCategory.lateNight,
        ShopCategory.workspaceFriendly,
      ],
      signatureDrinks: ['Custom Roast Latte', 'Cold Brew', 'Affogato'],
      mustTry: ['Dark roast custom latte', 'Affogato', 'Iced Americano'],
      addressHint: 'Main Ittehad Commercial, DHA Phase 8',
      badges: ['24/7 Spot', 'Custom Roast'],
    ),
    CoffeeShopModel(
      id: 'mazi',
      name: 'Mazi Specialty Coffee',
      area: 'North Nazimabad',
      tagline: 'North Karachi\'s specialty hub',
      description:
          'The shop that put North Karachi on the specialty map. Friendly, unpretentious and '
          'serious about brew ratios, with a menu built for first-timers and regulars alike.',
      vibeTag: 'Neighbourhood · Friendly · Family friendly',
      openingHours: '11:00 AM – 1:00 AM (daily)',
      priceRange: 'PKR 650 – 1,100',
      rating: 4.5,
      priceFrom: 650,
      priceTo: 1100,
      categories: [ShopCategory.specialtyCoffee, ShopCategory.budgetFriendly],
      signatureDrinks: ['Cappuccino', 'V60 Pour Over', 'Mocha'],
      mustTry: ['Cappuccino', 'Pour Over', 'Brownie'],
      addressHint: 'Block H, North Nazimabad',
      badges: ['North Karachi', 'Value Pours'],
    ),
    CoffeeShopModel(
      id: 'wagera',
      name: 'Coffee Wagera',
      area: 'Multiple Locations',
      tagline: 'Student and freelancer HQ',
      description:
          'Strong, affordable cold brews and long workbenches across the city. The most reliable '
          'place to camp with a laptop, a charger and a refill without hurting your wallet.',
      vibeTag: 'Casual · Group friendly · Plug points everywhere',
      openingHours: '11:00 AM – 2:00 AM (daily)',
      priceRange: 'PKR 500 – 900',
      rating: 4.3,
      priceFrom: 500,
      priceTo: 900,
      categories: [
        ShopCategory.workspaceFriendly,
        ShopCategory.budgetFriendly,
        ShopCategory.lateNight,
      ],
      signatureDrinks: ['Iced Cold Brew', 'Caramel Latte', 'Mocha'],
      mustTry: ['Cold Brew', 'Caramel Latte', 'Cheesecake'],
      addressHint: 'Branches in Clifton, Gulshan & Bahadurabad',
      badges: ['Budget Friendly', 'Work Benches'],
    ),
  ];

  static List<CoffeeShopModel> get featured => shops
      .where((shop) => shop.badges.isNotEmpty)
      .take(4)
      .toList(growable: false);
}
