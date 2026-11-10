import '../models/drink_recommendation_model.dart';

/// Curated drink catalog + the taste × energy resolution matrix for the quiz.
class DrinkCatalog {
  const DrinkCatalog._();

  static const Map<String, DrinkRecommendationModel> _drinks = {
    'doppio': DrinkRecommendationModel(
      id: 'doppio',
      name: 'Double Espresso',
      category: 'Espresso Bar',
      tagline: 'Two shots. Nothing to hide behind.',
      description:
          'A 50 ml double pulled short, so the sweetness of the crema survives the intensity.',
      whyItMatches:
          'You asked for bold and black with a real caffeine kick — this is the purest version of both.',
      orderPhrase:
          'I\'d like a double espresso in a small cup, no sugar, please.',
      flavourNotes: ['Dark chocolate', 'Toasted hazelnut', 'Brown sugar'],
      milkRatio: 'No milk',
      beanSuggestion: 'Dark-roast Robusta blend or a Brazilian Arabica',
      sweetness: 0.05,
      acidity: 0.35,
      bitterness: 0.9,
      body: 0.8,
      caffeineScore: 5,
      calories: 10,
    ),
    'cortado': DrinkRecommendationModel(
      id: 'cortado',
      name: 'Cortado',
      category: 'Espresso Bar',
      tagline: 'Equal parts espresso and silky milk.',
      description:
          'A 60 ml glass, half espresso, half lightly steamed milk. Small enough to keep the bite.',
      whyItMatches:
          'Bold and black at heart, but you want to sip slowly — the cortado keeps the espresso '
          'front and centre without the burn.',
      orderPhrase: 'I\'d like a cortado with whole milk, please.',
      flavourNotes: ['Milk chocolate', 'Almond', 'Caramel'],
      milkRatio: '50 / 50 espresso to milk',
      beanSuggestion: 'Medium-dark Arabica with a chocolate finish',
      sweetness: 0.35,
      acidity: 0.4,
      bitterness: 0.6,
      body: 0.65,
      caffeineScore: 4,
      calories: 90,
    ),
    'dark_mocha': DrinkRecommendationModel(
      id: 'dark_mocha',
      name: 'Dark Mocha',
      category: 'Milk & Chocolate',
      tagline: 'Espresso, bittersweet cocoa, steamed milk.',
      description:
          'Real 70% cocoa rather than sugar syrup, so the chocolate deepens the coffee instead of masking it.',
      whyItMatches:
          'You want bold flavour but a dessert-level treat — dark cocoa adds richness while the espresso '
          'stays loud.',
      orderPhrase:
          'I\'d like a medium dark mocha with half-sweet cocoa, please.',
      flavourNotes: ['Bitter cocoa', 'Espresso crema', 'Vanilla'],
      milkRatio: '20 / 80 espresso to milk + cocoa',
      beanSuggestion: 'Medium-dark Arabica',
      sweetness: 0.7,
      acidity: 0.25,
      bitterness: 0.65,
      body: 0.85,
      caffeineScore: 4,
      calories: 260,
    ),
    'v60': DrinkRecommendationModel(
      id: 'v60',
      name: 'V60 Pour Over',
      category: 'Filter Bar',
      tagline: 'The clearest cup of coffee you can order.',
      description:
          'A hand pour over a light roast single origin — floral, juicy and completely transparent.',
      whyItMatches:
          'Bold and black, but you want a gentle lift instead of a jolt. Filter coffee delivers clarity '
          'with a lighter caffeine curve.',
      orderPhrase:
          'I\'d like a V60 pour over with the light-roast single origin, please.',
      flavourNotes: ['Jasmine', 'Bergamot', 'Stone fruit'],
      milkRatio: 'No milk',
      beanSuggestion: 'Ethiopian or Kenyan light-roast Arabica',
      sweetness: 0.3,
      acidity: 0.75,
      bitterness: 0.25,
      body: 0.35,
      caffeineScore: 3,
      calories: 5,
    ),
    'spanish_latte': DrinkRecommendationModel(
      id: 'spanish_latte',
      name: 'Spanish Latte',
      category: 'Milk & Sweet',
      tagline: 'Espresso plus condensed milk. Pure velvet.',
      description:
          'Sweetened condensed milk folded into a double shot and topped with steamed milk — Karachi\'s '
          'most ordered indulgence.',
      whyItMatches:
          'Sweet and milky plus an intense caffeine goal. The condensed milk calms the espresso but the '
          'double shot still lands.',
      orderPhrase: 'I\'d like a medium Spanish latte, please.',
      flavourNotes: ['Caramelised milk', 'Vanilla', 'Cocoa'],
      milkRatio: '30 / 70 espresso to milk',
      beanSuggestion: 'Dark-roast Robusta blend for cut-through',
      sweetness: 0.85,
      acidity: 0.3,
      bitterness: 0.4,
      body: 0.8,
      caffeineScore: 4,
      calories: 250,
    ),
    'cappuccino': DrinkRecommendationModel(
      id: 'cappuccino',
      name: 'Cappuccino',
      category: 'Classic Milk',
      tagline: 'The 1:1:1 classic, done properly.',
      description:
          'One third espresso, one third steamed milk, one third foam — light enough for an afternoon, '
          'strong enough to count.',
      whyItMatches:
          'You like sweet and milky drinks but want a casual sipper rather than a sugar bomb. '
          'A cappuccino is balanced by design.',
      orderPhrase:
          'I\'d like a cappuccino with whole milk, no extra sugar, please.',
      flavourNotes: ['Milk chocolate', 'Baked bread', 'Hazelnut'],
      milkRatio: '33 / 67 espresso to milk',
      beanSuggestion: 'Medium Arabica',
      sweetness: 0.4,
      acidity: 0.4,
      bitterness: 0.55,
      body: 0.65,
      caffeineScore: 3,
      calories: 150,
    ),
    'caramel_macchiato': DrinkRecommendationModel(
      id: 'caramel_macchiato',
      name: 'Caramel Macchiato',
      category: 'Milk & Sweet',
      tagline: 'Vanilla base, espresso poured last, caramel on top.',
      description:
          'Layered so the espresso sits on vanilla-steamed milk, finished with a caramel drizzle.',
      whyItMatches:
          'A dessert replacement that still tastes like coffee. Sweet and milky with a caramel finish you '
          'can drag out over an hour.',
      orderPhrase:
          'I\'d like a medium caramel macchiato with half-sweet vanilla, please.',
      flavourNotes: ['Caramel', 'Vanilla bean', 'Roasted almond'],
      milkRatio: '25 / 75 espresso to milk',
      beanSuggestion: 'Medium-dark Arabica',
      sweetness: 0.9,
      acidity: 0.25,
      bitterness: 0.35,
      body: 0.75,
      caffeineScore: 3,
      calories: 280,
    ),
    'honey_oat_latte': DrinkRecommendationModel(
      id: 'honey_oat_latte',
      name: 'Honey Oat Latte',
      category: 'Milk & Sweet',
      tagline: 'Floral honey, nutty oat milk, light roast.',
      description:
          'A lighter latte that skips refined sugar — raw honey and barista oat milk let the coffee '
          'bloom instead of hiding it.',
      whyItMatches:
          'Sweet and milky, but you want the lighter, antioxidant-rich end of the menu.',
      orderPhrase:
          'I\'d like a medium honey oat latte, lightly sweetened, please.',
      flavourNotes: ['Wildflower honey', 'Oat', 'Apricot'],
      milkRatio: '25 / 75 espresso to oat milk',
      beanSuggestion: 'Light-roast Arabica with fruit notes',
      sweetness: 0.6,
      acidity: 0.5,
      bitterness: 0.25,
      body: 0.6,
      caffeineScore: 2,
      calories: 180,
    ),
    'flat_white': DrinkRecommendationModel(
      id: 'flat_white',
      name: 'Flat White',
      category: 'Classic Milk',
      tagline: 'Ristretto shots under a thin layer of microfoam.',
      description:
          'Stronger and silkier than a latte — a double ristretto with barely-there foam so nothing '
          'mutes the coffee.',
      whyItMatches:
          'Smooth and creamy with a serious caffeine need. Flat white keeps the texture without '
          'diluting the shot.',
      orderPhrase: 'I\'d like a medium flat white with whole milk, please.',
      flavourNotes: ['Toffee', 'Milk chocolate', 'Roasted nuts'],
      milkRatio: '40 / 60 espresso to milk',
      beanSuggestion: 'Medium-dark Arabica',
      sweetness: 0.35,
      acidity: 0.35,
      bitterness: 0.6,
      body: 0.8,
      caffeineScore: 4,
      calories: 160,
    ),
    'latte': DrinkRecommendationModel(
      id: 'latte',
      name: 'Café Latte',
      category: 'Classic Milk',
      tagline: 'The everyday velvet cup.',
      description:
          'A double shot under a generous pour of steamed milk. Soft, sweet and endlessly drinkable.',
      whyItMatches:
          'Smooth and creamy with a casual caffeine goal — a latte is the most forgiving, comforting '
          'version of that brief.',
      orderPhrase: 'I\'d like a medium latte with whole milk, please.',
      flavourNotes: ['Milk chocolate', 'Caramel', 'Baked milk'],
      milkRatio: '20 / 80 espresso to milk',
      beanSuggestion: 'Medium Arabica blend',
      sweetness: 0.45,
      acidity: 0.3,
      bitterness: 0.4,
      body: 0.65,
      caffeineScore: 3,
      calories: 190,
    ),
    'pistachio_latte': DrinkRecommendationModel(
      id: 'pistachio_latte',
      name: 'Pistachio Latte',
      category: 'Milk & Sweet',
      tagline: 'Roasted pistachio cream over espresso.',
      description:
          'A pistachio-forward latte with a toasted, buttery finish — dessert in a cup without '
          'crossing into candy territory.',
      whyItMatches:
          'Smooth and creamy plus a sweet treat goal. Pistachio adds richness and a nutty, roasted edge '
          'that keeps the espresso visible.',
      orderPhrase:
          'I\'d like a medium iced pistachio latte, half-sweet, please.',
      flavourNotes: ['Roasted pistachio', 'Cream', 'Vanilla'],
      milkRatio: '25 / 75 espresso to milk',
      beanSuggestion: 'Medium-dark Arabica',
      sweetness: 0.8,
      acidity: 0.25,
      bitterness: 0.35,
      body: 0.85,
      caffeineScore: 3,
      calories: 290,
    ),
    'oat_cortado': DrinkRecommendationModel(
      id: 'oat_cortado',
      name: 'Oat Milk Cortado',
      category: 'Espresso Bar',
      tagline: 'Small, silky and naturally sweet.',
      description:
          'A 50/50 cortado made with barista oat milk — lighter on the stomach, still big on texture.',
      whyItMatches:
          'Smooth and creamy, but a light caffeine goal. A small cortado gives you the texture minus the '
          'double-shot hit.',
      orderPhrase: 'I\'d like a cortado with oat milk, please.',
      flavourNotes: ['Oat', 'Almond', 'Cocoa'],
      milkRatio: '50 / 50 espresso to oat milk',
      beanSuggestion: 'Medium Arabica with a caramel finish',
      sweetness: 0.4,
      acidity: 0.45,
      bitterness: 0.5,
      body: 0.6,
      caffeineScore: 2,
      calories: 100,
    ),
    'iced_cold_brew': DrinkRecommendationModel(
      id: 'iced_cold_brew',
      name: 'Iced Cold Brew',
      category: 'Cold Bar',
      tagline: 'Eighteen hours of slow, cold extraction.',
      description:
          'Coarse-ground beans steeped cold for 18 hours — low acidity, natural sweetness and a lot '
          'of caffeine.',
      whyItMatches:
          'Chilled and iced with an intense energy goal. Cold brew extracts more caffeine per millilitre '
          'and goes down dangerously easily.',
      orderPhrase: 'I\'d like a large iced cold brew, no milk, please.',
      flavourNotes: ['Dark chocolate', 'Molasses', 'Fig'],
      milkRatio: 'No milk',
      beanSuggestion: 'Dark-roast Robusta blend',
      sweetness: 0.25,
      acidity: 0.3,
      bitterness: 0.7,
      body: 0.7,
      caffeineScore: 5,
      calories: 15,
    ),
    'iced_americano': DrinkRecommendationModel(
      id: 'iced_americano',
      name: 'Iced Americano',
      category: 'Cold Bar',
      tagline: 'Two shots, cold water, ice.',
      description:
          'The cleanest iced coffee order there is — espresso over water and ice, no sugar, no dairy.',
      whyItMatches:
          'Chilled and iced but easy does it. An iced Americano keeps the caffeine moderate and the '
          'drink refreshing.',
      orderPhrase: 'I\'d like a medium iced americano, please.',
      flavourNotes: ['Citrus peel', 'Dark chocolate', 'Roasted almond'],
      milkRatio: 'No milk',
      beanSuggestion: 'Medium-dark Arabica',
      sweetness: 0.1,
      acidity: 0.55,
      bitterness: 0.7,
      body: 0.4,
      caffeineScore: 4,
      calories: 15,
    ),
    'iced_spanish_latte': DrinkRecommendationModel(
      id: 'iced_spanish_latte',
      name: 'Iced Spanish Latte',
      category: 'Cold Bar',
      tagline: 'Condensed milk over ice, espresso on top.',
      description:
          'A chilled Spanish latte with the espresso poured last so it stripes through the sweet milk.',
      whyItMatches:
          'Iced and sweet-toothed. Condensed milk makes it a drinkable dessert, while a double shot keeps '
          'it from becoming a milkshake.',
      orderPhrase: 'I\'d like a large iced Spanish latte, half-sweet, please.',
      flavourNotes: ['Condensed milk', 'Caramel', 'Vanilla'],
      milkRatio: '30 / 70 espresso to milk',
      beanSuggestion: 'Dark-roast Robusta blend',
      sweetness: 0.9,
      acidity: 0.25,
      bitterness: 0.4,
      body: 0.75,
      caffeineScore: 4,
      calories: 260,
    ),
    'cold_brew_tonic': DrinkRecommendationModel(
      id: 'cold_brew_tonic',
      name: 'Cold Brew Tonic',
      category: 'Cold Bar',
      tagline: 'Cold brew, tonic water, orange peel.',
      description:
          'A sparkling, low-sugar coffee cooler — effervescent tonic lifts the fruit notes in a light '
          'cold brew.',
      whyItMatches:
          'Chilled and iced with a light, antioxidant-friendly goal. Cold brew tonic is refreshing and '
          'barely sweet.',
      orderPhrase:
          'I\'d like a cold brew tonic with a twist of orange, please.',
      flavourNotes: ['Orange peel', 'Bergamot', 'Dark cherry'],
      milkRatio: 'No milk',
      beanSuggestion: 'Light-roast Ethiopian cold brew',
      sweetness: 0.2,
      acidity: 0.7,
      bitterness: 0.35,
      body: 0.3,
      caffeineScore: 3,
      calories: 60,
    ),
  };

  static const Map<String, String> _matrix = {
    'bold_black:intense': 'doppio',
    'bold_black:casual': 'cortado',
    'bold_black:dessert': 'dark_mocha',
    'bold_black:light': 'v60',
    'sweet_milky:intense': 'spanish_latte',
    'sweet_milky:casual': 'cappuccino',
    'sweet_milky:dessert': 'caramel_macchiato',
    'sweet_milky:light': 'honey_oat_latte',
    'smooth_creamy:intense': 'flat_white',
    'smooth_creamy:casual': 'latte',
    'smooth_creamy:dessert': 'pistachio_latte',
    'smooth_creamy:light': 'oat_cortado',
    'chilled_iced:intense': 'iced_cold_brew',
    'chilled_iced:casual': 'iced_americano',
    'chilled_iced:dessert': 'iced_spanish_latte',
    'chilled_iced:light': 'cold_brew_tonic',
  };

  static DrinkRecommendationModel resolve({
    required String taste,
    required String energy,
  }) {
    final id = _matrix['$taste:$energy'] ?? 'latte';
    return _drinks[id]!;
  }

  static List<DrinkRecommendationModel> get all =>
      _drinks.values.toList(growable: false);
}
