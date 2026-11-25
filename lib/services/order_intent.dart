import '../models/coffee_shop_model.dart';

/// Temperature preference found in a spoken request.
enum CoffeeTemperature { hot, iced }

/// Milk preference found in a spoken request.
enum MilkChoice { whole, skim, oat, almond, none }

/// Sweetness preference found in a spoken request.
enum Sweetness { none, half, full }

/// Everything the parser understood from an Urdu, roman-Urdu or English
/// sentence. Every field is nullable so "I just want coffee" stays valid.
class OrderIntent {
  const OrderIntent({
    this.temperature,
    this.milk,
    this.sweetness,
    this.flavour,
    this.drink,
    this.size,
    this.maxPrice,
    this.strong,
    this.signals = const <String>[],
  });

  final CoffeeTemperature? temperature;
  final MilkChoice? milk;
  final Sweetness? sweetness;

  /// `caramel`, `vanilla`, `hazelnut`, `pistachio` or `mocha`.
  final String? flavour;

  /// Explicit drink name such as `Latte` or `Cold Brew`, when one was said.
  final String? drink;
  final String? size;
  final int? maxPrice;
  final bool? strong;

  /// Short English labels for the phrases that matched, shown as chips.
  final List<String> signals;

  bool get isEmpty => signals.isEmpty;
}

/// A concrete order the user can read out at the counter.
class OrderSuggestion {
  const OrderSuggestion({
    required this.drinkName,
    required this.englishPhrase,
    required this.urduPhrase,
    required this.reason,
    this.signals = const <String>[],
    this.menuItem,
    this.shopName,
  });

  final String drinkName;
  final String englishPhrase;
  final String urduPhrase;
  final String reason;
  final List<String> signals;

  /// The matching row from the shop's live menu, when there is one.
  final CoffeeMenuItemModel? menuItem;
  final String? shopName;

  int? get pricePkr => menuItem?.price;
}

/// Rule-based understanding of Urdu / roman-Urdu / English coffee orders.
///
/// Runs fully on-device: no API key, no network round trip.
class OrderIntentParser {
  const OrderIntentParser();

  static const List<String> _icedWords = [
    'ٹھنڈا', 'ٹھنڈی', 'ٹھنڈے', 'آئس', 'برف', 'کولڈ',
    'thanda', 'thandi', 'thande', 'ice', 'iced', 'cold', 'chilled', 'frappe',
  ];

  static const List<String> _hotWords = [
    'گرم', 'گرمی', 'گرما', 'hot', 'warm', 'garma',
  ];

  static const List<String> _noMilkWords = [
    'بغیر دودھ', 'دودھ کے بغیر', 'دودھ نہیں', 'بلیک', 'کالی',
    'black', 'no milk', 'without milk', 'dairy free', 'dairy-free',
  ];

  static const List<String> _oatWords = ['اوٹ', 'اوٹس', 'oat', 'oats', 'جئی'];
  static const List<String> _almondWords = ['بادام', 'almond'];
  static const List<String> _skimWords = ['سکم', 'skim', 'low fat', 'کم چربی'];
  static const List<String> _milkWords = ['دودھ', 'ملک', 'milk', 'doodh'];

  static const List<String> _noSugarWords = [
    'بغیر چینی', 'بغیر شکر', 'چینی کے بغیر', 'شکر کے بغیر', 'شوگر فری',
    'no sugar', 'sugar free', 'sugar-free', 'unsweetened', 'without sugar',
  ];
  static const List<String> _lessSugarWords = [
    'کم میٹھا', 'کم میٹھی', 'کم چینی', 'کم شکر', 'ہلکی میٹھی', 'ہلکا میٹھا',
    'half sweet', 'half-sweet', 'less sweet', 'less sugar', 'kam meetha',
    'کم میٹھاس',
  ];
  static const List<String> _moreSugarWords = [
    'زیادہ میٹھا', 'زیادہ میٹھی', 'زیادہ چینی', 'زیادہ شکر', 'فل میٹھا',
    'extra sweet', 'full sweet', 'more sugar', 'extra sugar', 'zyada meetha',
  ];

  static const Map<String, List<String>> _flavourWords = {
    'caramel': ['کرامیل', 'کرامل', 'caramel', 'karamel'],
    'vanilla': ['ونیلا', 'وینیلا', 'vanilla'],
    'hazelnut': ['ہیزلنٹ', 'ہزل نٹ', 'hazelnut'],
    'pistachio': ['پستہ', 'پستا', 'pistachio', 'pista'],
    'mocha': ['موکا', 'چاکلیٹ', 'mocha', 'chocolate'],
  };

  static const Map<String, List<String>> _drinkWords = {
    'Cold Brew': ['کولڈ بریو', 'کولڈبریو', 'cold brew', 'coldbrew'],
    'Pour Over': ['پور اوور', 'pour over', 'v60', 'پورؤور'],
    'Filter Coffee': ['فلٹر کافی', 'فلٹر', 'filter', 'drip', 'batch brew'],
    'Cappuccino': ['کیپوچینو', 'کپوچینو', 'cappuccino', 'capuccino'],
    'Flat White': ['فلیٹ وائٹ', 'flat white'],
    'Cortado': ['کارٹاڈو', 'cortado'],
    'Espresso': ['ایسپریسو', 'ایسپریسو شاٹ', 'espresso', 'شاٹ'],
    'Mocha': ['موکا', 'mocha'],
    'Latte': ['لیٹے', 'لیٹی', 'latte', 'لیٹ'],
  };

  static const Map<String, List<String>> _sizeWords = {
    'Small': ['چھوٹا', 'چھوٹی', 'small', 'chota', 'choti'],
    'Medium': ['میڈیم', 'درمیانہ', 'درمیانی', 'medium', 'mediam'],
    'Large': ['بڑا', 'بڑی', 'large', 'bara', 'bari'],
  };

  static const List<String> _budgetWords = [
    'سستا', 'سستی', 'کم پیسے', 'بجٹ', 'بجٹ میں',
    'budget', 'cheap', 'affordable', 'under', 'sasta', 'sasti',
  ];

  static const List<String> _strongWords = [
    'تیز', 'کڑک', 'اسٹرانگ', 'سٹرانگ',
    'strong', 'double', 'extra shot', 'stronger',
  ];

  OrderIntent parse(String transcript) {
    final text = normalise(transcript);
    final signals = <String>[];

    CoffeeTemperature? temperature;
    if (_has(text, _icedWords)) {
      temperature = CoffeeTemperature.iced;
      signals.add('cold');
    } else if (_has(text, _hotWords)) {
      temperature = CoffeeTemperature.hot;
      signals.add('hot');
    }

    MilkChoice? milk;
    if (_has(text, _noMilkWords)) {
      milk = MilkChoice.none;
      signals.add('no milk');
    } else if (_has(text, _oatWords)) {
      milk = MilkChoice.oat;
      signals.add('oat milk');
    } else if (_has(text, _almondWords)) {
      milk = MilkChoice.almond;
      signals.add('almond milk');
    } else if (_has(text, _skimWords)) {
      milk = MilkChoice.skim;
      signals.add('skim milk');
    } else if (_has(text, _milkWords)) {
      milk = MilkChoice.whole;
      signals.add('milk');
    }

    Sweetness? sweetness;
    if (_has(text, _noSugarWords)) {
      sweetness = Sweetness.none;
      signals.add('no sugar');
    } else if (_has(text, _lessSugarWords)) {
      sweetness = Sweetness.half;
      signals.add('less sugar');
    } else if (_has(text, _moreSugarWords)) {
      sweetness = Sweetness.full;
      signals.add('extra sugar');
    }

    String? flavour;
    for (final entry in _flavourWords.entries) {
      if (_has(text, entry.value)) {
        flavour = entry.key;
        signals.add('${_label(entry.key)} flavour');
        break;
      }
    }

    String? drink;
    for (final entry in _drinkWords.entries) {
      if (_has(text, entry.value)) {
        drink = entry.key;
        break;
      }
    }

    String? size;
    for (final entry in _sizeWords.entries) {
      if (_has(text, entry.value)) {
        size = entry.key;
        break;
      }
    }

    bool? strong;
    if (_has(text, _strongWords)) {
      strong = true;
      signals.add('strong');
    }

    int? maxPrice;
    if (_has(text, _budgetWords)) {
      final digits = RegExp(r'\d{2,5}').firstMatch(text);
      maxPrice = digits == null ? 900 : int.tryParse(digits.group(0)!);
      signals.add(maxPrice == null ? 'budget' : 'under PKR $maxPrice');
    }

    return OrderIntent(
      temperature: temperature,
      milk: milk,
      sweetness: sweetness,
      flavour: flavour,
      drink: drink,
      size: size,
      maxPrice: maxPrice,
      strong: strong,
      signals: List.unmodifiable(signals),
    );
  }

  /// Lower-cases, strips Urdu diacritics and folds Arabic letter variants so a
  /// phrase typed on one keyboard matches one spoken or typed on another.
  static String normalise(String input) {
    var text = input.toLowerCase();
    text = text.replaceAll(RegExp(r'[\u064B-\u0652\u0670\u0640]'), '');
    const folds = {
      'ي': 'ی',
      'ك': 'ک',
      'ة': 'ہ',
      'أ': 'ا',
      'إ': 'ا',
      'آ': 'ا',
      'ؤ': 'و',
      'ئ': 'ی',
    };
    folds.forEach((from, to) => text = text.replaceAll(from, to));
    text = text.replaceAll(RegExp(r'[^\w\u0600-\u06FF\s]'), ' ');
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static bool _has(String text, List<String> words) =>
      words.any((word) => text.contains(normalise(word)));

  /// `caramel` → `Caramel`, for labels and the counter phrase.
  static String _label(String flavour) =>
      flavour.isEmpty ? flavour : flavour[0].toUpperCase() + flavour.substring(1);
}

/// Turns parsed intent into a concrete order, and matches it against a shop's
/// live menu when the screen was opened from a shop.
class OrderSuggestions {
  const OrderSuggestions._();

  static const Map<String, String> _urduDrinks = {
    'Latte': 'لیٹے',
    'Mocha': 'موکا',
    'Cappuccino': 'کیپوچینو',
    'Cold Brew': 'کولڈ بریو',
    'Pour Over': 'پور اوور',
    'Filter Coffee': 'فلٹر کافی',
    'Espresso': 'ایسپریسو',
    'Black Coffee': 'بلیک کافی',
    'Double Espresso': 'ڈبل ایسپریسو',
    'Flat White': 'فلیٹ وائٹ',
    'Cortado': 'کارٹاڈو',
  };

  static OrderSuggestion suggest(String transcript, {CoffeeShopModel? shop}) {
    const parser = OrderIntentParser();
    final intent = parser.parse(transcript);

    final core = intent.drink ?? _defaultDrink(intent);
    final temperature = intent.temperature ??
        (core == 'Cold Brew' ? CoffeeTemperature.iced : null);
    final milkName = _milkLabel(intent.milk);
    final size = intent.size ?? 'Medium';

    final composed = <String>[
      size,
      if (temperature == CoffeeTemperature.iced) 'Iced',
      if (temperature == CoffeeTemperature.hot) 'Hot',
      if (milkName != null) milkName,
      core,
    ].join(' ');

    final match = _bestMenuMatch(shop, intent, core, milkName, temperature);
    final name = match?.name ?? composed;

    final flavour = intent.flavour;
    final flavourInName =
        flavour != null && name.toLowerCase().contains(flavour.toLowerCase());
    final flavourClause = flavour == null || flavourInName
        ? null
        : OrderIntentParser._label(flavour);

    return OrderSuggestion(
      drinkName: name,
      englishPhrase: counterPhrase(
        name,
        sweetness: intent.sweetness,
        flavour: flavourClause,
      ),
      urduPhrase: _urduOrder(
        intent,
        core: core,
        size: size,
        temperature: temperature,
      ),
      reason: _reason(intent, match: match, shop: shop),
      signals: intent.signals,
      menuItem: match,
      shopName: shop?.name,
    );
  }

  /// The sentence to say at the counter, e.g.
  /// `I'd like a Medium Iced Oat Milk Latte with half-sweet Caramel, please.`
  static String counterPhrase(
    String drinkName, {
    Sweetness? sweetness,
    String? flavour,
  }) {
    final hasFlavour = flavour != null && flavour.isNotEmpty;

    final hasSweetness = sweetness != null && sweetness != Sweetness.none;

    if (!hasFlavour && !hasSweetness) {
      return 'I\'d like a $drinkName, please.';
    }
    if (hasFlavour && !hasSweetness) {
      return 'I\'d like a $drinkName with $flavour, please.';
    }
    if (!hasFlavour) {
      final word = sweetness == Sweetness.half ? 'half sweetness' : 'full sweetness';
      return 'I\'d like a $drinkName with $word, please.';
    }
    final sweetWord = sweetness == Sweetness.half ? 'half-sweet' : 'fully sweet';
    return 'I\'d like a $drinkName with $sweetWord $flavour, please.';
  }

  static String _defaultDrink(OrderIntent intent) {
    if (intent.flavour == 'mocha') return 'Mocha';
    if (intent.milk == MilkChoice.none) {
      return intent.strong == true ? 'Double Espresso' : 'Black Coffee';
    }
    return 'Latte';
  }

  static String? _milkLabel(MilkChoice? milk) => switch (milk) {
        MilkChoice.oat => 'Oat Milk',
        MilkChoice.almond => 'Almond Milk',
        MilkChoice.skim => 'Skim Milk',
        MilkChoice.whole => 'Whole Milk',
        MilkChoice.none || null => null,
      };

  static String _urduOrder(
    OrderIntent intent, {
    required String core,
    required String size,
    required CoffeeTemperature? temperature,
  }) {
    final buffer = StringBuffer('مجھے ایک ');
    buffer.write('${_urduSize(size)} ');
    if (temperature == CoffeeTemperature.iced) buffer.write('آئس ');
    if (temperature == CoffeeTemperature.hot) buffer.write('گرم ');
    switch (intent.milk) {
      case MilkChoice.oat:
        buffer.write('اوٹ دودھ ');
      case MilkChoice.almond:
        buffer.write('بادام دودھ ');
      case MilkChoice.skim:
        buffer.write('سکم دودھ ');
      case MilkChoice.whole:
        buffer.write('دودھ ');
      case MilkChoice.none:
      case null:
        break;
    }
    buffer.write(_urduDrinks[core] ?? 'کافی');

    final extras = <String>[
      if (intent.sweetness != null) _urduSweetness(intent.sweetness!),
      if (intent.flavour != null)
        '${_urduFlavour(intent.flavour!)} کے ساتھ',
    ];
    if (extras.isNotEmpty) buffer.write('، ${extras.join(' ')}');
    buffer.write(' چاہیے۔');
    return buffer.toString();
  }

  static String _urduSize(String size) => switch (size) {
        'Small' => 'چھوٹا',
        'Large' => 'بڑا',
        _ => 'میڈیم',
      };

  static String _urduSweetness(Sweetness sweetness) => switch (sweetness) {
        Sweetness.none => 'بغیر چینی',
        Sweetness.half => 'ہلکی میٹھی',
        Sweetness.full => 'زیادہ میٹھی',
      };

  static String _urduFlavour(String flavour) => switch (flavour) {
        'caramel' => 'کرامیل',
        'vanilla' => 'ونیلا',
        'hazelnut' => 'ہیزلنٹ',
        'pistachio' => 'پستہ',
        'mocha' => 'چاکلیٹ',
        _ => flavour,
      };

  static CoffeeMenuItemModel? _bestMenuMatch(
    CoffeeShopModel? shop,
    OrderIntent intent,
    String core,
    String? milkName,
    CoffeeTemperature? temperature,
  ) {
    if (shop == null || shop.menu.isEmpty) return null;

    CoffeeMenuItemModel? best;
    var bestScore = 0;

    for (final item in shop.menu) {
      final name = item.name.toLowerCase();
      var relevance = 0;
      var overspend = 0;

      if (name.contains(core.toLowerCase())) relevance += 5;
      if (intent.flavour != null && name.contains(intent.flavour!)) {
        relevance += 4;
      }
      if (temperature == CoffeeTemperature.iced && name.contains('iced')) {
        relevance += 2;
      }
      if (temperature == CoffeeTemperature.iced && name.contains('cold')) {
        relevance += 1;
      }
      if (temperature == CoffeeTemperature.hot &&
          !name.contains('iced') &&
          !name.contains('cold')) {
        relevance += 1;
      }
      if (milkName != null &&
          name.contains(milkName.split(' ').first.toLowerCase())) {
        relevance += 2;
      }
      if (intent.maxPrice != null && item.price > intent.maxPrice!) {
        overspend = 5;
      }

      // A cheap price alone is not a recommendation, so only a relevant drink
      // that also fits the budget can win.
      final score = relevance - overspend;
      if (relevance >= 3 && score >= 3 && score > bestScore) {
        bestScore = score;
        best = item;
      }
    }

    return bestScore >= 3 ? best : null;
  }

  static String _reason(
    OrderIntent intent, {
    required CoffeeMenuItemModel? match,
    required CoffeeShopModel? shop,
  }) {
    final wants = <String?>[
      if (intent.temperature == CoffeeTemperature.iced) 'something cold',
      if (intent.temperature == CoffeeTemperature.hot) 'something hot',
      switch (intent.milk) {
        MilkChoice.oat => 'oat milk',
        MilkChoice.almond => 'almond milk',
        MilkChoice.skim => 'skim milk',
        MilkChoice.whole => 'regular milk',
        MilkChoice.none => 'no milk',
        null => null,
      },
      switch (intent.sweetness) {
        Sweetness.none => 'no sugar',
        Sweetness.half => 'less sugar',
        Sweetness.full => 'extra sugar',
        null => null,
      },
      if (intent.flavour != null && intent.flavour != 'mocha')
        '${OrderIntentParser._label(intent.flavour!)} flavour',
      if (intent.strong == true) 'a strong cup',
      if (intent.maxPrice != null) 'under PKR ${CoffeeShopModel.formatPkr(intent.maxPrice!)}',
    ].whereType<String>().toList(growable: false);

    if (wants.isEmpty) {
      return shop == null
          ? 'No clear preference in there, so here is the safest order to start with.'
          : 'No clear preference in there, so here is ${shop.name}\'s strongest order.';
    }

    final joined = wants.length == 1
        ? wants.first
        : '${wants.take(wants.length - 1).join(', ')} and ${wants.last}';
    final menuNote = match == null
        ? ''
        : ' It is on ${shop?.name ?? 'the'}\'s live menu.';
    return 'You asked for $joined.$menuNote';
  }
}
