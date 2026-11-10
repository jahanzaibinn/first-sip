import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bean_guide_controller.dart';
import '../models/coffee_bean_model.dart';
import '../models/milk_ratio_model.dart';
import '../theme/app_colors.dart';
import '../widgets/app_section_header.dart';
import '../widgets/meters.dart';
import '../widgets/soft_card.dart';

/// Bean & health knowledge hub: Arabica vs Robusta and milk ratios.
class BeanGuideScreen extends GetView<BeanGuideController> {
  const BeanGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          Text('BEAN SCHOOL',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.caramelDeep,
                letterSpacing: 1.6,
              )),
          const SizedBox(height: 4),
          Text("Know what's in your cup", style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Two species explain almost every difference you taste at the bar.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 18),
          Obx(
            () => _BeanToggle(
              beans: controller.beans,
              activeIndex: controller.activeBeanIndex.value,
              onSelect: controller.selectBean,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              child: _BeanCard(
                key: ValueKey(controller.activeBean.name),
                bean: controller.activeBean,
              ),
            ),
          ),
          const SizedBox(height: 26),
          const AppSectionHeader(
            eyebrow: 'Ratio breakdown',
            title: 'Milk to espresso',
          ),
          const SizedBox(height: 4),
          Text(
            'Same shot, different cup. The ratio decides how strong it tastes.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Obx(
            () => Column(
              children: [
                for (final ratio in controller.milkRatios) ...[
                  _MilkRatioTile(
                    ratio: ratio,
                    expanded: controller.expandedMilkRatio.value == ratio.name,
                    onTap: () => controller.toggleMilkRatio(ratio.name),
                  ),
                  const SizedBox(height: 9),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          const _CaffeineComparison(),
        ],
      ),
    );
  }
}

class _BeanToggle extends StatelessWidget {
  const _BeanToggle({
    required this.beans,
    required this.activeIndex,
    required this.onSelect,
  });

  final List<CoffeeBeanModel> beans;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.almond,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.crema),
      ),
      child: Row(
        children: [
          for (var index = 0; index < beans.length; index++)
            Expanded(
              child: GestureDetector(
                onTap: () => onSelect(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: activeIndex == index
                        ? AppColors.espresso
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        beans[index].name,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: activeIndex == index
                                  ? AppColors.cream
                                  : AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        beans[index].tagline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontSize: 9.5,
                              color: activeIndex == index
                                  ? AppColors.cream.withValues(alpha: 0.6)
                                  : AppColors.mutedGray,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BeanCard extends StatelessWidget {
  const _BeanCard({super.key, required this.bean});

  final CoffeeBeanModel bean;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.crema.withValues(alpha: 0.8)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 26,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.caramel.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  bean.species.label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.caramelDeep,
                    letterSpacing: 1.2,
                    fontSize: 9.5,
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  bean.species.scientificName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(bean.name, style: theme.textTheme.headlineLarge),
          const SizedBox(height: 2),
          Text(bean.tagline, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final note in bean.flavourNotes)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.almond,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    note,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: AppColors.charcoal,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.crema.withValues(alpha: 0.7)),
          const SizedBox(height: 10),
          Text(
            bean.tasteSummary,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
          ),
          const SizedBox(height: 16),
          _FactRow(label: 'Origin', value: bean.origin),
          const SizedBox(height: 9),
          _FactRow(label: 'Altitude', value: bean.altitude),
          const SizedBox(height: 9),
          _FactRow(label: 'Roast', value: bean.roastLevel),
          const SizedBox(height: 9),
          _FactRow(label: 'Aroma', value: bean.aroma),
          const SizedBox(height: 16),
          MeterRow(
              label: 'Caffeine',
              value: bean.caffeineScore,
              color: AppColors.chili),
          const SizedBox(height: 10),
          MeterRow(
              label: 'Acidity',
              value: bean.acidityScore,
              color: AppColors.caramel),
          const SizedBox(height: 10),
          MeterRow(
              label: 'Sweetness',
              value: bean.sweetnessScore,
              color: AppColors.hazelnut),
          const SizedBox(height: 10),
          MeterRow(
              label: 'Bitterness',
              value: bean.bitternessScore,
              color: AppColors.espressoSoft),
          const SizedBox(height: 10),
          MeterRow(label: 'Body', value: bean.bodyScore, color: AppColors.mint),
          const SizedBox(height: 16),
          Text(
            'BEST FOR',
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.3,
              color: AppColors.mutedGray,
              fontSize: 9.5,
            ),
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final use in bean.bestFor)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.espresso,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    use,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.cream,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          SoftCard(
            color: AppColors.almond,
            showShadow: false,
            borderRadius: 18,
            padding: const EdgeInsets.all(14),
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
                    bean.funFact,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
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

class _MilkRatioTile extends StatelessWidget {
  const _MilkRatioTile({
    required this.ratio,
    required this.expanded,
    required this.onTap,
  });

  final MilkRatioModel ratio;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: expanded ? AppColors.almond : AppColors.cream,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.crema),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(ratio.name, style: theme.textTheme.titleSmall),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.caramel.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      ratio.strengthLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        color: AppColors.caramelDeep,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${ratio.espressoPercent}% espresso',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.mutedGray,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(
                      Icons.expand_more_rounded,
                      size: 18,
                      color: AppColors.mutedGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: AppColors.oat),
                      FractionallySizedBox(
                        widthFactor: ratio.espressoPercent / 100,
                        alignment: Alignment.centerLeft,
                        child: Container(color: AppColors.espresso),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.coffee_rounded,
                      size: 11, color: AppColors.espresso),
                  const SizedBox(width: 3),
                  Text(
                    '${ratio.espressoPercent}% coffee',
                    style: theme.textTheme.labelSmall?.copyWith(fontSize: 9.5),
                  ),
                  const Spacer(),
                  Text(
                    '${ratio.milkPercent}% milk',
                    style: theme.textTheme.labelSmall?.copyWith(fontSize: 9.5),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.water_drop_outlined,
                      size: 11, color: AppColors.hazelnut),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: expanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          ratio.description,
                          style:
                              theme.textTheme.bodySmall?.copyWith(height: 1.5),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaffeineComparison extends StatelessWidget {
  const _CaffeineComparison();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftCard(
      color: AppColors.espresso,
      showShadow: false,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CAFFEINE CHECK',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.caramel,
              letterSpacing: 1.4,
              fontSize: 9.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Robusta carries roughly double the caffeine of Arabica.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.cream.withValues(alpha: 0.72),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CaffeineColumn(
                  name: 'Arabica',
                  percentage: '1.2%',
                  score: 2,
                ),
              ),
              Container(
                width: 1,
                height: 58,
                color: AppColors.cream.withValues(alpha: 0.12),
              ),
              Expanded(
                child: _CaffeineColumn(
                  name: 'Robusta',
                  percentage: '2.2%',
                  score: 5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CaffeineColumn extends StatelessWidget {
  const _CaffeineColumn({
    required this.name,
    required this.percentage,
    required this.score,
  });

  final String name;
  final String percentage;
  final int score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          percentage,
          style: theme.textTheme.displayMedium?.copyWith(
            color: AppColors.cream,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.cream.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        SegmentedMeter(
          value: score,
          color: AppColors.caramel,
          trackColor: AppColors.cream.withValues(alpha: 0.18),
          segmentWidth: 15,
          height: 5,
        ),
      ],
    );
  }
}
