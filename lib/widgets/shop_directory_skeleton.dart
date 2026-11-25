import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pulsing placeholder cards shown while the live directory is loading.
class ShopDirectorySkeleton extends StatefulWidget {
  const ShopDirectorySkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  State<ShopDirectorySkeleton> createState() => _ShopDirectorySkeletonState();
}

class _ShopDirectorySkeletonState extends State<ShopDirectorySkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final tint = 0.30 + (_pulse.value * 0.35);
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          itemCount: widget.itemCount,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _SkeletonCard(tint: tint),
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.tint});

  final double tint;

  @override
  Widget build(BuildContext context) {
    final fill = AppColors.almond.withValues(alpha: tint);

    Widget bar({required double width, double height = 10}) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(999),
          ),
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.crema.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bar(width: 132, height: 12),
                  const SizedBox(height: 8),
                  bar(width: 84, height: 9),
                ],
              ),
              const Spacer(),
              bar(width: 44, height: 20),
            ],
          ),
          const SizedBox(height: 14),
          bar(width: double.infinity, height: 9),
          const SizedBox(height: 7),
          bar(width: 210, height: 9),
          const SizedBox(height: 14),
          Row(
            children: [
              bar(width: 86, height: 22),
              const SizedBox(width: 6),
              bar(width: 74, height: 22),
              const Spacer(),
              bar(width: 78, height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
