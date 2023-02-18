// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:moviepedia/models/movies.dart';
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

  /// > Get the string value of the key 'FAVOURITE_LIST' from the shared preferences
  ///
  /// Returns:
  ///   A Future<String?>
  Future<String?> getFavouriteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('FAVOURITE_LIST');
  }

  /// It saves the favourite list to the local storage.
  ///
  /// Args:
  ///   list (String): The list of favourite items.
  Future<void> saveFavouriteList(String list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('FAVOURITE_LIST', list);
  }
}
