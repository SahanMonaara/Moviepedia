import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../common/app_colors.dart';

class DetailsContainer extends StatelessWidget {
   const DetailsContainer(
      {Key? key,
        required this.width,
        required this.childWidget})
      : super(key: key);

  final double width;
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: width,
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: GradientBoxBorder(
                    gradient: LinearGradient(colors: [
                      AppColors.secondary,
                      AppColors.secondary,
                    ])),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(0.6),
                    ]),
              ),
            ),
            Center(child: childWidget),
          ],
        ),
      ),
    );
  }
}