import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:moviepedia/screens/widgets/background.dart';
import 'package:moviepedia/screens/widgets/details_container.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:moviepedia/common/app_assets.dart';
import 'package:moviepedia/common/app_colors.dart';
import 'package:moviepedia/common/custom_text_styles.dart';
import 'package:moviepedia/helpers/utils.dart';
import 'package:moviepedia/models/movies.dart';
import 'package:moviepedia/network/net_exception.dart';
import 'package:moviepedia/providers/movie_provider.dart';
import '../common/app_const.dart';
import '../network/net_result.dart';

class MovieDetailScreen extends StatefulWidget {
  static const routeName = '/movie-detail-screen';

  const MovieDetailScreen({Key? key}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isInit = false;
  String title = '';
  SingleMovie? movie;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      Map data = ModalRoute.of(context)?.settings.arguments as Map;
      if (data['title'] != null) title = data['title'];
      if (data['movie'] != null) movie = data['movie'];
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Stack(
            children: [
              const Background(),
              Positioned(
                child: CachedNetworkImage(
                  height: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: "${AppConst.imageUrl}${movie!.posterPath}",
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: screenHeight / 1.5,
                  padding: EdgeInsets.all(20),
                  child: DetailsContainer(
                    childWidget: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            movie!.title!,
                            style: CustomTextStyles.movieTitle(),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            children: [
                              buildImportantDetails(
                                  'Popularity', movie!.popularity.toString()),
                              buildImportantDetails('Language',
                                  movie!.originalLanguage.toString()),
                              Column(
                                children: [
                                  Image(
                                    width: 15,
                                    height: 15,
                                    image: AssetImage(AppAssets.star),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    movie!.voteAverage.toString(),
                                    style: GoogleFonts.nunito(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          buildDetailText(
                              'Details', movie!.overview ?? "Movie"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildImportantDetails('Released date',
                                  movie!.releaseDate ?? "Movie"),
                              IconButton(
                                  onPressed: () {
                                    Provider.of<MovieProvider>(context,
                                            listen: false)
                                        .tapOnFavourite(movie!);
                                    setState(() {});
                                  },
                                  icon: Provider.of<MovieProvider>(context,
                                              listen: false)
                                          .checkFavouriteStatus(movie!)
                                      ? const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 30,
                                        )
                                      : const Icon(
                                          Icons.favorite_outline,
                                          color: Colors.red,
                                          size: 30,
                                        )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    width: screenWidth,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            )),
                      ],
                    ),

                    // const SizedBox(height: 20),
                    // _buildImage(
                    //     movie!.posterPath),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }

  /// It returns a widget that displays a title and a detail.
  ///
  /// Args:
  ///   title (String): The title of the text
  ///   detail (String): The detail text to be displayed.
  ///
  /// Returns:
  ///   A SizedBox widget with a width of the width of the screen.
  Widget buildDetailText(String title, String detail) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: CustomTextStyles.titleStyle(),
            ),
            Text(
              detail,
              style: CustomTextStyles.regularStyle(),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImportantDetails(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomTextStyles.titleStyle(),
          ),
          Text(
            detail,
            style: CustomTextStyles.regularStyle(),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  /// If the imageUrl is not null, then display the image, otherwise display a grey
  /// box
  ///
  /// Args:
  ///   imageUrl (String): The URL of the image to display.
  ///
  /// Returns:
  ///   A widget that displays an image.
  Widget _buildImage(String? imageUrl) {
    return Center(
      child: ClipRRect(
          child: SizedBox(
        height: 200,
        child: imageUrl != null
            ? Image.network(AppConst.imageUrl + imageUrl, fit: BoxFit.cover)
            : Container(
                color: Colors.grey.withOpacity(0.5),
              ),
      )),
    );
  }
}
