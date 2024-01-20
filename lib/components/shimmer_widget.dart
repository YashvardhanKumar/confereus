import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
    this.border = const StadiumBorder(),
  }) :
        radius = 0;

  const ShimmerWidget.circular({
    super.key,
    required this.radius,
  })  : width = radius * 2,
        height = radius * 2,
        border = const CircleBorder();

  final double height;
  final double width, radius;
  final ShapeBorder border;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: Colors.grey.shade400,
          shape: border,
        ),
      ),
    );
  }
}
