import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/order_builder_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/selectable_chip.dart';
import '../widgets/soft_card.dart';

/// Chip-driven order builder with a live, copy-ready counter phrase.
class OrderBuilderScreen extends GetView<OrderBuilderController> {
  const OrderBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _Header(controller: controller),
          Expanded(
            child: Obx(
              () => ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  _Section(
                    index: 1,
                    title: 'Size & temperature',
                    helper:
                        '${controller.sizeOption.value.detail} · ${controller.temperatureLabel}',
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final size in controller.sizes)
                            SelectableChip(
                              label: size.label,
                              selected:
                                  controller.sizeOption.value.id == size.id,
                              onTap: () => controller.selectSize(size),
                              compact: true,
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SelectableChip(
                            label: 'Hot',
                            leading: Icons.local_fire_department_rounded,
                            selected: !controller.isIced.value,
                            onTap: () => controller.setIced(false),
                            compact: true,
                          ),
                          const SizedBox(width: 8),
                          SelectableChip(
                            label: 'Iced',
                            leading: Icons.ac_unit_rounded,
                            selected: controller.isIced.value,
                            onTap: () => controller.setIced(true),
                            compact: true,
                          ),
                          if (controller.isColdBrew) ...[
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'Always iced',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: AppColors.mutedGray),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  _Section(
                    index: 2,
                    title: 'Coffee base',
                    helper: controller.baseOption.value.detail,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final base in controller.bases)
                            SelectableChip(
                              label: base.label,
                              leading: _baseIcon(base.id),
                              selected:
                                  controller.baseOption.value.id == base.id,
                              onTap: () => controller.selectBase(base),
                              compact: true,
                            ),
                        ],
                      ),
                    ],
                  ),
                  _Section(
                    index: 3,
                    title: 'Milk',
                    helper: controller.hasMilk
                        ? controller.milkOption.value.detail
                        : 'Black — no dairy',
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final milk in controller.milks)
                            SelectableChip(
                              label: milk.label,
                              selected:
                                  controller.milkOption.value.id == milk.id,
                              onTap: () => controller.selectMilk(milk),
                              compact: true,
                            ),
                        ],
                      ),
                    ],
                  ),
                  _Section(
                    index: 4,
                    title: 'Sweetness',
                    helper: controller.sweetnessOption.value.detail,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final level in controller.sweetnessLevels)
                            SelectableChip(
                              label: level.label,
                              selected: controller.sweetnessOption.value.id ==
                                  level.id,
                              onTap: () => controller.selectSweetness(level),
                              compact: true,
                            ),
                        ],
                      ),
                    ],
                  ),
                  _Section(
                    index: 5,
                    title: 'Flavour shot',
                    helper: controller.flavourOption.value.id == 'none'
                        ? 'No syrup'
                        : controller.flavourOption.value.detail,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final flavour in controller.flavours)
                            SelectableChip(
                              label: flavour.label,
                              selected: controller.flavourOption.value.id ==
                                  flavour.id,
                              onTap: () => controller.selectFlavour(flavour),
                              compact: true,
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SoftCard(
                    color: AppColors.almond,
                    showShadow: false,
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 17,
                          color: AppColors.caramelDeep,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Say the size first, then hot or iced, then milk and the drink name. '
                            'Sweetness and syrup go last — that is exactly how the barista writes the cup.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      height: 1.5,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _LiveOrderBanner(controller: controller),
        ],
      ),
    );
  }

  static IconData _baseIcon(String id) => switch (id) {
        'espresso' => Icons.coffee_rounded,
        'double' => Icons.coffee_maker_rounded,
        'cold_brew' => Icons.ac_unit_rounded,
        'drip' => Icons.filter_alt_outlined,
        _ => Icons.local_cafe_rounded,
      };
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final OrderBuilderController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order like a pro',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap through, then read the live phrase out loud.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Tooltip(
            message: 'Reset order',
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: controller.reset,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.almond,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.crema),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: AppColors.espresso,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.index,
    required this.title,
    required this.helper,
    required this.children,
  });

  final int index;
  final String title;
  final String helper;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.espresso,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$index',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.caramel,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Text(title, style: theme.textTheme.titleMedium),
              const Spacer(),
              Flexible(
                child: Text(
                  helper,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.mutedGray,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

/// Pinned banner that reads the composed phrase straight from the controller.
class _LiveOrderBanner extends StatelessWidget {
  const _LiveOrderBanner({required this.controller});

  final OrderBuilderController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final phrase = controller.orderPhrase;

      return Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        padding: const EdgeInsets.fromLTRB(18, 15, 18, 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.espresso, AppColors.espressoSoft],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: AppColors.espresso.withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
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
                  'LIVE ORDER',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.caramel,
                    letterSpacing: 1.5,
                    fontSize: 9.5,
                  ),
                ),
                const Spacer(),
                Text(
                  '${controller.caffeineMg} mg · ${controller.calories} kcal',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.55),
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOutCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.12),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: Text(
                '"$phrase"',
                key: ValueKey(phrase),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.cream,
                  fontSize: 14.5,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.cream.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      controller.toppingLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.cream.withValues(alpha: 0.75),
                        fontSize: 9.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: controller.copyOrderPhrase,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.caramel,
                    foregroundColor: AppColors.espresso,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  icon: const Icon(Icons.content_copy_rounded, size: 15),
                  label: const Text('Copy'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
