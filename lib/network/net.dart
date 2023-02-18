// ignore_for_file: non_constant_identifier_names
// ignore: constant_identifier_names
import 'dart:convert';
import 'package:moviepedia/common/app_const.dart';

import '../helpers/app_logger.dart';
import 'net_exception.dart';
import 'net_result.dart';
import 'package:http/http.dart' as http;
import 'network_error_handler.dart';

// ignore: constant_identifier_names
enum NetMethod { GET, POST, DELETE, PUT, MULTIPART }

class Net {
  String url;
  Map<String, String>? queryParam;
  Map<String, String>? pathParam;
  Map<String, String>? fields;
  Map<String, String>? imagePathList;
  Map<String, String>? headers;
  String test;
  dynamic body;
  NetMethod method;
  bool excludeToken;
  final int _retryMaxCount = 3;
  int _retryCount = 0;
  bool isRetryEnable = false;

  Net({
    required this.url,
    required this.method,
    this.queryParam,
    this.pathParam,
    this.fields,
    this.imagePathList,
    this.headers,
    this.test = "",
    this.excludeToken = false,
  });

  Future<Result> perform() async {
    http.Response response;
    switch (method) {
      case NetMethod.GET:
        response = await get();
        break;
      case NetMethod.POST:
        response = await post();
        break;
      case NetMethod.PUT:
        response = await put();
        break;
      case NetMethod.DELETE:
        response = await delete();
        break;
      case NetMethod.MULTIPART:
        response = await multiPart();
        break;
    }

    return await isOk(response);
  }

  /// It makes a GET request to the server.
  ///
  /// Returns:
  ///   A Future<http.Response>
  Future<http.Response> get() async {
    Log.debug("request - GET | url - $url | ");
    String url_ =
        "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";

    Uri uri = Uri.parse(url_);
    var headers = await getHeadersForRequest();
    Log.debug('------headers-----${headers.toString()}');

    Log.debug("request - GET | url - $uri | headers - ${headers.toString()}");
    final response = await http.get(uri, headers: headers);

    Log.debug(
        "response - GET | url - $uri | body - ${response.body}| headers - ${response.headers.toString()}");
    return response;
  }

  /// It makes a POST request to the given url with the given body and query
  /// parameters.
  ///
  /// Returns:
  ///   A Future<http.Response>
  Future<http.Response> post() async {
    String url_ =
        "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";

    Uri uri = Uri.parse(url_);

    var headers = await getHeadersForRequest();
    Log.debug("request - POST | url - $url_ | headers - ${headers.toString()}");

    final response = await http.post(
      uri,
      headers: headers,
      body: body == null ? "" : jsonEncode(body),
    );

    Log.debug(
        "response - POST | url - $url_ | body - ${response.body}| headers - ${response.headers.toString()}");

    return response;
  }

  /// It makes a PUT request to the server.
  ///
  /// Returns:
  ///   A Future<http.Response>
  Future<http.Response> put() async {
    Log.debug("request - PUT | url - $url | ");
    String url_ =
        "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";
    Uri uri = Uri.parse(url_);
    var headers = await getHeadersForRequest();

    Log.debug("request - PUT | url - $url_ | headers - ${headers.toString()}");
    final response = await http.put(
      uri,
      headers: headers,
      body: body == null ? "" : jsonEncode(body),
    );
    Log.debug(
        "response - PUT | url - $url_ | body - ${response.body}| headers - ${response.headers.toString()}");
    return response;
  }

  /// It makes a DELETE request to the server.
  ///
  /// Returns:
  ///   A Future<http.Response>
  Future<http.Response> delete() async {
    String url_ =
        "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";
    Uri uri = Uri.parse(url_);

    var headers = await getHeadersForRequest();

    Log.debug(
        "request - DELETE | url - $url_ | headers - ${headers.toString()}");

    final response = await http.delete(
      uri,
      headers: headers,
      body: body == null ? "" : jsonEncode(body),
    );

    Log.debug(
        "response - DELETE | url - $url_ | body - ${response.body}| headers - ${response.headers.toString()}");
    return response;
  }

  /// A function that makes a multipart request to the server.
  ///
  /// Returns:
  ///   A Future<http.Response>
  Future<http.Response> multiPart() async {
    List<http.MultipartFile> multipartFiles = [];

    String url_ =
        "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";
    Uri uri = Uri.parse(url_);

    var headers = await getHeadersForRequest();

    Log.debug(
        "request - MULTIPART | url - $url_ | headers - ${headers.toString()}");

    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    fields ??= {};
    fields!.forEach((key, value) {
      request.fields[key] = value;
    });
    imagePathList ??= {};
    List<dynamic> data = imagePathList!.entries.cast().toList();

    for (var i = 0; i < data.length; i++) {
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('${data[i].key}', data[i].value);

      multipartFiles.add(multipartFile);
    }

    request.files.addAll(multipartFiles);

    var response = await request.send();

    var body = await response.stream.bytesToString();
    Log.debug("http api multipart- ${response.statusCode}$body");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Log.debug(
          '------ server error: statusCode - ${response.statusCode} -----');
    }

    http.Response res = http.Response(body, response.statusCode);
    return res;
  }

  /// * Iterate over the entries in the map, and print each key and value
  ///
  /// Args:
  ///   map (Map): The map to print.
  printMap(Map map) {
    for (final e in map.entries) {
      Log.debug('${e.key} = ${e.value}');
    }
  }

  /// If the headers map is null, initialize it to an empty map, then add the
  /// Content-Type and Accept headers to it
  ///
  /// Returns:
  ///   A map of headers.
  Future<Map<String, String>> getHeadersForRequest() async {
    headers ??= {};
    headers!.putIfAbsent("Content-Type", () => "application/json");
    headers!.putIfAbsent("Authorization", () =>  AppConst.Token);
    headers!.putIfAbsent("Accept", () => "application/json");
    return headers!;
  }

  /// It takes a url and replaces the path parameters with the values provided in
  /// the pathParam map
  ///
  /// Args:
  ///   netUrl (String): The url that you want to replace the path parameters with.
  ///
  /// Returns:
  ///   The url with the path parameters replaced.
  String getPathParameters(String netUrl) {
    String url = netUrl;
    pathParam ??= {};
    if (pathParam!.isNotEmpty) {
      pathParam!.forEach((key, value) {
        url = url.replaceFirst(key, value);
        Log.debug("$key path param replaced");
      });
    }
    return url;
  }

  /// If the response is not ok, then check if the retry is enabled, if it is, then
  /// check if the retry count is less than the max retry count, if it is, then
  /// retry again, otherwise, return the error
  ///
  /// Args:
  ///   response (http): The response of the request
  ///
  /// Returns:
  ///   A Future<Result>
  Future<Result> isOk(http.Response response) async {
    Result result = Result();
    result.statusCode = response.statusCode;
    result.net = this;
    result.token = response.headers['authorization'];

    NetException? netException = NetworkErrorHandler.handleError(response);
    if (netException != null) {
      Log.err("error found");
      if (!isRetryEnable) {
        try {
          Log.err("network error ${response.statusCode} recorded");
        } catch (err) {
          Log.err("network error ${response.statusCode} recorded");
        }
        Log.debug("retry disabled!");
        result.exception = netException;
        return result;
      }
      if (_retryCount >= _retryMaxCount) {
        try {
          Log.err("network error ${netException.code} recorded");
        } catch (err) {
          Log.err("network error ${response.statusCode} recorded");
        }
        Log.err("retry failed!");
        result.exception = netException;
        return result;
      }

      _retryCount++;
      Log.debug("retry again.. $_retryCount time");
      return await result.net!.perform();
    }

    result.result = response.body;
    return result;
  }

  /// > It takes a url, gets the path parameters, and then adds the query parameters
  /// to the end of the url
  ///
  /// Returns:
  ///   A Future<String>
  Future<String> processUrl() async {
    return "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";
  }
}
