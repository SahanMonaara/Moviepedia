/// It contains all the URLs that we will be using in our app
class URL {
  static const String serverUrl = "https://api.themoviedb.org/4";

  static const String getMovieListUrl = "$serverUrl/list/1";

  static const String getMovieDetailsUrl = "$serverUrl/list/{id}";
}
