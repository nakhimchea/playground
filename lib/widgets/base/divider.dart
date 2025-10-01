import 'package:flutter/material.dart';
import 'package:wingai/core/themes/styles.dart';

class LightGreyDivider extends StatelessWidget {
  const LightGreyDivider({super.key, this.thickness});
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0,
      color: AppColors.lightGreyBackground,
      thickness: thickness ?? 1,
    );
  }
}

class DarkGreyDivider extends StatelessWidget {
  const DarkGreyDivider({super.key, this.thickness});

  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0,
      color: AppColors.dividerColor,
      thickness: thickness ?? 1,
    );
  }
}

class LightGreyVerticalDivider extends StatelessWidget {
  const LightGreyVerticalDivider({super.key, this.thickness});
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: 0,
      color: AppColors.lightGreyBackground,
      thickness: thickness ?? 1,
    );
  }
}

class DarkGreyVerticalDivider extends StatelessWidget {
  const DarkGreyVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      width: 0,
      color: AppColors.dividerColor,
      thickness: 1,
    );
  }
}
