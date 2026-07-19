import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../services/tmdb_service.dart';
import '../themes/colors.dart';
import 'loading_widget.dart';

class DiscoverButton extends StatelessWidget {
  final ValueChanged<Movie> onMovieFound;

  const DiscoverButton({super.key, required this.onMovieFound});

  Future<void> _open(BuildContext context) async {
    final provider = context.read<MovieProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        backgroundColor: AppColors.surface,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: LoadingWidget(message: 'Buscando algo para ti...'),
        ),
      ),
    );

    try {
      final movie = await provider.getRandomMovie();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      onMovieFound(movie);
    } on TmdbException catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo encontrar una película.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.popRed,
      borderRadius: BorderRadius.circular(12),
      child: IconButton(
        icon: const Icon(Icons.shuffle, color: Colors.white),
        tooltip: 'Descubrir',
        onPressed: () => _open(context),
      ),
    );
  }
}
