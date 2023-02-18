import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// It's a class that contains static variables that are used to configure the
/// Shimmer widget
class ShimmerConfig {
  static ShimmerDirection shimmerDirection = ShimmerDirection.ltr;
  static Color baseColor = Colors.grey.shade300;
  static Color highlightColor = Colors.grey.shade100;
  static Duration period = const Duration(milliseconds: 1500);
}
