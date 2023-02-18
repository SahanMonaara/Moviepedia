import 'dart:convert';
import 'package:moviepedia/models/movies.dart';

import '../helpers/app_logger.dart';
import '../network/net_exception.dart';
import '../network/net.dart';
import '../network/net_result.dart';
import '../network/net_url.dart';

class MovieService {
  static final MovieService _singleton = MovieService._internal();
  static const String MAX_RESULTS_PER_PAGE = "20";

  factory MovieService() {
    return _singleton;
  }

  MovieService._internal();


  Future<Result> fetchMoviesList() async {
    Result result = Result();
    try {
      var net = Net(
        url: URL.getMovieListUrl,
        method: NetMethod.GET,
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
          message: CommonMessages.ENDPOINT_NOT_FOUND,
          messageId: CommonMessageId.UNAUTHORIZED,
          code: ExceptionCode.CODE_000);
      return result;
    }
  }


  Future<Result> fetchMovieDetails(String id) async {
    Result result = Result();
    try {
      var net = Net(
          url: URL.getMovieDetailsUrl,
          method: NetMethod.GET,
          pathParam: {'{id}': id});

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
          message: CommonMessages.ENDPOINT_NOT_FOUND,
          messageId: CommonMessageId.UNAUTHORIZED,
          code: ExceptionCode.CODE_000);
      return result;
    }
  }
}
