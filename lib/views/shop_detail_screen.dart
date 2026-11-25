import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../controllers/shop_directory_controller.dart';
import '../models/coffee_shop_model.dart';
import '../theme/app_colors.dart';
import '../utils/shop_style.dart';
import '../widgets/soft_card.dart';

/// Full profile for a single outlet, pushed with the shop as [Get.arguments].
class ShopDetailScreen extends StatelessWidget {
  const ShopDetailScreen({super.key});

  CoffeeShopModel? get _shop {
    final args = Get.arguments;
    if (args is CoffeeShopModel) return args;
    return Get.find<ShopDirectoryController>().selectedShop.value;
  }

  @override
  Widget build(BuildContext context) {
    final shop = _shop;
    if (shop == null) return const _MissingShopScreen();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _DetailHero(shop: shop)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  shop.description,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
                const SizedBox(height: 18),
                SoftCard(
                  color: AppColors.cream,
                  showShadow: false,
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.schedule_rounded,
                        label: 'Hours',
                        value: shop.openingHours,
                      ),
                      const _InfoDivider(),
                      _InfoRow(
                        icon: Icons.payments_outlined,
                        label: 'Price',
                        value: shop.priceRange,
                      ),
                      const _InfoDivider(),
                      _InfoRow(
                        icon: Icons.auto_awesome_rounded,
                        label: 'Vibe',
                        value: shop.vibeTag,
                      ),
                      const _InfoDivider(),
                      _InfoRow(
                        icon: Icons.place_outlined,
                        label: 'Area',
                        value: shop.addressHint,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Signature drinks', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final drink in shop.signatureDrinks)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.almond,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.crema),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_cafe_rounded,
                              size: 13,
                              color: AppColors.caramelDeep,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              drink,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (shop.menu.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text('Live menu', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 3),
                  Text(
                    'Fetched from the bar · prices in PKR',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  SoftCard(
                    color: AppColors.cream,
                    showShadow: false,
                    child: Column(
                      children: [
                        for (var i = 0; i < shop.menu.length; i++) ...[
                          if (i > 0) const _InfoDivider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shop.menu[i].name,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (shop.menu[i].note != null)
                                      Text(
                                        shop.menu[i].note!,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'PKR ${CoffeeShopModel.formatPkr(shop.menu[i].price)}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.hazelnut,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Text('Order like a regular',
                    style: theme.textTheme.headlineSmall),
                const SizedBox(height: 10),
                for (var i = 0; i < shop.mustTry.length; i++) ...[
                  Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.espresso,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${i + 1}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.caramel,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          shop.mustTry[i],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (i != shop.mustTry.length - 1) const SizedBox(height: 10),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Get.back();
                          Get.find<NavigationController>().goToTab(2);
                        },
                        icon: const Icon(Icons.local_cafe_rounded, size: 17),
                        label: const Text('Build my order'),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingShopScreen extends StatelessWidget {
  const _MissingShopScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.storefront_rounded,
                size: 32,
                color: AppColors.caramelDeep,
              ),
              const SizedBox(height: 12),
              Text(
                'That spot is no longer in the live directory.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Back to the directory'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailHero extends StatelessWidget {
  const _DetailHero({required this.shop});

  final CoffeeShopModel shop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.espresso, AppColors.espressoSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.caramel.withValues(alpha: 0.14),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, topPadding + 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.cream.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.cream.withValues(alpha: 0.16),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 19,
                          color: AppColors.cream,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cream.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.caramel,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            shop.rating.toStringAsFixed(1),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.cream,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final badge in shop.badges)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.caramel.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.caramel,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  shop.name,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.cream,
                    fontSize: 32,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  shop.tagline,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.68),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 14,
                      color: AppColors.caramel,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      shop.area,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.cream.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(width: 12),
                    for (final category in shop.categories.take(2)) ...[
                      Icon(
                        shopCategoryIcon(category),
                        size: 13,
                        color: AppColors.cream.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        category.shortLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.cream.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.caramelDeep),
        const SizedBox(width: 10),
        SizedBox(
          width: 52,
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Divider(
        height: 1,
        color: AppColors.crema.withValues(alpha: 0.7),
      ),
    );
  }
}
