import 'dart:convert';

/// It contains all the common messages that are used in the app
class CommonMessages {
  static const String emptyData = "No data found";
  static const String serverUnderMaintenance =
      "Server is currently under maintenance";
  static const String unauthorizedAccess = "Unauthorized access";
  static const String endpointNotFound = "Something went wrong";
  static const String somethingWentWrong = "Something went wrong";
}

/// `ExceptionCode` is a class that contains constants for exception codes
class ExceptionCode {
  static const int code400 = 400;
  static const int code000 = 000;
}

/// It's a class that contains static constants that represent the error messages
/// that are common to all the API calls
class CommonMessageId {
  static const String serviceUnavailable = "SERVICE_UNAVAILABLE";
  static const String unauthorized = "UNAUTHORIZED";
  static const String notFound = "NOT_FOUND";
  static const String somethingWentWrong = "SOMETHING_WENT_WRONG";
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
