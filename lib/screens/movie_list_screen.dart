import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:moviepedia/common/custom_text_styles.dart';
import 'package:moviepedia/models/movies.dart';
import 'package:moviepedia/screens/widgets/background.dart';
import 'package:moviepedia/screens/widgets/movie_banner.dart';
import 'package:moviepedia/screens/widgets/movie_tile.dart';
import 'package:provider/provider.dart';
import 'package:moviepedia/common/app_colors.dart';
import 'package:moviepedia/providers/movie_provider.dart';
import 'package:moviepedia/screens/movie_details_screen.dart';

import '../common/app_assets.dart';
import '../common/app_const.dart';
import '../shimmers/card_shimmer.dart';

class MoviesListScreen extends StatefulWidget {
  static const routeName = '/movies-list-screen';

  const MoviesListScreen({Key? key}) : super(key: key);

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  bool isDataLoading = false;
  final ScrollController _topRatedMovieScrollController = ScrollController();
  final ScrollController _favouriteMovieScrollController = ScrollController();
  final ScrollController _newMovieScrollController = ScrollController();
  final ScrollController _allMoviesScrollController = ScrollController();
  final ScrollController _searchedMovieController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  /// It calls the getMoviesList() function from the MovieProvider class and changes
  /// the dataLoadingStatus to true.
  getMoviesList() async {
    Provider.of<MovieProvider>(context, listen: false)
        .changeDataLoadingStatus(true);
    await Provider.of<MovieProvider>(context, listen: false).getMoviesList();
  }

  /// It refreshes the list of Movies.
  Future<void> onRefresh() async {
    await getMoviesList();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Consumer<MovieProvider>(builder: (context, movieProvider, _) {
            if (movieProvider.isDataLoading) {
              return const Padding(
                  padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
                  child: Center(child: TripCardShimmer()));
            }
            return Stack(
              children: [
                const Background(),
                Column(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 35,
                        child: Image.asset(
                          AppAssets.logo,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    movieProvider.result!.exception != null
                        ? SizedBox(
                            height: screenHeight / 1.5,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: screenHeight / 15,
                                    color: AppColors.red,
                                  ),
                                  Text(
                                    movieProvider.result!.exception!.message!,
                                    style: CustomTextStyles.titleStyle(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : (movieProvider.movies == null)
                            ? const Center(
                                child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text('No data'),
                              ))
                            : Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Container(
                                        width: screenWidth,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border: GradientBoxBorder(
                                              gradient: LinearGradient(colors: [
                                            AppColors.secondary,
                                            AppColors.secondary,
                                          ])),
                                        ),
                                        child: TextFormField(
                                            focusNode: focusNode,
                                            controller: searchController,
                                            style: const TextStyle(
                                                color: Colors.white),
                                            onChanged: (value) {
                                              Provider.of<MovieProvider>(
                                                      context,
                                                      listen: false)
                                                  .searchMovies(value);
                                              value.isEmpty
                                                  ? focusNode.unfocus()
                                                  : null;
                                            },
                                            decoration: const InputDecoration(
                                              icon: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              hintText: "Type title to search",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                              ),
                                              disabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    searchController.text.isNotEmpty
                                        ? Expanded(
                                            child: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: getCarousal(
                                                    context,
                                                    screenHeight,
                                                    movieProvider,
                                                    Provider.of<MovieProvider>(
                                                                context)
                                                            .searchMovieList
                                                            .isNotEmpty
                                                        ? """ Search results for "${searchController.text}" """
                                                        : """ There are no results for "${searchController.text}" """,
                                                    _searchedMovieController,
                                                    AppConst.searchedList)),
                                          ))
                                        : Expanded(
                                            child: SingleChildScrollView(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Visibility(
                                                        visible: Provider.of<
                                                                    MovieProvider>(
                                                                context,
                                                                listen: false)
                                                            .favouriteList
                                                            .isNotEmpty,
                                                        child: getFavouriteMovies(
                                                            context,
                                                            movieProvider
                                                                .favouriteList)),
                                                    getCarousal(
                                                        context,
                                                        screenHeight,
                                                        movieProvider,
                                                        "Top-Rated",
                                                        _topRatedMovieScrollController,
                                                        AppConst.topRated),
                                                    getCarousal(
                                                        context,
                                                        screenHeight,
                                                        movieProvider,
                                                        "New Releases",
                                                        _newMovieScrollController,
                                                        AppConst.newReleases),
                                                    getCarousal(
                                                        context,
                                                        screenHeight,
                                                        movieProvider,
                                                        "All movies",
                                                        _allMoviesScrollController,
                                                        AppConst.allMovies),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                  ],
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  getFavouriteMovies(BuildContext context, List<SingleMovie> favouriteList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Favourites",
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .28,
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              controller: _favouriteMovieScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: favouriteList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    focusNode.unfocus();
                    Navigator.pushNamed(context, MovieDetailScreen.routeName,
                        arguments: {
                          'movie': favouriteList[index],
                          'title': favouriteList[index].title
                        });
                  },
                  child: MovieBanner(
                    singleDetail: favouriteList[index],
                  ),
                );
              }),
        ),
      ],
    );
  }

  getCarousal(
      BuildContext context,
      double screenHeight,
      MovieProvider movieProvider,
      String title,
      ScrollController scrollController,
      String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        type == AppConst.searchedList
            ? SizedBox(
                height: screenHeight,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2),
                    itemCount: getItems(movieProvider, type)!.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        onTap: () {
                          focusNode.unfocus();
                          Navigator.pushNamed(
                              context, MovieDetailScreen.routeName,
                              arguments: {
                                'movie': getItems(movieProvider, type)![index],
                              });
                        },
                        child: MovieTile(
                          singleDetail: getItems(movieProvider, type)![index],
                        ),
                      );
                    }),
              )
            : SizedBox(
                height: screenHeight * .35,
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: getItems(movieProvider, type)!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          focusNode.unfocus();
                          Navigator.pushNamed(
                              context, MovieDetailScreen.routeName,
                              arguments: {
                                'movie': getItems(movieProvider, type)![index],
                              });
                        },
                        child: MovieTile(
                          singleDetail: getItems(movieProvider, type)![index],
                        ),
                      );
                    }),
              ),
      ],
    );
  }

  List<SingleMovie>? getItems(MovieProvider movieProvider, String type) {
    switch (type) {
      case AppConst.topRated:
        return movieProvider.topRatedMovieList;
      case AppConst.newReleases:
        return movieProvider.newMovieList;
      case AppConst.allMovies:
        return movieProvider.movies!.results;
      case AppConst.searchedList:
        return movieProvider.searchMovieList;
      default:
        return null;
    }
  }
}
