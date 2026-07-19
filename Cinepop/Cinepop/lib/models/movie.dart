import 'genre.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<Genre> genres;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.genres = const [],
  });

  String get year {
    if (releaseDate.isEmpty || releaseDate.length < 4) return '—';
    return releaseDate.substring(0, 4);
  }

  String get formattedRating => voteAverage.toStringAsFixed(1);

  factory Movie.fromJson(Map<String, dynamic> json) {
    final genresJson = json['genres'] as List<dynamic>?;

    return Movie(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Sin título',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] as String? ?? '',
      genres: genresJson != null
          ? genresJson
                .map((g) => Genre.fromJson(g as Map<String, dynamic>))
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genres': genres.map((g) => {'id': g.id, 'name': g.name}).toList(),
    };
  }
}
