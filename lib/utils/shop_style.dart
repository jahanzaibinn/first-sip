import 'package:flutter/material.dart';

import '../models/coffee_shop_model.dart';
import '../theme/app_colors.dart';

IconData shopCategoryIcon(ShopCategory category) => switch (category) {
      ShopCategory.specialtyCoffee => Icons.coffee_rounded,
      ShopCategory.workspaceFriendly => Icons.laptop_mac_rounded,
      ShopCategory.lateNight => Icons.nightlight_round,
      ShopCategory.budgetFriendly => Icons.savings_rounded,
    };

Color shopCategoryTint(ShopCategory category) => switch (category) {
      ShopCategory.specialtyCoffee => AppColors.caramelDeep,
      ShopCategory.workspaceFriendly => AppColors.mint,
      ShopCategory.lateNight => const Color(0xFF55669C),
      ShopCategory.budgetFriendly => AppColors.hazelnut,
    };
