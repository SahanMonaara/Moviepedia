// ignore_for_file: constant_identifier_names

import 'dart:convert';

/// It contains all the common messages that are used in the app
class CommonMessages {
  static const String EMPTY_DATA = "No data found";
  static const String SERVER_UNDER_MAINTENANCE =
      "Server is currently under maintenance";
  static const String UNAUTHORIZED_ACCESS = "Unauthorized access";
  static const String ENDPOINT_NOT_FOUND = "Something went wrong";
  static const String WENT_WRONG = "Something went wrong";
}

/// `ExceptionCode` is a class that contains constants for exception codes
class ExceptionCode {
  static const int CODE_400 = 400;
  static const int CODE_000 = 000;
}

/// It's a class that contains static constants that represent the error messages
/// that are common to all the API calls
class CommonMessageId {
  static const String SERVICE_UNAVAILABLE = "SERVICE_UNAVAILABLE";
  static const String UNAUTHORIZED = "UNAUTHORIZED";
  static const String NOT_FOUND = "NOT_FOUND";
  static const String SOMETHING_WENT_WRONG = "SOMETHING_WENT_WRONG";
}

/// It takes a JSON string and returns a Dart object
///
/// Args:
///   str (String): The JSON string to be decoded.
NetException netExceptionFromJson(String str) =>
    NetException.fromJson(json.decode(str));

/// `netExceptionToJson` takes a `NetException` object and returns a `String` that
/// is the JSON representation of the `NetException` object
///
/// Args:
///   data (NetException): The data to be converted to JSON.
String netExceptionToJson(NetException data) => json.encode(data.toJson());

/// A class that is used to parse the error response from the server.
class NetException {
  String? error;
  String? message;
  String? messageId;
  int? code;

  NetException({
    this.error,
    this.message,
    this.messageId,
    this.code,
  });

  factory NetException.fromJson(Map<String, dynamic> json) => NetException(
        error: json["error"],
        messageId: json["message_id"],
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message_id": messageId,
        "message": message,
        "code": code,
      };
}
