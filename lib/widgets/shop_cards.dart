import 'package:flutter/material.dart';

import '../models/coffee_shop_model.dart';
import '../theme/app_colors.dart';
import '../utils/shop_style.dart';
import 'soft_card.dart';

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.shop});

  final CoffeeShopModel shop;

  @override
  Widget build(BuildContext context) {
    final category = shop.categories.first;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.caramel.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        shopCategoryIcon(category),
        size: 19,
        color: shopCategoryTint(category),
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.almond,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 13, color: AppColors.caramel),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.espresso,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

/// Wide card used in the horizontally scrolling home spotlight rail.
class SpotlightShopCard extends StatelessWidget {
  const SpotlightShopCard({
    super.key,
    required this.shop,
    required this.onTap,
  });

  final CoffeeShopModel shop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 266,
      child: SoftCard(
        color: AppColors.cream,
        borderRadius: 26,
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _CategoryBadge(shop: shop),
                const Spacer(),
                _RatingPill(rating: shop.rating),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              shop.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 2),
            Text(
              shop.tagline,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.almond,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 13,
                    color: AppColors.mutedGray,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    shop.area,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.mutedGray,
                        ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    shop.priceRange,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.hazelnut,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Text(
                  'Details',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.caramelDeep,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppColors.caramelDeep,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-width list card used in the Karachi spot finder.
class DirectoryShopCard extends StatelessWidget {
  const DirectoryShopCard({
    super.key,
    required this.shop,
    required this.onTap,
    this.onLongPress,
  });

  final CoffeeShopModel shop;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: AppColors.cream,
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryBadge(shop: shop),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 12,
                          color: AppColors.mutedGray,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            shop.area,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _RatingPill(rating: shop.rating),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            shop.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: shop.categories
                .take(2)
                .map(
                  (category) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.almond,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          shopCategoryIcon(category),
                          size: 12,
                          color: shopCategoryTint(category),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          category.shortLabel,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.charcoal,
                                  ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                shop.priceRange,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.hazelnut,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                shop.badges.isEmpty ? 'View spot' : shop.badges.first,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.mutedGray,
                    ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.mutedGray,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
