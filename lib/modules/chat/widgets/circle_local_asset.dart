import 'package:flutter/material.dart';
import 'package:playground/core/themes/styles.dart';

class CircleLocalAsset extends StatelessWidget {
  final String localAssetPath;
  const CircleLocalAsset({super.key, required this.localAssetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        child: Image.asset(
          localAssetPath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
