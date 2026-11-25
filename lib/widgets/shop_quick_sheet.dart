import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/coffee_shop_model.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../utils/shop_style.dart';

/// Compact bottom sheet with the essentials. "View full profile" hands off to
/// the dedicated [ShopDetailScreen].
Future<void> showShopQuickSheet(BuildContext context, CoffeeShopModel shop) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) => _ShopQuickSheet(shop: shop),
  );
}

class _ShopQuickSheet extends StatelessWidget {
  const _ShopQuickSheet({required this.shop});

  final CoffeeShopModel shop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.crema,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 2),
                    Text(
                      '${shop.tagline} · ${shop.area}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.almond,
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
                        color: AppColors.espresso,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.schedule_rounded,
            label: 'Opening hours',
            value: shop.openingHours,
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.payments_outlined,
            label: 'Price range',
            value: shop.priceRange,
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.auto_awesome_rounded,
            label: 'Vibe',
            value: shop.vibeTag,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: shop.categories
                .map(
                  (category) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.almond,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          shopCategoryIcon(category),
                          size: 12,
                          color: shopCategoryTint(category),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          category.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.shopDetail, arguments: shop);
              },
              icon: const Icon(Icons.storefront_rounded, size: 18),
              label: const Text('View full profile'),
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
          width: 96,
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
