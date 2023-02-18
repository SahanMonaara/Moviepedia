import 'dart:convert';
import 'package:flutter/material.dart';
import '../common/app_const.dart';
import '../helpers/app_logger.dart';
import '../helpers/local_storage.dart';
import '../models/movies.dart';
import '../network/net_result.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  bool isDataLoading = false;
  bool isDetailDataLoading = false;
  Movies? movies;
  SingleMovie? currentMovie;
  List<SingleMovie> topRatedMovieList = [];
  List<SingleMovie> newMovieList = [];
  List<SingleMovie> favouriteList = [];
  List<SingleMovie> searchMovieList = [];

  /// It changes the value of isDataLoading to the value of the parameter status and
  /// then notifies all the listeners.
  ///
  /// Args:
  ///   status (bool): The status of the data loading.
  changeDataLoadingStatus(bool status) {
    isDataLoading = status;
    notifyListeners();
  }

  /// It changes the loading status of the detail data.
  ///
  /// Args:
  ///   status (bool): The status of the loading.
  changeDetailDataLoadingStatus(bool status) {
    isDetailDataLoading = status;
    notifyListeners();
  }


  Future<Result> getMoviesList() async {
    Result result = await MovieService().fetchMoviesList();
    if (result.exception == null) {
      movies = result.result;
      getTopRatedMovies(movies);
      getNewMovies(movies);
      Log.debug("------movies length- ${movies!.results!.length}");
      isDataLoading = false;
    }
    notifyListeners();
    return result;
  }


  Future<Result> getMovieDetails(String id) async {
    Result result = await MovieService().fetchMovieDetails(id);
    if (result.exception == null) {
      isDetailDataLoading = false;
    }
    currentMovie = result.result;
    notifyListeners();
    return result;
  }


  tapOnFavourite(SingleMovie? singleMovie) {
    bool isAlreadyFavourite = favouriteList.any((element) => element == singleMovie);
    if (isAlreadyFavourite) {
      favouriteList.remove(singleMovie);
    } else {
      favouriteList.add(singleMovie!);
    }
    saveFavouriteListInLocal();
    Log.debug('--favourite list--$favouriteList');
    notifyListeners();
  }

  bool checkFavouriteStatus(SingleMovie? singleMovie) {
    bool isAlreadyFavourite = favouriteList.any((element) => element == singleMovie);
    if (isAlreadyFavourite) {
      return true;
    } else {
      return false;
    }
  }


  saveFavouriteListInLocal() {
    String jsonList = json.encode({AppConst.favouriteList: favouriteList});
    Log.debug("saved favourite list--$jsonList");
    LocalStorage().saveFavouriteList(jsonList);
  }


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

  searchMovies(String query){
    searchMovieList.clear();
    for (var item in movies!.results!) {
      if(item.title!.toUpperCase().contains(query.toUpperCase())) {
        searchMovieList.add(item);
      }
    }
    notifyListeners();
  }

  getTopRatedMovies(Movies? movies) {
    topRatedMovieList.clear();
    movies!.results!.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    for(int i =0;i<5;i++){
      topRatedMovieList.add(movies.results![i]);
    }
    notifyListeners();
  }
  getNewMovies(Movies? movies) {
    newMovieList.clear();
    movies!.results!.sort((a, b) => b.releaseDate!.compareTo(a.releaseDate!));
    for(int i =0;i<5;i++){
      newMovieList.add(movies.results![i]);
    }
    notifyListeners();
  }
}
