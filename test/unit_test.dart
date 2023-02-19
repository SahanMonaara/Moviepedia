import 'package:flutter_test/flutter_test.dart';
import 'package:moviepedia/models/movies.dart';
import 'package:moviepedia/services/movie_service.dart';

void main() {
  test("Fetching Movies", () async {
    bool done = false;
    var data = (await MovieService().fetchMoviesList()).result;
    if (data.results != null) {
      done = true;
    }
    expect(done, true);
  });

  test("Displaying Data", () async {
    Movies movies = (await MovieService().fetchMoviesList()).result;
    for (int i = 0; i < movies.results!.length; i++) {
      expect(movies.results![i].title!.isNotEmpty, true);
      expect(movies.results![i].posterPath!.isNotEmpty, true);
      expect(movies.results![i].releaseDate!.isNotEmpty, true);
      expect(movies.results![i].overview!.isNotEmpty, true);
      expect(movies.results![i].originalLanguage!.isNotEmpty, true);
    }
  });
}
