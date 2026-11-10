import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/shop_directory_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/selectable_chip.dart';
import '../widgets/shop_cards.dart';
import '../widgets/shop_quick_sheet.dart';

/// Filterable directory of Karachi coffee outlets.
class ShopDirectoryScreen extends StatefulWidget {
  const ShopDirectoryScreen({super.key});

  @override
  State<ShopDirectoryScreen> createState() => _ShopDirectoryScreenState();
}

class _ShopDirectoryScreenState extends State<ShopDirectoryScreen> {
  final ShopDirectoryController controller =
      Get.find<ShopDirectoryController>();
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _search.clear();
    controller.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURATED DIRECTORY',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.caramelDeep,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Coffee spots in Karachi',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.espresso,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${controller.visibleShops.length} spots',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.caramel,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: TextField(
              controller: _search,
              onChanged: controller.setQuery,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search an area, drink or vibe',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: Obx(
                  () => controller.searchQuery.value.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.close_rounded, size: 18),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: Obx(
              () => ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = controller.filters[index];
                  return SelectableChip(
                    label: filter.label,
                    selected: controller.activeFilterId.value == filter.id,
                    onTap: () => controller.selectFilter(filter.id),
                    compact: true,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Tap for the full profile · long-press for a quick look',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.mutedGray,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              final shops = controller.visibleShops;

              if (shops.isEmpty) {
                return _EmptyState(onReset: () {
                  _search.clear();
                  controller.resetFilters();
                });
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                itemCount: shops.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return GestureDetector(
                    onLongPress: () => showShopQuickSheet(context, shop),
                    child: DirectoryShopCard(
                      shop: shop,
                      onTap: () => controller.openShop(shop),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.almond,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 28,
                color: AppColors.caramelDeep,
              ),
            ),
            const SizedBox(height: 16),
            Text('No spots match that', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Try another area, clear the search, or loosen the filter.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Reset filters'),
            ),
          ],
        ),
      ),
    );
  }
}
