import 'package:flutter/material.dart';

import '../themes/colors.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;
  final bool showIcon;

  const AppLogo({super.key, this.fontSize = 28, this.showIcon = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            Icons.local_movies_rounded,
            color: AppColors.popRed,
            size: fontSize + 4,
          ),
          const SizedBox(width: 8),
        ],
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(
                text: 'Cine',
                style: TextStyle(color: AppColors.white),
              ),
              TextSpan(
                text: 'pop',
                style: TextStyle(color: AppColors.popRed),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
