import 'package:flutter/material.dart';

import '../themes/colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? AppColors.popRed : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.popRed : AppColors.divider,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 13,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );

    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }
}
