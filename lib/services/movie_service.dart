import 'dart:convert';
import 'package:moviepedia/models/movies.dart';

import '../helpers/app_logger.dart';
import '../network/net_exception.dart';
import '../network/net.dart';
import '../network/net_result.dart';
import '../network/net_url.dart';

class MovieService {
  static final MovieService _singleton = MovieService._internal();

  factory MovieService() {
    return _singleton;
  }

  MovieService._internal();


  /// It fetches the list of movies from the server.
  ///
  /// Returns:
  ///   Result object
  Future<Result> fetchMoviesList() async {
    Result result = Result();
    try {
      var net = Net(
        url: URL.getMovieListUrl,
        method: NetMethod.get,
      );

      result = await net.perform();
      Log.debug("result is **** ${result.result}");

      if (result.exception == null && result.result != "") {
        var data = json.decode(result.result);
        result.result = Movies.fromJson(data);
      }
      return result;
    } catch (err) {
      Log.err("$err");
      result.exception = NetException(
          message: CommonMessages.endpointNotFound,
          messageId: CommonMessageId.unauthorized,
          code: ExceptionCode.code000);
      return result;
    }
  }
}
