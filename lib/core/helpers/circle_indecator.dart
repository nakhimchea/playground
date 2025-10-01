import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CircularIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  const CircularIndicator({
    super.key,
    this.size = 50,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        size: size,
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
