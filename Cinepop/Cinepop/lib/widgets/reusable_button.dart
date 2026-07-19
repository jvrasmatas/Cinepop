import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool expanded;

  const ReusableButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 20),
            label: Text(label),
          )
        : ElevatedButton(onPressed: onPressed, child: Text(label));

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
