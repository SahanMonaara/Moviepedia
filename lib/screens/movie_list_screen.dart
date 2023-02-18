import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:moviepedia/models/movies.dart';
import 'package:moviepedia/screens/widgets/background.dart';
import 'package:moviepedia/screens/widgets/movie_banner.dart';
import 'package:moviepedia/screens/widgets/movie_tile.dart';
import 'package:provider/provider.dart';
import 'package:moviepedia/common/app_colors.dart';
import 'package:moviepedia/network/net_exception.dart';
import 'package:moviepedia/network/net_result.dart';
import 'package:moviepedia/providers/movie_provider.dart';
import 'package:moviepedia/screens/movie_details_screen.dart';

import '../common/app_assets.dart';
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
  final ScrollController _newMovieScrollController = ScrollController();
  final ScrollController _searchedMovieController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool statusSearch = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        statusSearch = !statusSearch;
      });
    });
  }

  /// It gets the list of Movies from the API.
  ///
  /// Args:
  ///   page (int): The page number to be fetched.
  ///
  /// Returns:
  ///   Nothing
  getMoviesList({int? page}) async {
    if (page == null || page == 1) {}
    Provider.of<MovieProvider>(context, listen: false)
        .changeDataLoadingStatus(true);
    Result result = await Provider.of<MovieProvider>(context, listen: false)
        .getMoviesList();
    if (result.exception != null) {
      if (result.exception!.messageId == CommonMessageId.UNAUTHORIZED) {
        return;
      }
    }
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
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Center(child: TripCardShimmer()));
            }
            if (movieProvider.movies!.results!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('No data'),
                ),
              );
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: screenWidth,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: GradientBoxBorder(
                              gradient: LinearGradient(colors: [
                            AppColors.secondary,
                            AppColors.secondary,
                          ])),
                        ),
                        child: TextFormField(
                            focusNode: focusNode,
                            controller: searchController,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) {
                              Provider.of<MovieProvider>(context, listen: false)
                                  .searchMovies(value);
                              value.isEmpty? focusNode.unfocus():null;
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
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Provider.of<MovieProvider>(context)
                                            .searchMovieList
                                            .isNotEmpty
                                        ? """ Search Results of ""${searchController.text}"" """
                                        : """ There is no Results of ""${searchController.text}"" """,
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
                                    height: screenHeight * .35,
                                    child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        controller: _searchedMovieController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: movieProvider
                                            .searchMovieList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () {
                                              focusNode.unfocus();
                                              Navigator.pushNamed(context,
                                                  MovieDetailScreen.routeName,
                                                  arguments: {
                                                    'movie': movieProvider
                                                        .searchMovieList[index],
                                                    'title': movieProvider
                                                        .searchMovieList[index]
                                                        .title
                                                  });
                                            },
                                            child: MovieTile(
                                              singleDetail: movieProvider
                                                  .searchMovieList[index],
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ))
                        : Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                        visible: Provider.of<MovieProvider>(
                                                context,
                                                listen: false)
                                            .favouriteList
                                            .isNotEmpty,
                                        child: getFavouriteMovies(context,
                                            movieProvider.favouriteList)),
                                    Text(
                                      "Top-Rated",
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
                                      height: screenHeight * .35,
                                      child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          controller:
                                              _topRatedMovieScrollController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: movieProvider
                                              .topRatedMovieList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () {
                                                focusNode.unfocus();
                                                Navigator.pushNamed(context,
                                                    MovieDetailScreen.routeName,
                                                    arguments: {
                                                      'movie': movieProvider
                                                              .topRatedMovieList[
                                                          index],
                                                      'title': movieProvider
                                                          .topRatedMovieList[
                                                              index]
                                                          .title
                                                    });
                                              },
                                              child: MovieTile(
                                                singleDetail: movieProvider
                                                    .topRatedMovieList[index],
                                              ),
                                            );
                                          }),
                                    ),
                                    Text(
                                      "New Releases",
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
                                      height: screenHeight * .35,
                                      child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          controller: _newMovieScrollController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              movieProvider.newMovieList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () {
                                                focusNode.unfocus();
                                                Navigator.pushNamed(context,
                                                    MovieDetailScreen.routeName,
                                                    arguments: {
                                                      'movie': movieProvider
                                                              .topRatedMovieList[
                                                          index],
                                                      'title': movieProvider
                                                          .topRatedMovieList[
                                                              index]
                                                          .title
                                                    });
                                              },
                                              child: MovieTile(
                                                singleDetail: movieProvider
                                                    .newMovieList[index],
                                              ),
                                            );
                                          }),
                                    ),
                                    Text(
                                      "All Movies",
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
                                      height: screenHeight * .35,
                                      child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          controller: _newMovieScrollController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: movieProvider
                                              .movies!.results!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () {
                                                focusNode.unfocus();
                                                Navigator.pushNamed(context,
                                                    MovieDetailScreen.routeName,
                                                    arguments: {
                                                      'movie': movieProvider
                                                              .topRatedMovieList[
                                                          index],
                                                      'title': movieProvider
                                                          .topRatedMovieList[
                                                              index]
                                                          .title
                                                    });
                                              },
                                              child: MovieTile(
                                                singleDetail: movieProvider
                                                    .movies!.results![index],
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
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
              controller: _topRatedMovieScrollController,
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
}
