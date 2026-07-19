import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../themes/colors.dart';
import '../utils/image_helper.dart';
import 'rating_widget.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  final double width;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.width = 140,
  });

  @override
  Widget build(BuildContext context) {
    final posterUrl = ImageHelper.posterUrl(movie.posterPath);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poster with a fixed 2:3 aspect ratio.
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: posterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: posterUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const _PosterPlaceholder(),
                        errorWidget: (_, __, ___) => const _PosterFallback(),
                      )
                    : const _PosterFallback(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingWidget(rating: movie.voteAverage),
                Text(
                  movie.year,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.movie_outlined, color: AppColors.muted, size: 40),
      ),
    );
  }
}
