import 'package:flutter/material.dart';

import '../config/genres.dart';
import '../themes/colors.dart';
import 'category_chip.dart';

class FilterSheet extends StatefulWidget {
  final Set<int> initialGenreIds;
  final double initialMinRating;
  final void Function(Set<int> genreIds, double minRating) onApply;
  final VoidCallback onClear;

  const FilterSheet({
    super.key,
    required this.initialGenreIds,
    required this.initialMinRating,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late Set<int> _genreIds;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    _genreIds = {...widget.initialGenreIds};
    _minRating = widget.initialMinRating;
  }

  void _toggleGenre(int id) {
    setState(() {
      if (_genreIds.contains(id)) {
        _genreIds.remove(id);
      } else {
        _genreIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtrar películas',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Géneros',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppGenres.all.entries
                  .map(
                    (entry) => CategoryChip(
                      label: entry.value,
                      selected: _genreIds.contains(entry.key),
                      onTap: () => _toggleGenre(entry.key),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              _minRating > 0
                  ? 'Calificación mínima: ${_minRating.toStringAsFixed(1)}'
                  : 'Calificación mínima: cualquiera',
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            Slider(
              value: _minRating,
              min: 0,
              max: 9,
              divisions: 18,
              activeColor: AppColors.popRed,
              onChanged: (value) => setState(() => _minRating = value),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onClear();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Limpiar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.popRed,
                    ),
                    onPressed: () {
                      widget.onApply(_genreIds, _minRating);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Aplicar filtros'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
