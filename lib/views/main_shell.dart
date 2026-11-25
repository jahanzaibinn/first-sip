import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../theme/app_colors.dart';
import 'bean_guide_screen.dart';
import 'home_screen.dart';
import 'order_builder_screen.dart';
import 'shop_directory_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Obx(
        () => IndexedStack(
          index: navigation.tabIndex.value,
          children: const [
            HomeScreen(),
            BeanGuideScreen(),
            OrderBuilderScreen(),
            ShopDirectoryScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _CoffeeNavBar(navigation: navigation),
    );
  }
}

class _CoffeeNavBar extends StatelessWidget {
  const _CoffeeNavBar({required this.navigation});

  final NavigationController navigation;

  static const List<(IconData, String)> _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.menu_book_rounded, 'Beans'),
    (Icons.local_cafe_rounded, 'Order'),
    (Icons.place_rounded, 'Spots'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(top: BorderSide(color: AppColors.crema, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Obx(
            () => Row(
              children: List.generate(_items.length, (index) {
                final selected = navigation.tabIndex.value == index;
                final (icon, label) = _items[index];

                return Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => navigation.goToTab(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppColors.almond : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 21,
                              color: selected
                                  ? AppColors.caramelDeep
                                  : AppColors.mutedGray,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              label,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: selected
                                        ? AppColors.espresso
                                        : AppColors.mutedGray,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
