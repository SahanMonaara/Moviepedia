import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../providers/movie_provider.dart';

/// It's a list of providers that are used in the app
class AppProviders {
  static final List<SingleChildWidget> _providers = [
    ChangeNotifierProvider(create: (context) => MovieProvider())
  ];

  static get providers => _providers;
}
