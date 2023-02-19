import 'package:moviepedia/common/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _singleton = LocalStorage._internal();

  /// > The function returns the singleton instance of the class
  ///
  /// Returns:
  ///   The singleton instance of the class.
  factory LocalStorage() {
    return _singleton;
  }

  LocalStorage._internal();


  /// It gets the favourite list from the shared preferences.
  ///
  /// Returns:
  ///   A Future<String?>
  Future<String?> getFavouriteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConst.favouriteList);
  }


  /// It saves the favourite list to the shared preferences.
  ///
  /// Args:
  ///   list (String): The list of favourite items.
  Future<void> saveFavouriteList(String list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConst.favouriteList, list);
  }
}
