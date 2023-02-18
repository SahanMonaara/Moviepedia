import 'package:url_launcher/url_launcher.dart';

import 'app_logger.dart';

class Utils {
  /// It launches a url in the browser.
  ///
  /// Args:
  ///   urlLink (String): The URL to be opened.
  static Future<void> launchWebUrl(String urlLink) async {
    try {
      Uri url = Uri.parse(urlLink);
      Log.debug("launchUrl : $url");

      if (!await launchUrl(url)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Log.debug("launchUrl error $e");
    }
  }
}
