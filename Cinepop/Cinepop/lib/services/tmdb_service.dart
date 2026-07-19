import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../config/constants.dart';
import '../models/credits_response.dart';
import '../models/movie.dart';
import '../models/movie_response.dart';

class TmdbException implements Exception {
  final String message;
  const TmdbException(this.message);

  @override
  String toString() => message;
}

class TmdbService {
  final http.Client _client;
  final Random _random;

  TmdbService({http.Client? client, Random? random})
    : _client = client ?? http.Client(),
      _random = random ?? Random();

  Uri _buildUri(String endpoint, [Map<String, String>? queryParameters]) {
    return Uri.parse('${AppConstants.baseUrl}$endpoint').replace(
      queryParameters: {
        'api_key': AppConstants.tmdbApiKey,
        'language': AppConstants.language,
        ...?queryParameters,
      },
    );
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 15));

      switch (response.statusCode) {
        case 200:
          return json.decode(response.body) as Map<String, dynamic>;
        case 401:
          throw const TmdbException(
            'Clave de API inválida. Verifica tu configuración de TMDB.',
          );
        case 404:
          throw const TmdbException('No se encontró el recurso solicitado.');
        default:
          throw TmdbException(
            'Error del servidor (${response.statusCode}). Intenta más tarde.',
          );
      }
    } on SocketException {
      throw const TmdbException(
        'Sin conexión a internet. Revisa tu red e intenta de nuevo.',
      );
    } on HttpException {
      throw const TmdbException('No se pudo completar la solicitud.');
    } on FormatException {
      throw const TmdbException('Respuesta inesperada del servidor.');
    }
  }

  // --- Movie lists -------------------------------------------------------

  Future<List<Movie>> getPopular({int page = 1}) =>
      _getMovieList(AppConstants.popularEndpoint, page);

  /// Fetches top rated movies.
  Future<List<Movie>> getTopRated({int page = 1}) =>
      _getMovieList(AppConstants.topRatedEndpoint, page);

  /// Fetches upcoming movies.
  Future<List<Movie>> getUpcoming({int page = 1}) =>
      _getMovieList(AppConstants.upcomingEndpoint, page);

  Future<List<Movie>> _getMovieList(String endpoint, int page) async {
    final uri = _buildUri(endpoint, {'page': '$page'});
    final data = await _get(uri);
    return MovieResponse.fromJson(data).results;
  }

  // --- Search ------------------------------------------------------------

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return [];
    final uri = _buildUri(AppConstants.searchEndpoint, {
      'query': query,
      'page': '$page',
      'include_adult': 'false',
    });
    final data = await _get(uri);
    return MovieResponse.fromJson(data).results;
  }

  // --- Details & credits -------------------------------------------------

  Future<List<Movie>> getFilteredMovies({
    Set<int> genreIds = const {},
    double minRating = 0,
    int page = 1,
  }) async {
    final uri = _buildUri(AppConstants.discoverEndpoint, {
      'page': '$page',
      'sort_by': 'popularity.desc',
      if (genreIds.isNotEmpty) 'with_genres': genreIds.join(','),
      if (minRating > 0) 'vote_average.gte': '$minRating',
      'vote_count.gte': '50',
    });
    final data = await _get(uri);
    return MovieResponse.fromJson(data).results;
  }

  Future<Movie> getRandomMovie() async {
    final page = _random.nextInt(500) + 1;
    final uri = _buildUri(AppConstants.discoverEndpoint, {
      'page': '$page',
      'sort_by': 'popularity.desc',
      'vote_count.gte': '100',
    });
    final data = await _get(uri);
    final results = MovieResponse.fromJson(data).results;
    if (results.isEmpty) {
      throw const TmdbException('No se encontró ninguna película.');
    }
    return results[_random.nextInt(results.length)];
  }

  Future<Movie> getMovieDetails(int id) async {
    final uri = _buildUri(AppConstants.movieDetailsEndpoint(id));
    final data = await _get(uri);
    return Movie.fromJson(data);
  }

  Future<CreditsResponse> getMovieCredits(int id) async {
    final uri = _buildUri(AppConstants.movieCreditsEndpoint(id));
    final data = await _get(uri);
    return CreditsResponse.fromJson(data);
  }

  void dispose() => _client.close();
}
