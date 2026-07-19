import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_router.dart';
import '../models/movie.dart';
import '../providers/favorite_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/empty_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  void _openDetails(BuildContext context, Movie movie) {
    Navigator.of(context).pushNamed(AppRouter.details, arguments: movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis favoritos')),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          if (provider.isEmpty) {
            return EmptyWidget(
              icon: Icons.favorite_border,
              title: 'Aún no tienes favoritos',
              subtitle:
                  'Toca el corazón en cualquier película para guardarla aquí.',
              actionLabel: 'Explorar películas',
              onAction: () => Navigator.of(context).pop(),
            );
          }

          final favorites = provider.favorites;
          final width = MediaQuery.of(context).size.width;
          final crossAxisCount = (width / 160).floor().clamp(2, 5);

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.52,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final movie = favorites[index];
              return MovieCard(
                movie: movie,
                width: double.infinity,
                onTap: () => _openDetails(context, movie),
              );
            },
          );
        },
      ),
    );
  }
}
