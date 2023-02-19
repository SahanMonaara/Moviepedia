import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../common/app_assets.dart';
import '../../common/app_colors.dart';
import '../../common/app_const.dart';
import '../../models/movies.dart';
import '../../providers/movie_provider.dart';

class MovieBanner extends StatefulWidget {
  final SingleMovie singleDetail;

  const MovieBanner({Key? key, required this.singleDetail}) : super(key: key);

  @override
  State<MovieBanner> createState() => _MovieBannerState();
}

class _MovieBannerState extends State<MovieBanner> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth * 0.7,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl:
                    "${AppConst.imageUrl}${widget.singleDetail.backdropPath}",
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: Text(
                        widget.singleDetail.title ?? "Title",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Image(
                          width: 15,
                          height: 15,
                          image: AssetImage(AppAssets.star),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.singleDetail.voteAverage.toString(),
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                InkWell(
                    onTap: () {
                      Provider.of<MovieProvider>(context, listen: false)
                          .tapOnFavourite(widget.singleDetail);
                    },
                    child: Provider.of<MovieProvider>(context, listen: false)
                            .checkFavouriteStatus(widget.singleDetail)
                        ? const Icon(
                            Icons.favorite,
                            color: AppColors.red,
                          )
                        : const Icon(Icons.favorite_outline,
                            color: AppColors.red))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
