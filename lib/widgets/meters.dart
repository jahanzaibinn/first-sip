import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Five rounded segments, filled according to [value] (0–max).
class SegmentedMeter extends StatelessWidget {
  const SegmentedMeter({
    super.key,
    required this.value,
    this.max = 5,
    this.color = AppColors.caramel,
    this.trackColor = AppColors.crema,
    this.segmentWidth = 16,
    this.height = 7,
    this.gap = 4,
  });

  final int value;
  final int max;
  final Color color;
  final Color trackColor;
  final double segmentWidth;
  final double height;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (index) {
        final filled = index < value;
        return Padding(
          padding: EdgeInsets.only(right: index == max - 1 ? 0 : gap),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
            width: segmentWidth,
            height: height,
            decoration: BoxDecoration(
              color: filled ? color : trackColor.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}

/// Label + segmented meter, used for caffeine and taste rows.
class MeterRow extends StatelessWidget {
  const MeterRow({
    super.key,
    required this.label,
    required this.value,
    this.max = 5,
    this.color = AppColors.caramel,
    this.valueLabel,
    this.dark = false,
  });

  final String label;
  final int value;
  final int max;
  final Color color;
  final String? valueLabel;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final labelColor = dark ? AppColors.cream : AppColors.charcoal;
    final mutedColor =
        dark ? AppColors.cream.withValues(alpha: 0.6) : AppColors.mutedGray;

    return Row(
      children: [
        SizedBox(
          width: 86,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        SegmentedMeter(
          value: value,
          max: max,
          color: color,
          trackColor:
              dark ? AppColors.cream.withValues(alpha: 0.18) : AppColors.crema,
        ),
        const Spacer(),
        Text(
          valueLabel ?? '$value/$max',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: mutedColor,
                letterSpacing: 0.2,
              ),
        ),
      ],
    );
  }
}

/// Thin continuous bar for 0–1 taste values.
class TasteBar extends StatelessWidget {
  const TasteBar({
    super.key,
    required this.label,
    required this.value,
    this.color = AppColors.caramel,
    this.dark = false,
  });

  final String label;
  final double value;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final muted =
        dark ? AppColors.cream.withValues(alpha: 0.65) : AppColors.mutedGray;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: dark ? AppColors.cream : AppColors.charcoal,
                      letterSpacing: 0.2,
                    ),
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: muted,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value.clamp(0, 1).toDouble(),
            minHeight: 6,
            backgroundColor: dark
                ? AppColors.cream.withValues(alpha: 0.16)
                : AppColors.crema.withValues(alpha: 0.6),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
