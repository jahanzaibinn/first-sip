# Karachi Coffee Compass

A complete Flutter app that teaches you the beans, recommends a drink from a two-step
taste quiz, lets you build the exact phrase to say at the counter, and maps out six
Karachi coffee spots worth the drive.

Built with Flutter 3.x, GetX and Google Fonts. No image assets — every visual is drawn
from the palette, Material icons, gradients and reactive state.

## Feature tour

| Tab | What it does |
| --- | --- |
| **Home** | Time-aware greeting, hero CTA, three quick actions, horizontally scrolling "Spotlight in Karachi" rail, daily pour card, bean teaser. |
| **Beans** | Arabica vs Robusta toggle with origin, roast, aroma, taste meters and a fun fact, plus an expandable milk-to-espresso ratio breakdown (Espresso → Cortado → Cappuccino → Latte) and a caffeine comparison. |
| **Order** | Five chip groups (size/temperature, base, milk, sweetness, flavour) driving a pinned live order-phrase banner with a one-tap copy button, caffeine and calorie estimates. |
| **Spots** | Search plus filters (Specialty, Workspace, Late Night, Budget). Cards open a full profile; long-press opens a quick bottom sheet. |

The quiz lives on its own route: two questions (taste preference × energy goal) resolve
through a 16-entry matrix to one of 16 curated drinks, then show a taste profile,
caffeine/calorie indicators, the recommended order phrase with copy, and links into the
Order and Spots tabs.

## Getting started

```bash
flutter pub get
flutter run
```

Android, iOS and web runners are scaffolded, so you can also build directly:

```bash
flutter build apk
flutter build web --release
```

Requirements:

- Flutter **3.27 or newer** (the code uses `Color.withValues`, which replaced the
  deprecated `withOpacity`), Dart 3.6+.
- Network access on first launch: `google_fonts` fetches Poppins and Outfit at runtime and
  caches them. To ship fully offline, download the font files and register them under
  `flutter.fonts` instead.

## Architecture

```
lib/
├── main.dart                 # GetMaterialApp, theme, initial binding/route
├── bindings/                 # AppBinding, MainShellBinding, QuizBinding
├── routes/                   # AppRoutes + AppPages (shell, quiz, shop detail)
├── models/                   # CoffeeBeanModel, DrinkRecommendationModel,
│                             # CoffeeShopModel, BrewOption, QuizStep, MilkRatio
├── data/                     # Static content: beans, quiz, order options,
│                             # drink catalog + matrix, filter taxonomy
├── services/                 # CoffeeApiService (HTTP + JSON parsing)
├── controllers/              # QuizController, OrderBuilderController,
│                             # ShopDirectoryController, HomeController,
│                             # BeanGuideController, NavigationController
├── theme/                    # AppColors + AppTheme (Material 3)
├── widgets/                  # SoftCard, SelectableChip, meters, shop cards,
│                             # quick sheet, section header
├── utils/                    # Shop category icon/tint mapping
└── views/                    # MainShell (bottom nav) + the five screens
```

State flow is deliberately one-directional: views read reactive getters inside `Obx`,
controllers own the `Rx` state, and `data/` stays immutable `const` content.

### Live directory data

`ShopDirectoryController` no longer reads a hardcoded shop list. On `onInit` it
calls `CoffeeApiService.fetchShops()`, which GETs a JSON directory (by default
`data/coffee_spots.json` in this repository) and parses each entry with
`CoffeeShopModel.fromJson`.

The directory screen renders three states inside one `Obx`: pulsing skeleton
cards while loading, an error card with a **Retry** button, and the populated
list. `RefreshIndicator` calls `refresh()`, which keeps the visible list on a
failed refresh and reports the problem in a snackbar. PKR ranges are derived
from each shop's `menu` prices, and the detail screen lists those items, so
editing the payload changes both the card badge and the menu section.

Point the app at another endpoint with:

```bash
flutter run --dart-define=COFFEE_MENU_URL=https://your.api/coffee_spots.json
```

Payload shape: `{"updatedAt": "...", "shops": [{ ..., "menu": [{"name": "Flat White", "price": 750, "note": "..."}]}]}`.
A bare JSON array of shops is also accepted; `updatedAt` only powers the
"live prices" status line.

### Order phrase composition

`OrderBuilderController.orderPhrase` is a pure getter over five `Rx<BrewOption>` values,
so any chip tap rebuilds only the banner. The drink name is built as
`size + temperature + milk + core`, where the core depends on base + milk:

| Base | With milk | Black |
| --- | --- | --- |
| Espresso Shot | Cortado | Espresso |
| Double Shot | Latte | Doppio |
| Cold Brew | Cold Brew | Cold Brew |
| Drip | Café au Lait | Filter Coffee |

Sweetness + flavour then produce the tail:
"…with half-sweet Caramel, please." Cold brew forces iced, and `caffeineMg`/`calories`
scale with size.

### Palette

| Token | Hex |
| --- | --- |
| Cream (background) | `#FDFBF7` |
| Deep espresso | `#1E100A` |
| Caramel | `#C8963E` |
| Almond | `#F4ECE1` |
| Charcoal | `#222222` |
| Muted gray | `#7A726C` |

Supporting tones (crema, hazelnut, oat, mint, chili) live in `lib/theme/app_colors.dart`.

## Checks

```bash
flutter analyze
flutter test
```

`flutter analyze` is clean. The tests cover the exact counter phrase, black-coffee
naming, cold-brew temperature locking, size-scaled caffeine, reset behaviour, the
quiz state machine including result navigation, JSON parsing and PKR derivation,
HTTP error handling, and the directory controller's loading/error/filter state.
