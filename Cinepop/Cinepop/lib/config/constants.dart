class AppConstants {
  AppConstants._();

  static const String appName = 'Cinepop';
  static const String appVersion = '1.0.0';

  // --- TMDB API ----------------------------------------------------------
  static const String tmdbApiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: 'b5ede30959c927301896bafd1a40c1e5',
  );

  static const String baseUrl = 'https://api.themoviedb.org/3';

  /// Base URL for images. Append a size and the poster/backdrop path.
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  // Common image sizes offered by TMDB.
  static const String posterSize = 'w500';
  static const String backdropSize = 'w780';
  static const String profileSize = 'w185';

  // --- Endpoints ---------------------------------------------------------
  static const String popularEndpoint = '/movie/popular';
  static const String topRatedEndpoint = '/movie/top_rated';
  static const String upcomingEndpoint = '/movie/upcoming';
  static const String searchEndpoint = '/search/movie';
  static const String discoverEndpoint = '/discover/movie';

  static String movieDetailsEndpoint(int id) => '/movie/$id';
  static String movieCreditsEndpoint(int id) => '/movie/$id/credits';

  // --- Localization / defaults ------------------------------------------
  static const String language = 'es-ES';

  // --- Storage keys ------------------------------------------------------
  static const String favoritesStorageKey = 'cinepop_favorites';

  // --- Developer info (DeveloperScreen) ----------------------------------
  static const String developerName = 'Valeryn Duque y Juan Vrasmatas';
  static const String developerSubject = 'Desarrollo de Aplicaciones Móviles';
  static const String developerUniversity = 'Universidad de Margarita';
  static const String developerDescription =
      'Cinepop es una aplicación móvil para descubrir películas populares, '
      'mejor calificadas y próximos estrenos, con detalles completos y una '
      'lista de favoritos, todo impulsado por la API de The Movie Database.';
}
