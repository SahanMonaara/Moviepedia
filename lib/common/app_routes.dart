import 'package:flutter/material.dart';
import '../screens/movie_details_screen.dart';
import '../screens/movie_list_screen.dart';
import '../screens/splash_screen.dart';

/// It's a map of route names to widget builders
class AppRoutes {
  static final Map<String, WidgetBuilder> _routes = {
    SplashScreen.routeName: (ctx) => const SplashScreen(),
    MoviesListScreen.routeName: (ctx) => const MoviesListScreen(),
    MovieDetailScreen.routeName: (ctx) => const MovieDetailScreen()
  };

  static get routes => _routes;
}
