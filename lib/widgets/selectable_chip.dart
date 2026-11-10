import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A pill chip that animates between the cream and espresso surface states.
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
    this.trailing,
    this.compact = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? leading;
  final IconData? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.cream : AppColors.charcoal;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 14 : 17,
              vertical: compact ? 9 : 12,
            ),
            decoration: BoxDecoration(
              color: selected ? AppColors.espresso : AppColors.cream,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: selected ? AppColors.espresso : AppColors.crema,
                width: 1.3,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.espresso.withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  Icon(
                    leading,
                    size: compact ? 14 : 16,
                    color: selected ? AppColors.caramel : AppColors.mutedGray,
                  ),
                  const SizedBox(width: 7),
                ],
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: compact ? 12.5 : 13.5,
                        color: foreground,
                        fontWeight: FontWeight.w600,
                      ),
                  child: Text(label),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 6),
                  Icon(
                    trailing,
                    size: 15,
                    color: selected ? AppColors.caramel : AppColors.mutedGray,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
