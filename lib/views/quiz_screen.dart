import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../controllers/quiz_controller.dart';
import '../models/drink_recommendation_model.dart';
import '../models/quiz_step_model.dart';
import '../theme/app_colors.dart';
import '../widgets/meters.dart';
import '../widgets/soft_card.dart';

class QuizScreen extends GetView<QuizController> {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            child: controller.showingResult
                ? _ResultView(
                    key: const ValueKey('result'),
                    controller: controller,
                    drink: controller.recommendation.value!,
                  )
                : _QuestionView(
                    key: ValueKey('step-${controller.currentStep.value}'),
                    controller: controller,
                  ),
          ),
        ),
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({super.key, required this.controller});

  final QuizController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final step = controller.activeStep;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 20, 0),
          child: Row(
            children: [
              _CircleIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: controller.back,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Coffee match',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                '${controller.currentStep.value + 1} / ${controller.questionCount}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.caramelDeep,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: controller.progress,
              minHeight: 7,
              backgroundColor: AppColors.almond,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.caramel),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QUESTION ${controller.currentStep.value + 1}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    color: AppColors.caramelDeep,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  step.question,
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(step.subtitle, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 22),
                for (final option in step.options) ...[
                  _OptionCard(
                    option: option,
                    selected: controller.selectedFor(step.id) == option.id,
                    onTap: () => controller.answer(option.id),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Tap an answer to continue',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.mutedGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final QuizOption option;
  final bool selected;
  final VoidCallback onTap;

  static IconData _iconFor(String id) => switch (id) {
        'bold_black' => Icons.coffee_rounded,
        'sweet_milky' => Icons.icecream_rounded,
        'smooth_creamy' => Icons.blender_rounded,
        'chilled_iced' => Icons.ac_unit_rounded,
        'intense' => Icons.bolt_rounded,
        'casual' => Icons.forum_outlined,
        'dessert' => Icons.cake_rounded,
        'light' => Icons.eco_rounded,
        _ => Icons.local_cafe_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected ? AppColors.espresso : AppColors.cream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.espresso : AppColors.crema,
          width: 1.2,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.espresso.withValues(alpha: 0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.cream.withValues(alpha: 0.12)
                        : AppColors.almond,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _iconFor(option.id),
                    size: 20,
                    color: selected ? AppColors.caramel : AppColors.caramelDeep,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              option.label,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontSize: 14.5,
                                color: selected
                                    ? AppColors.cream
                                    : AppColors.espresso,
                              ),
                            ),
                          ),
                          if (selected)
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: AppColors.caramel,
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        option.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: selected
                              ? AppColors.cream.withValues(alpha: 0.65)
                              : AppColors.mutedGray,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.caramel.withValues(alpha: 0.16)
                        : AppColors.almond,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    option.hint,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 9.5,
                      color: selected ? AppColors.caramel : AppColors.mutedGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    super.key,
    required this.controller,
    required this.drink,
  });

  final QuizController controller;
  final DrinkRecommendationModel drink;

  Future<void> _copyPhrase(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: drink.orderPhrase));
    Get.snackbar(
      'Order phrase copied',
      drink.orderPhrase,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 18,
      backgroundColor: AppColors.espresso,
      colorText: AppColors.cream,
      icon: const Icon(Icons.content_copy_rounded, color: AppColors.caramel),
    );
  }

  void _goToTab(int index) {
    Get.back();
    Get.find<NavigationController>().goToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasteLabel = controller.answerLabel(
      'taste',
      controller.userAnswers['taste'] ?? '',
    );
    final energyLabel = controller.answerLabel(
      'energy',
      controller.userAnswers['energy'] ?? '',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CircleIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: controller.back,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your coffee match',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: controller.reset,
                child: const Text('Retake'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.espresso, AppColors.espressoSoft],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -50,
                  top: -60,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.caramel.withValues(alpha: 0.16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'BEST MATCH',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.caramel,
                              letterSpacing: 1.6,
                              fontSize: 10,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cream.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              drink.category,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.cream,
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        drink.name,
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: AppColors.cream,
                          fontSize: 32,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        drink.tagline,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.cream.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _StatPill(
                              icon: Icons.bolt_rounded,
                              label: 'Caffeine',
                              value: '${drink.caffeineScore}/5',
                              meterValue: drink.caffeineScore,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatPill(
                              icon: Icons.local_fire_department_rounded,
                              label: 'Calories',
                              value: '${drink.calories} kcal',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SoftCard(
            color: AppColors.almond,
            showShadow: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHY IT MATCHES',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.4,
                    color: AppColors.caramelDeep,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 7),
                Text(drink.whyItMatches, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (tasteLabel.isNotEmpty) _MiniTag(label: tasteLabel),
                    if (energyLabel.isNotEmpty) _MiniTag(label: energyLabel),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Taste profile', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          SoftCard(
            color: AppColors.cream,
            showShadow: false,
            child: Column(
              children: [
                TasteBar(label: 'Sweetness', value: drink.sweetness),
                const SizedBox(height: 12),
                TasteBar(label: 'Acidity', value: drink.acidity),
                const SizedBox(height: 12),
                TasteBar(label: 'Bitterness', value: drink.bitterness),
                const SizedBox(height: 12),
                TasteBar(label: 'Body', value: drink.body),
                const SizedBox(height: 16),
                Divider(color: AppColors.crema.withValues(alpha: 0.7)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.science_outlined,
                      size: 15,
                      color: AppColors.caramelDeep,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Milk ratio: ${drink.milkRatio} · Bean: ${drink.beanSuggestion}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Order it like this', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          SoftCard(
            color: AppColors.cream,
            showShadow: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.almond,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'SAY THIS',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          letterSpacing: 1,
                          color: AppColors.caramelDeep,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.format_quote_rounded,
                      color: AppColors.caramel,
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '"${drink.orderPhrase}"',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.55,
                    color: AppColors.espresso,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _copyPhrase(context),
                    icon: const Icon(Icons.content_copy_rounded, size: 16),
                    label: const Text('Copy phrase'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _goToTab(3),
                  child: const Text('Find a spot'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () => _goToTab(2),
                  child: const Text('Build the order'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Flavour notes: ${drink.flavourNotes.join(' · ')}',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
    this.meterValue,
  });

  final IconData icon;
  final String label;
  final String value;
  final int? meterValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: AppColors.caramel),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.65),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.cream,
            ),
          ),
          if (meterValue != null) ...[
            const SizedBox(height: 6),
            SegmentedMeter(
              value: meterValue!,
              max: 5,
              color: AppColors.caramel,
              trackColor: AppColors.cream.withValues(alpha: 0.18),
              segmentWidth: 11,
              height: 4,
              gap: 3,
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.charcoal,
              fontSize: 10,
            ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.almond,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.crema),
        ),
        child: Icon(icon, size: 19, color: AppColors.espresso),
      ),
    );
  }
}
