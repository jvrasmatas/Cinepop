import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../models/movie.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Movie> _favorites = [];

  /// Unmodifiable view of the current favorites.
  List<Movie> get favorites => List.unmodifiable(_favorites);

  bool get isEmpty => _favorites.isEmpty;

  /// Returns whether [movieId] is currently favorited.
  bool isFavorite(int movieId) => _favorites.any((m) => m.id == movieId);

  /// Loads persisted favorites from local storage. Call once at startup.
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(AppConstants.favoritesStorageKey) ?? [];

    _favorites
      ..clear()
      ..addAll(
        raw.map((s) => Movie.fromJson(json.decode(s) as Map<String, dynamic>)),
      );

    notifyListeners();
  }

  /// Adds [movie] to favorites if not already present.
  Future<void> add(Movie movie) async {
    if (isFavorite(movie.id)) return;
    _favorites.add(movie);
    await _persist();
    notifyListeners();
  }

  /// Removes the movie with [movieId] from favorites.
  Future<void> remove(int movieId) async {
    _favorites.removeWhere((m) => m.id == movieId);
    await _persist();
    notifyListeners();
  }

  /// Convenience toggle used by the favorite button.
  Future<void> toggle(Movie movie) async {
    if (isFavorite(movie.id)) {
      await remove(movie.id);
    } else {
      await add(movie);
    }
  }

  /// Writes the current favorites list back to local storage.
  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _favorites.map((m) => json.encode(m.toJson())).toList();
    await prefs.setStringList(AppConstants.favoritesStorageKey, raw);
  }
}
