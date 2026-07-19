import 'package:flutter/foundation.dart';

import '../models/movie.dart';
import '../services/tmdb_service.dart';

enum ViewState { idle, loading, loaded, error }

class MovieProvider extends ChangeNotifier {
  final TmdbService _service;

  MovieProvider({TmdbService? service}) : _service = service ?? TmdbService();

  List<Movie> _popular = [];
  List<Movie> _topRated = [];
  List<Movie> _upcoming = [];

  List<Movie> get popular => _popular;
  List<Movie> get topRated => _topRated;
  List<Movie> get upcoming => _upcoming;

  ViewState _homeState = ViewState.idle;
  ViewState get homeState => _homeState;

  String _homeError = '';
  String get homeError => _homeError;

  List<Movie> _searchResults = [];
  List<Movie> get searchResults => _searchResults;

  ViewState _searchState = ViewState.idle;
  ViewState get searchState => _searchState;

  String _searchError = '';
  String get searchError => _searchError;

  String _lastQuery = '';
  String get lastQuery => _lastQuery;

  bool get isSearching => _lastQuery.trim().isNotEmpty;

  List<Movie> _filterResults = [];
  List<Movie> get filterResults => _filterResults;

  ViewState _filterState = ViewState.idle;
  ViewState get filterState => _filterState;

  String _filterError = '';
  String get filterError => _filterError;

  Set<int> _selectedGenreIds = {};
  Set<int> get selectedGenreIds => _selectedGenreIds;

  double _minRating = 0;
  double get minRating => _minRating;

  bool get isFiltering =>
      _selectedGenreIds.isNotEmpty || _minRating > 0;

  Future<void> applyFilters({
    required Set<int> genreIds,
    required double minRating,
  }) async {
    _selectedGenreIds = genreIds;
    _minRating = minRating;

    if (!isFiltering) {
      clearFilters();
      return;
    }

    _filterState = ViewState.loading;
    _filterError = '';
    notifyListeners();

    try {
      _filterResults = await _service.getFilteredMovies(
        genreIds: _selectedGenreIds,
        minRating: _minRating,
      );
      _filterState = ViewState.loaded;
    } on TmdbException catch (e) {
      _filterError = e.message;
      _filterState = ViewState.error;
    } catch (_) {
      _filterError = 'Ocurrió un error inesperado.';
      _filterState = ViewState.error;
    }

    notifyListeners();
  }

  void clearFilters() {
    _selectedGenreIds = {};
    _minRating = 0;
    _filterResults = [];
    _filterState = ViewState.idle;
    _filterError = '';
    notifyListeners();
  }

  Future<void> loadHome() async {
    _homeState = ViewState.loading;
    _homeError = '';
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getPopular(),
        _service.getTopRated(),
        _service.getUpcoming(),
      ]);

      _popular = results[0];
      _topRated = results[1];
      _upcoming = results[2];
      _homeState = ViewState.loaded;
    } on TmdbException catch (e) {
      _homeError = e.message;
      _homeState = ViewState.error;
    } catch (_) {
      _homeError = 'Ocurrió un error inesperado.';
      _homeState = ViewState.error;
    }

    notifyListeners();
  }

  Future<void> search(String query) async {
    _lastQuery = query;

    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    _searchState = ViewState.loading;
    _searchError = '';
    notifyListeners();

    try {
      _searchResults = await _service.searchMovies(query);
      _searchState = ViewState.loaded;
    } on TmdbException catch (e) {
      _searchError = e.message;
      _searchState = ViewState.error;
    } catch (_) {
      _searchError = 'Ocurrió un error inesperado.';
      _searchState = ViewState.error;
    }

    notifyListeners();
  }

  Future<Movie> getRandomMovie() => _service.getRandomMovie();

  void clearSearch() {
    _lastQuery = '';
    _searchResults = [];
    _searchState = ViewState.idle;
    _searchError = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
