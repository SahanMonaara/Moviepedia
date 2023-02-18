import 'net_exception.dart';
import 'net.dart';

/// It's a class that holds the result of a network request
class Result<Type> {
  Type? result;
  NetException? exception;
  int? statusCode;
  Net? net;
  bool isFromCache = false;
  String? token;

  bool isSuccess() {
    if (exception == null) return true;
    return false;
  }
}
