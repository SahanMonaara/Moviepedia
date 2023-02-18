import 'package:flutter/material.dart';
import 'package:moviepedia/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'common/app_providers.dart';
import 'common/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'Moviepedia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Colors.black),
        routes: AppRoutes.routes,
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
