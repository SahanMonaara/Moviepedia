import 'dart:convert';
import 'package:flutter/material.dart';
import '../common/app_const.dart';
import '../helpers/app_logger.dart';
import '../helpers/local_storage.dart';
import '../models/movies.dart';
import '../network/net_result.dart';
import '../services/movie_service.dart';

/// It fetches the movies list from the API, stores it in the movies variable, and
/// then sorts the movies list and stores the top 5 movies in the topRatedMovieList
/// and the new 5 movies in the newMovieList
class MovieProvider with ChangeNotifier {
  bool isDataLoading = false;
  bool isDetailDataLoading = false;
  Movies? movies;
  List<SingleMovie> topRatedMovieList = [];
  List<SingleMovie> newMovieList = [];
  List<SingleMovie> favouriteList = [];
  List<SingleMovie> searchMovieList = [];
  Result? result;

  /// It changes the value of isDataLoading to the value of the parameter status and
  /// then notifies all the listeners.
  ///
  /// Args:
  ///   status (bool): The status of the data loading.
  changeDataLoadingStatus(bool status) {
    isDataLoading = status;
    notifyListeners();
  }

  /// It fetches the movies list from the API and stores it in the movies variable.
  ///
  /// Returns:
  ///   Result object
  Future<Result> getMoviesList() async {
    result = await MovieService().fetchMoviesList();
    if (result!.exception == null) {
      movies = result!.result;
      getTopRatedMovies(movies);
      getNewMovies(movies);
      Log.debug("------movies length- ${movies!.results!.length}");
    }
    isDataLoading = false;
    notifyListeners();
    return result!;
  }

  /// If the movie is already in the favourite list, remove it from the list, else
  /// add it to the list
  ///
  /// Args:
  ///   singleMovie (SingleMovie): The movie that is tapped on.
  tapOnFavourite(SingleMovie? singleMovie) {
    bool isAlreadyFavourite =
        favouriteList.any((element) => element == singleMovie);
    if (isAlreadyFavourite) {
      favouriteList.remove(singleMovie);
    } else {
      favouriteList.add(singleMovie!);
    }
    saveFavouriteListInLocal();
    Log.debug('--favourite list--$favouriteList');
    notifyListeners();
  }

  /// It checks if the movie is already in the favourite list
  ///
  /// Args:
  ///   singleMovie (SingleMovie): The movie that is being checked for favourite
  /// status.
  ///
  /// Returns:
  ///   A bool value.
  checkFavouriteStatus(SingleMovie? singleMovie) {
    bool isAlreadyFavourite =
        favouriteList.any((element) => element == singleMovie);
    if (isAlreadyFavourite) {
      return true;
    } else {
      return false;
    }
  }

  /// It takes the favouriteList and converts it to a JSON string and saves it in
  /// the local storage
  saveFavouriteListInLocal() {
    String jsonList = json.encode({AppConst.favouriteList: favouriteList});
    Log.debug("saved favourite list--$jsonList");
    LocalStorage().saveFavouriteList(jsonList);
  }

  /// It fetches the favourite list from the local storage and updates the favourite
  /// list in the model
  fetchFavouriteListInLocal() async {
    String? jsonList = await LocalStorage().getFavouriteList();

    if (jsonList != null) {
      var data = json.decode(jsonList);
      Log.debug(" fetched from local--${data[AppConst.favouriteList]}");
      for (var element in (data[AppConst.favouriteList])) {
        favouriteList.add(SingleMovie.fromJson(element));
      }
      Log.debug("initial favourite list fetched from local--$favouriteList");
      notifyListeners();
    }
  }

  /// It takes a string as an argument, clears the searchMovieList, loops through
  /// the movies list, and adds the movie to the searchMovieList if the movie title
  /// contains the query string
  ///
  /// Args:
  ///   query (String): The search query that the user has entered.
  searchMovies(String query) {
    searchMovieList.clear();
    for (var item in movies!.results!) {
      if (item.title!.toUpperCase().contains(query.toUpperCase())) {
        searchMovieList.add(item);
      }
    }
    notifyListeners();
  }

  /// It takes the movies object and sorts it by the vote average. Then it adds the
  /// top 5 movies to the topRatedMovieList.
  ///
  /// Args:
  ///   movies (Movies): The movies object that is returned from the API call.
  getTopRatedMovies(Movies? movies) {
    topRatedMovieList.clear();
    movies!.results!.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    for (int i = 0; i < 5; i++) {
      topRatedMovieList.add(movies.results![i]);
    }
    notifyListeners();
  }

  /// It takes the movies object and sorts it by release date. Then it adds the
  /// first 5 movies to the newMovieList.
  ///
  /// Args:
  ///   movies (Movies): The movies object that is returned from the API call.
  getNewMovies(Movies? movies) {
    newMovieList.clear();
    movies!.results!.sort((a, b) => b.releaseDate!.compareTo(a.releaseDate!));
    for (int i = 0; i < 5; i++) {
      newMovieList.add(movies.results![i]);
    }
    notifyListeners();
  }
}
