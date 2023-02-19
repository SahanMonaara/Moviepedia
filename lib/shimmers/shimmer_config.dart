import 'package:flutter/material.dart';
import 'package:moviepedia/common/app_colors.dart';
import 'package:shimmer/shimmer.dart';

/// It's a class that contains static variables that are used to configure the
/// Shimmer widget
class ShimmerConfig {
  static ShimmerDirection shimmerDirection = ShimmerDirection.ltr;
  static Color baseColor = AppColors.black;
  static Color highlightColor = AppColors.secondary.withOpacity(0.2);
  static Duration period = const Duration(seconds: 2);
}
