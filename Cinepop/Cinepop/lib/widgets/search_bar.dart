import 'package:flutter/material.dart';

import '../themes/colors.dart';

class CinepopSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String hintText;

  const CinepopSearchBar({
    super.key,
    required this.onChanged,
    this.onClear,
    this.hintText = 'Buscar películas...',
  });

  @override
  State<CinepopSearchBar> createState() => _CinepopSearchBarState();
}

class _CinepopSearchBarState extends State<CinepopSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    setState(() => _hasText = value.isNotEmpty);
    widget.onChanged(value);
  }

  void _handleClear() {
    _controller.clear();
    setState(() => _hasText = false);
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _handleChanged,
      textInputAction: TextInputAction.search,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.muted),
                onPressed: _handleClear,
              )
            : null,
      ),
    );
  }
}
