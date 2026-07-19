import 'package:flutter/material.dart';

import '../themes/colors.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final double size;

  const RatingWidget({super.key, required this.rating, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: AppColors.butterYellow, size: size + 4),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: AppColors.white,
            fontSize: size,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
