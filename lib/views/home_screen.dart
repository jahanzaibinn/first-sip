import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/app_section_header.dart';
import '../widgets/shop_cards.dart';
import '../widgets/soft_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Reveal(child: _HomeHeader()),
            const SizedBox(height: 20),
            const _Reveal(child: _HeroBanner()),
            const SizedBox(height: 22),
            const _Reveal(child: _QuickActions()),
            const SizedBox(height: 26),
            AppSectionHeader(
              eyebrow: 'Curated by locals',
              title: 'Spotlight in Karachi',
              actionLabel: 'See all',
              onAction: () => controller.openTab(3),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 224,
              child: Obx(() {
                final spotlight = controller.spotlight;
                if (spotlight.isEmpty) {
                  return _SpotlightPlaceholder(
                    isLoading: controller.directory.isLoading.value,
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: spotlight.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final shop = spotlight[index];
                    return SpotlightShopCard(
                      shop: shop,
                      onTap: () => controller.openShop(shop),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 26),
            const _Reveal(child: _DailyPourCard()),
            const SizedBox(height: 16),
            const _Reveal(child: _BeanTeaser()),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends GetView<HomeController> {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.caramel, AppColors.caramelDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.explore_rounded,
              color: AppColors.espresso,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${controller.greeting}, Karachi',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 1),
                Text(
                  "Let's find your next cup",
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => controller.openTab(3),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.almond,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.crema),
              ),
              child: const Icon(
                Icons.place_outlined,
                size: 19,
                color: AppColors.espresso,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends GetView<HomeController> {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.espresso, AppColors.espressoSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.24),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -46,
            top: -58,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.caramel.withValues(alpha: 0.16),
              ),
            ),
          ),
          Positioned(
            right: 26,
            bottom: -34,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.caramel.withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            right: 22,
            top: 26,
            child: Icon(
              Icons.local_cafe_rounded,
              size: 56,
              color: AppColors.caramel.withValues(alpha: 0.30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.caramel,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'KARACHI COFFEE COMPASS',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.caramel,
                        letterSpacing: 1.5,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Find your\nperfect cup.',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.cream,
                    fontSize: 33,
                    height: 1.06,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Learn the beans, order like a regular, and find the spots '
                  'worth crossing the city for.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.72),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: controller.startQuiz,
                        icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                        label: const Text('Find my coffee match'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => controller.openTab(2),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide(
                            color: AppColors.cream.withValues(alpha: 0.25),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          size: 20,
                          color: AppColors.cream,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends GetView<HomeController> {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final spotCount = controller.directory.shops.length;
      final actions = [
        (Icons.menu_book_rounded, 'Learn beans', 'Arabica vs Robusta', 1),
        (Icons.receipt_long_rounded, 'Order sheet', 'Say it right', 2),
        (
          Icons.place_rounded,
          'Spot finder',
          spotCount == 0 ? 'Live guide' : '$spotCount local spots',
          3,
        ),
      ];

      return Row(
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: SoftCard(
                color: AppColors.cream,
                borderRadius: 20,
                padding: const EdgeInsets.all(13),
                onTap: () => controller.openTab(actions[i].$4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.almond,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        actions[i].$1,
                        size: 17,
                        color: AppColors.caramelDeep,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      actions[i].$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 12.5,
                            color: AppColors.espresso,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      actions[i].$3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    });
  }
}

class _SpotlightPlaceholder extends StatelessWidget {
  const _SpotlightPlaceholder({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 266,
      child: SoftCard(
        color: AppColors.cream,
        borderRadius: 26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.almond,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isLoading ? Icons.cloud_sync_rounded : Icons.cloud_off_rounded,
                size: 19,
                color: AppColors.caramelDeep,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              isLoading ? 'Fetching Karachi spots…' : 'Spots are offline',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 5),
            Text(
              isLoading
                  ? 'Pulling live menus and prices from the bar.'
                  : 'Open the Spots tab to retry the live directory.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyPourCard extends GetView<HomeController> {
  const _DailyPourCard();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SoftCard(
        color: AppColors.espresso,
        padding: const EdgeInsets.all(18),
        showShadow: false,
        onTap: () => controller.openTab(2),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.cream.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.local_cafe_rounded,
                color: AppColors.caramel,
                size: 23,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TODAY'S POUR",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.caramel,
                          letterSpacing: 1.3,
                          fontSize: 10,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    controller.dailyPour.value.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.cream,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.dailyPour.value.tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.cream.withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.caramel,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 17,
                color: AppColors.espresso,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeanTeaser extends GetView<HomeController> {
  const _BeanTeaser();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: AppColors.almond,
      borderRadius: 24,
      onTap: () => controller.openTab(1),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BEAN SCHOOL',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.caramelDeep,
                        letterSpacing: 1.3,
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Arabica has half the caffeine\nof Robusta.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        height: 1.35,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Know what you are ordering before the barista asks.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.arrow_outward_rounded,
            color: AppColors.caramelDeep,
            size: 20,
          ),
        ],
      ),
    );
  }
}

/// Lightweight entrance animation used across the dashboard sections.
class _Reveal extends StatelessWidget {
  const _Reveal({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - value)),
          child: animatedChild,
        ),
      ),
      child: child,
    );
  }
}
