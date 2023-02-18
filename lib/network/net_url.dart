/// It contains all the URLs that we will be using in our app
class URL {
  static String serverUrl = "https://api.themoviedb.org/4";

  static String getMovieListUrl = "$serverUrl/list/1";

  static String getMovieDetailsUrl = "$serverUrl/list/{id}";

}
