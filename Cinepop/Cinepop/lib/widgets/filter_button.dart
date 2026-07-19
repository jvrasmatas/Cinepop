import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../themes/colors.dart';
import 'filter_sheet.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  void _open(BuildContext context) {
    final provider = context.read<MovieProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FilterSheet(
        initialGenreIds: provider.selectedGenreIds,
        initialMinRating: provider.minRating,
        onApply: (genreIds, minRating) {
          provider.applyFilters(genreIds: genreIds, minRating: minRating);
        },
        onClear: provider.clearFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, _) => IconButton(
        icon: Icon(
          provider.isFiltering ? Icons.filter_alt : Icons.filter_alt_outlined,
          color: AppColors.popRed,
        ),
        tooltip: 'Filtros',
        onPressed: () => _open(context),
      ),
    );
  }
}
