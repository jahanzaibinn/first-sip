import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/shop_directory_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/selectable_chip.dart';
import '../widgets/shop_cards.dart';
import '../widgets/shop_directory_skeleton.dart';
import '../widgets/shop_quick_sheet.dart';

/// Filterable directory of Karachi coffee outlets, backed by the live API.
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
                      controller.isInitialLoad
                          ? '… spots'
                          : '${controller.visibleShops.length} spots',
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
            child: Obx(
              () => Row(
                children: [
                  if (!controller.hasError && !controller.isInitialLoad) ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.mint,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      controller.isInitialLoad
                          ? 'Fetching the latest menus…'
                          : controller.hasError
                              ? 'Live menu unavailable · pull to retry'
                              : controller.lastSyncLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: controller.hasError
                            ? AppColors.chili
                            : AppColors.mutedGray,
                      ),
                    ),
                  ),
                  if (controller.hasData)
                    Text(
                      'Tap for profile',
                      style: theme.textTheme.labelSmall,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.caramel,
              backgroundColor: AppColors.cream,
              onRefresh: controller.refreshDirectory,
              child: Obx(() => _buildBody(controller)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ShopDirectoryController controller) {
    if (controller.isInitialLoad) {
      return const ShopDirectorySkeleton();
    }

    if (controller.hasError) {
      return _ErrorState(
        message: controller.errorMessage.value ??
            'The live coffee directory is unavailable.',
        onRetry: controller.retry,
      );
    }

    final shops = controller.visibleShops;
    if (shops.isEmpty) {
      return _EmptyState(
        onReset: () {
          _search.clear();
          controller.resetFilters();
        },
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
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
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 46, 28, 28),
      children: [
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.almond,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              size: 28,
              color: AppColors.chili,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Menu is offline',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 18),
        Center(
          child: FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 17),
            label: const Text('Retry'),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
      children: [
        Center(
          child: Container(
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
        ),
        const SizedBox(height: 16),
        Text(
          'No spots match that',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          'Try another area, clear the search, or loosen the filter.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Reset filters'),
          ),
        ),
      ],
    );
  }
}
