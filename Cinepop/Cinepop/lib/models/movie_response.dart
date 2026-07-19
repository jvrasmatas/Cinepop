import 'movie.dart';

class MovieResponse {
  final int page;
  final int totalPages;
  final int totalResults;
  final List<Movie> results;

  const MovieResponse({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    required this.results,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'] as List<dynamic>? ?? [];

    return MovieResponse(
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalResults: json['total_results'] as int? ?? 0,
      results: resultsJson
          .map((m) => Movie.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}
