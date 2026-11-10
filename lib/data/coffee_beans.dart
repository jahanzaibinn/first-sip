import '../models/coffee_bean_model.dart';
import '../models/milk_ratio_model.dart';

class CoffeeBeansData {
  const CoffeeBeansData._();

  static const List<CoffeeBeanModel> beans = [
    CoffeeBeanModel(
      species: BeanSpecies.arabica,
      tagline: 'The aromatic sipper',
      origin: 'Ethiopian highlands · grown across 70% of the world',
      altitude: '1,200 – 2,200 m',
      roastLevel: 'Light to medium roast',
      aroma: 'Fruity and floral — jasmine, berries, citrus peel',
      tasteSummary:
          'Smooth, balanced and gently sweet with a bright, tea-like clarity. '
          'Acidity reads as juiciness rather than sourness.',
      crema: 'Thin, pale-golden crema that settles quickly',
      antioxidantNote:
          'Rich in chlorogenic acids and cafestol — higher antioxidant load per gram than Robusta.',
      flavourNotes: ['Jasmine', 'Blueberry', 'Citrus', 'Honey', 'Almond'],
      bestFor: ['Pour over', 'Filter', 'Light flat whites'],
      funFact:
          'Arabica beans contain roughly half the caffeine of Robusta — that is why you can sip three '
          'and still sleep.',
      caffeineScore: 2,
      acidityScore: 5,
      sweetnessScore: 4,
      bitternessScore: 2,
      bodyScore: 2,
    ),
    CoffeeBeanModel(
      species: BeanSpecies.robusta,
      tagline: 'The espresso backbone',
      origin: 'Central and West Africa · now grown in Vietnam, India & Brazil',
      altitude: '0 – 800 m',
      roastLevel: 'Medium-dark to dark roast',
      aroma: 'Woody and earthy — cocoa nib, roasted malt, a whisper of smoke',
      tasteSummary:
          'Bold, bitter and full-bodied with a heavy mouthfeel. Built to punch through milk, '
          'sugar and ice.',
      crema: 'Thick, dark hazelnut crema that holds for minutes',
      antioxidantNote:
          'Very high in chlorogenic acid too, but its headline benefit is caffeine density and crema.',
      flavourNotes: ['Dark cocoa', 'Peanut', 'Molasses', 'Tobacco', 'Smoke'],
      bestFor: ['Espresso blends', 'Cold brew', 'Spanish lattes'],
      funFact:
          'Most Italian espresso blends are 20–30% Robusta purely for crema — Arabica alone rarely '
          'holds that golden dome.',
      caffeineScore: 5,
      acidityScore: 1,
      sweetnessScore: 2,
      bitternessScore: 5,
      bodyScore: 5,
    ),
  ];

  static const List<MilkRatioModel> milkRatios = [
    MilkRatioModel(
      name: 'Espresso',
      espressoPercent: 100,
      milkPercent: 0,
      description: 'A 25–30 ml shot. No milk, all origin character.',
      strengthLabel: 'Strongest',
    ),
    MilkRatioModel(
      name: 'Cortado',
      espressoPercent: 50,
      milkPercent: 50,
      description: 'Equal parts espresso and warm milk. Balanced, tiny cup.',
      strengthLabel: 'Strong',
    ),
    MilkRatioModel(
      name: 'Cappuccino',
      espressoPercent: 33,
      milkPercent: 67,
      description:
          'One-third espresso, one-third steamed milk, one-third foam.',
      strengthLabel: 'Medium',
    ),
    MilkRatioModel(
      name: 'Latte',
      espressoPercent: 20,
      milkPercent: 80,
      description: 'Mostly milk with a shot pulling through. Soft and sweet.',
      strengthLabel: 'Mild',
    ),
  ];
}
