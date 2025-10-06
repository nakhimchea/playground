import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color color;
  final double dashWidth;
  final double dashHeight;
  const CustomDivider({
    super.key,
    this.color = Colors.black,
    this.dashWidth = 10,
    this.dashHeight = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double boxWidth = constraints.constrainWidth();
        final int dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(
            dashCount,
            (index) => SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            ),
          ),
        );
      },
    );
  }
}
