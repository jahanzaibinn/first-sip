import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/voice_order_controller.dart';
import '../models/coffee_shop_model.dart';
import '../theme/app_colors.dart';
import '../widgets/selectable_chip.dart';
import '../widgets/soft_card.dart';

/// Speak (Urdu, roman Urdu or English) and get the exact order to ask for,
/// matched against the shop's live menu when opened from a shop.
class VoiceOrderScreen extends StatelessWidget {
  const VoiceOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VoiceOrderController>();
    final theme = Theme.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.espresso, AppColors.espressoSoft],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                padding: EdgeInsets.fromLTRB(20, topPadding + 8, 20, 22),
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
                            color: AppColors.caramel.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.mic_rounded,
                                size: 13,
                                color: AppColors.caramel,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'On-device',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.caramel,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ask in your voice',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: AppColors.cream,
                        fontSize: 30,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'اردو یا انگریزی میں بتائیں کیا چاہیے — آرڈر خود بن جائے گا۔',
                      textDirection: TextDirection.rtl,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.cream.withValues(alpha: 0.68),
                        height: 1.6,
                      ),
                    ),
                    if (controller.shop != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.storefront_rounded,
                            size: 14,
                            color: AppColors.caramel,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Ordering at ${controller.shop!.name} · '
                              '${controller.shop!.area}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.cream.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SelectableChip(
                            label: 'اردو',
                            selected: controller.language.value == 'ur',
                            onTap: () => controller.setLanguage('ur'),
                            compact: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SelectableChip(
                            label: 'English',
                            selected: controller.language.value == 'en',
                            onTap: () => controller.setLanguage('en'),
                            compact: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _MicButton(controller: controller),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        controller.isStarting.value
                            ? 'Starting the microphone…'
                            : controller.isListening.value
                                ? 'Listening… speak now'
                                : 'Tap the mic and say what you feel like',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: controller.isListening.value
                              ? AppColors.caramelDeep
                              : AppColors.mutedGray,
                          fontWeight: controller.isListening.value
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (controller.errorMessage.value.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.chili.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          controller.errorMessage.value,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.chili,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (controller.transcript.value.isNotEmpty)
                      SoftCard(
                        color: AppColors.almond,
                        showShadow: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.isUrdu ? 'آپ نے کہا' : 'You said',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.caramelDeep,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              controller.transcript.value,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (controller.suggestion.value != null) ...[
                      const SizedBox(height: 14),
                      _SuggestionCard(controller: controller),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(
                        controller.isUrdu ? 'کچھ مثالیں' : 'Try one of these',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.mutedGray,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final example in controller.examples)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SoftCard(
                                color: AppColors.cream,
                                showShadow: false,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                onTap: () => controller.useExample(example),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.record_voice_over_rounded,
                                      size: 15,
                                      color: AppColors.caramelDeep,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        example,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppColors.charcoal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  const _MicButton({required this.controller});

  final VoiceOrderController controller;

  @override
  Widget build(BuildContext context) {
    final listening = controller.isListening.value;

    return Center(
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: controller.toggleListening,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          width: listening ? 112 : 96,
          height: listening ? 112 : 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: listening
                  ? [AppColors.caramelDeep, AppColors.caramel]
                  : [AppColors.espresso, AppColors.espressoSoft],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.espresso.withValues(
                  alpha: listening ? 0.28 : 0.16,
                ),
                blurRadius: listening ? 26 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            listening ? Icons.stop_rounded : Icons.mic_rounded,
            size: listening ? 40 : 34,
            color: listening ? AppColors.espresso : AppColors.caramel,
          ),
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.controller});

  final VoiceOrderController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final order = controller.suggestion.value!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.espresso,
        borderRadius: BorderRadius.circular(26),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.caramel.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 17,
                  color: AppColors.caramel,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your order',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.6),
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              if (order.pricePkr != null)
                Text(
                  'PKR ${CoffeeShopModel.formatPkr(order.pricePkr!)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.caramel,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            order.drinkName,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.cream,
              height: 1.2,
            ),
          ),
          if (order.menuItem != null && order.shopName != null) ...[
            const SizedBox(height: 4),
            Text(
              'On ${order.shopName}\'s live menu',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.cream.withValues(alpha: 0.55),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Text(
            order.reason,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.cream.withValues(alpha: 0.72),
              height: 1.6,
            ),
          ),
          if (order.signals.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final signal in order.signals)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.caramel.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      signal,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.caramel,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cream.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.cream.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Say this at the counter',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  order.englishPhrase,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.cream,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  color: AppColors.cream.withValues(alpha: 0.12),
                ),
                const SizedBox(height: 12),
                Text(
                  order.urduPhrase,
                  textDirection: TextDirection.rtl,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.85),
                    height: 1.9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: controller.copyPhrase,
                  icon: const Icon(Icons.content_copy_rounded, size: 16),
                  label: const Text('Copy order'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.caramel,
                    foregroundColor: AppColors.espresso,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: controller.clear,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.cream,
                  side: BorderSide(
                    color: AppColors.cream.withValues(alpha: 0.24),
                  ),
                ),
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
