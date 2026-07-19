import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_router.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../themes/colors.dart';
import '../widgets/app_logo.dart';
import '../widgets/discover_button.dart';
import '../widgets/empty_widget.dart';
import '../widgets/filter_button.dart';
import '../widgets/loading_widget.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_section.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Load home data once the first frame is scheduled.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadHome();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<MovieProvider>().search(query);
    });
  }

  void _onSearchCleared() {
    _debounce?.cancel();
    context.read<MovieProvider>().clearSearch();
  }

  void _openDetails(Movie movie) {
    Navigator.of(context).pushNamed(AppRouter.details, arguments: movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(fontSize: 24),
        actions: [
          const FilterButton(),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.popRed),
            tooltip: 'Favoritos',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRouter.favorites),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Desarrollador',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRouter.developer),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: CinepopSearchBar(
                    onChanged: _onSearchChanged,
                    onClear: _onSearchCleared,
                  ),
                ),
                const SizedBox(width: 8),
                DiscoverButton(onMovieFound: _openDetails),
              ],
            ),
          ),
          Expanded(
            child: Consumer<MovieProvider>(
              builder: (context, provider, _) {
                if (provider.isSearching) {
                  return _SearchResults(
                    provider: provider,
                    onMovieTap: _openDetails,
                  );
                }
                if (provider.isFiltering) {
                  return _FilterResults(
                    provider: provider,
                    onMovieTap: _openDetails,
                  );
                }
                return _BrowseView(
                  provider: provider,
                  onMovieTap: _openDetails,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BrowseView extends StatelessWidget {
  final MovieProvider provider;
  final ValueChanged<Movie> onMovieTap;

  const _BrowseView({required this.provider, required this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    switch (provider.homeState) {
      case ViewState.loading:
      case ViewState.idle:
        return const LoadingWidget(message: 'Cargando películas...');
      case ViewState.error:
        return EmptyWidget(
          icon: Icons.wifi_off_rounded,
          title: 'No se pudieron cargar las películas',
          subtitle: provider.homeError,
          actionLabel: 'Reintentar',
          onAction: provider.loadHome,
        );
      case ViewState.loaded:
        return RefreshIndicator(
          color: AppColors.popRed,
          onRefresh: provider.loadHome,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              MovieSection(
                title: 'Populares',
                movies: provider.popular,
                onMovieTap: onMovieTap,
              ),
              MovieSection(
                title: 'Mejor calificadas',
                movies: provider.topRated,
                onMovieTap: onMovieTap,
              ),
              MovieSection(
                title: 'Próximos estrenos',
                movies: provider.upcoming,
                onMovieTap: onMovieTap,
              ),
            ],
          ),
        );
    }
  }
}

class _SearchResults extends StatelessWidget {
  final MovieProvider provider;
  final ValueChanged<Movie> onMovieTap;

  const _SearchResults({required this.provider, required this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    switch (provider.searchState) {
      case ViewState.loading:
      case ViewState.idle:
        return const LoadingWidget(message: 'Buscando...');
      case ViewState.error:
        return EmptyWidget(
          icon: Icons.error_outline,
          title: 'Error en la búsqueda',
          subtitle: provider.searchError,
          actionLabel: 'Reintentar',
          onAction: () => provider.search(provider.lastQuery),
        );
      case ViewState.loaded:
        if (provider.searchResults.isEmpty) {
          return EmptyWidget(
            icon: Icons.search_off_rounded,
            title: 'Sin resultados',
            subtitle: 'No encontramos películas para "${provider.lastQuery}".',
          );
        }
        return _MovieGrid(
          movies: provider.searchResults,
          onMovieTap: onMovieTap,
        );
    }
  }
}

class _FilterResults extends StatelessWidget {
  final MovieProvider provider;
  final ValueChanged<Movie> onMovieTap;

  const _FilterResults({required this.provider, required this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    switch (provider.filterState) {
      case ViewState.loading:
      case ViewState.idle:
        return const LoadingWidget(message: 'Aplicando filtros...');
      case ViewState.error:
        return EmptyWidget(
          icon: Icons.error_outline,
          title: 'Error al filtrar',
          subtitle: provider.filterError,
          actionLabel: 'Reintentar',
          onAction: () => provider.applyFilters(
            genreIds: provider.selectedGenreIds,
            minRating: provider.minRating,
          ),
        );
      case ViewState.loaded:
        if (provider.filterResults.isEmpty) {
          return const EmptyWidget(
            icon: Icons.movie_filter_outlined,
            title: 'Sin resultados',
            subtitle: 'No encontramos películas con esos filtros.',
          );
        }
        return _MovieGrid(
          movies: provider.filterResults,
          onMovieTap: onMovieTap,
        );
    }
  }
}

class _MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final ValueChanged<Movie> onMovieTap;

  const _MovieGrid({required this.movies, required this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    // Aim for cards ~150px wide, so wider screens get more columns.
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
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieCard(
          movie: movie,
          width: double.infinity,
          onTap: () => onMovieTap(movie),
        );
      },
    );
  }
}
