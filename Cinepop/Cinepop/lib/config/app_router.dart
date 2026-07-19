import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../screens/details_screen.dart';
import '../screens/developer_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String home = '/home';
  static const String details = '/details';
  static const String favorites = '/favorites';
  static const String developer = '/developer';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _build(const SplashScreen(), settings);
      case home:
        return _build(const HomeScreen(), settings);
      case favorites:
        return _build(const FavoritesScreen(), settings);
      case developer:
        return _build(const DeveloperScreen(), settings);
      case details:
        // The details screen expects a Movie passed as an argument.
        final movie = settings.arguments as Movie;
        return _build(DetailsScreen(movie: movie), settings);
      default:
        return _build(
          const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
          settings,
        );
    }
  }

  static MaterialPageRoute<dynamic> _build(
    Widget child,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}
