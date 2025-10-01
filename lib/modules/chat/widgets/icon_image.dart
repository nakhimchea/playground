import 'package:flutter/material.dart';
import 'package:playground/core/themes/styles.dart';

class IconImage extends StatelessWidget {
  final Function()? onTap;
  final String imagePath;
  final double size;
  const IconImage({super.key, this.onTap, required this.imagePath, required this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          color: AppColors.lightGreyIconColor,
        ),
      ),
    );
  }
}
