import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_router.dart';
import 'config/app_theme.dart';
import 'config/constants.dart';
import 'providers/favorite_provider.dart';
import 'providers/movie_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CinepopApp());
}

class CinepopApp extends StatelessWidget {
  const CinepopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        // Load persisted favorites as soon as the provider is created.
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider()..loadFavorites(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
