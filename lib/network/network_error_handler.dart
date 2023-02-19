import 'package:http/http.dart' as http;
import '../helpers/app_logger.dart';
import 'net_exception.dart';

class NetworkErrorHandler {
  /// It takes a response from the server and returns a `NetException` object if the
  /// response is not a success
  ///
  /// Args:
  ///   response (http): The response object from the http call.
  ///   ignoreCodes (List<int>): List of status codes that you want to ignore.
  ///
  /// Returns:
  ///   A function that takes a response and an optional list of integers.
  static NetException? handleError(http.Response response,
      {List<int>? ignoreCodes}) {
    Log.debug("NetworkErrorHandler  ${response.statusCode}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return null;
    }

    NetException errorMessage;
    try {
      if (response.statusCode == 503) {
        errorMessage = NetException();
        errorMessage.messageId = CommonMessageId.serviceUnavailable;
        errorMessage.message = CommonMessages.serverUnderMaintenance;
      } else if (response.statusCode == 401) {
        errorMessage = NetException();
        errorMessage.messageId = CommonMessageId.unauthorized;
        errorMessage.message = CommonMessages.unauthorizedAccess;
      } else if (response.statusCode == 404) {
        errorMessage = NetException();
        errorMessage.messageId = CommonMessageId.notFound;
        errorMessage.message = CommonMessages.endpointNotFound;
      } else {
        errorMessage = netExceptionFromJson(response.body);
      }
    } catch (e) {
      errorMessage = NetException();
      errorMessage.messageId = CommonMessageId.somethingWentWrong;
      errorMessage.message = CommonMessages.somethingWentWrong;
    }

    Log.err("err ${errorMessage.message}");
    return errorMessage;
  }
}
