import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cast.dart';
import '../models/movie.dart';
import '../providers/favorite_provider.dart';
import '../services/tmdb_service.dart';
import '../themes/colors.dart';
import '../utils/image_helper.dart';
import '../widgets/cast_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/rating_widget.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TmdbService _service = TmdbService();

  late Future<_DetailsData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadDetails();
  }

  Future<_DetailsData> _loadDetails() async {
    final detailsFuture = _service.getMovieDetails(widget.movie.id);
    final creditsFuture = _service.getMovieCredits(widget.movie.id);

    final movie = await detailsFuture;
    final credits = await creditsFuture;

    return _DetailsData(movie: movie, cast: credits.cast);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<_DetailsData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _DetailsScaffold(
              child: LoadingWidget(message: 'Cargando detalles...'),
            );
          }

          if (snapshot.hasError) {
            final message = snapshot.error is TmdbException
                ? (snapshot.error as TmdbException).message
                : 'No se pudieron cargar los detalles.';
            return _DetailsScaffold(
              child: EmptyWidget(
                icon: Icons.error_outline,
                title: 'Error',
                subtitle: message,
                actionLabel: 'Reintentar',
                onAction: () => setState(() => _future = _loadDetails()),
              ),
            );
          }

          final data = snapshot.data!;
          return _DetailsContent(movie: data.movie, cast: data.cast);
        },
      ),
    );
  }
}

class _DetailsData {
  final Movie movie;
  final List<Cast> cast;

  const _DetailsData({required this.movie, required this.cast});
}

class _DetailsScaffold extends StatelessWidget {
  final Widget child;

  const _DetailsScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final Movie movie;
  final List<Cast> cast;

  const _DetailsContent({required this.movie, required this.cast});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _DetailsHeader(movie: movie),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _MetaRow(movie: movie),
                if (movie.genres.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres
                        .map((g) => CategoryChip(label: g.name))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 24),
                const _SectionTitle('Sinopsis'),
                const SizedBox(height: 8),
                Text(
                  movie.overview.isNotEmpty
                      ? movie.overview
                      : 'No hay sinopsis disponible para esta película.',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                if (cast.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const _SectionTitle('Reparto'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: cast.length > 15 ? 15 : cast.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => CastCard(cast: cast[i]),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsHeader extends StatelessWidget {
  final Movie movie;

  const _DetailsHeader({required this.movie});

  @override
  Widget build(BuildContext context) {
    final backdropUrl =
        ImageHelper.backdropUrl(movie.backdropPath) ??
        ImageHelper.posterUrl(movie.posterPath);

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.midnightBlue,
      leading: _CircleIconButton(
        icon: Icons.arrow_back,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Consumer<FavoriteProvider>(
          builder: (context, favorites, _) {
            final isFav = favorites.isFavorite(movie.id);
            return _CircleIconButton(
              icon: isFav ? Icons.favorite : Icons.favorite_border,
              color: AppColors.popRed,
              onPressed: () => favorites.toggle(movie),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (backdropUrl != null)
              CachedNetworkImage(
                imageUrl: backdropUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _buildFallback(),
              )
            else
              _buildFallback(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.midnightBlue],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.movie_outlined, size: 64, color: AppColors.muted),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Movie movie;

  const _MetaRow({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingWidget(rating: movie.voteAverage, size: 16),
        const SizedBox(width: 16),
        const Icon(Icons.calendar_today, size: 14, color: AppColors.muted),
        const SizedBox(width: 6),
        Text(
          movie.releaseDate.isNotEmpty ? movie.releaseDate : movie.year,
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    this.color = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.black45,
        child: IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
