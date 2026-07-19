import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../themes/colors.dart';
import 'movie_card.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final ValueChanged<Movie> onMovieTap;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(movie: movie, onTap: () => onMovieTap(movie));
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
