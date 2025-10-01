import 'package:get/get_utils/src/platform/platform.dart';

abstract class AppMetrics {
  double get extraHuge;
  double get huge;
  double get large;
  double get medium;
  double get small;
  double get tiny;

  // font Size
  double get fontTitle;
  double get fontSubTitle;
  double get fontRegular;
  double get fontMedium;
  double get fontSmall;
  double get fontInputTitle;
  double get header3;
  double get header2;

  double get defaultPadding;

  double get spacing4;
  double get spacing8;
  double get spacing16;
  double get spacing21;
  double get spacing28;
  double get spacing24;
  double get spacing32;
  double get spacing40;

  double get radius6;
  double get radius10;
  double get radius16;
  double get radius24;
  double get radius32;
  double get radius40;

  void myFun() {}
}

class _MobileMetrics extends AppMetrics {
  _MobileMetrics();
  @override
  double get extraHuge => 64.0;
  @override
  double get huge => 32.0;
  @override
  double get large => 16.0;
  @override
  double get medium => 12.0;
  @override
  double get small => 6.0;
  @override
  double get tiny => 3.0;

  @override
  double get fontTitle => 18.0;
  @override
  double get fontSubTitle => 17.0;
  @override
  double get fontRegular => 16.0;
  @override
  double get fontMedium => 14.0;
  @override
  double get fontSmall => 12.0;
  @override
  double get fontInputTitle => 12.0;

  @override
  double get defaultPadding => 16.0;

  @override
  double get spacing40 => 40.0;
  @override
  double get spacing32 => 32.0;
  @override
  double get spacing16 => 16.0;
  @override
  double get spacing21 => 21.0;
  @override
  double get spacing28 => 28.0;
  @override
  double get spacing24 => 24.0;
  @override
  double get spacing8 => 8.0;
  @override
  double get spacing4 => 4.0;

  @override
  double get radius6 => 6.0;
  @override
  double get radius10 => 10.0;
  @override
  double get radius16 => 16.0;
  @override
  double get radius24 => 24.0;
  @override
  double get radius32 => 32.0;
  @override
  double get radius40 => 40.0;

  @override
  double get header3 => 30.0;
  @override
  double get header2 => 23.0;
}

// mobile and table different size 4px
class _TabletMetrics extends AppMetrics {
  _TabletMetrics();
  @override
  double get extraHuge => 70.0;
  @override
  double get huge => 38.0;
  @override
  double get large => 22.0;
  @override
  double get medium => 16.0;
  @override
  double get small => 12.0;
  @override
  double get tiny => 7.0;
  @override
  double get fontTitle => 24.0;
  @override
  double get fontSubTitle => 21.0;
  @override
  double get fontRegular => 18.0;
  @override
  double get fontMedium => 16.0;
  @override
  double get fontSmall => 13.0;
  @override
  double get fontInputTitle => 16.0;
  @override
  double get defaultPadding => 20.0;

  @override
  double get spacing40 => 88.0;
  @override
  double get spacing32 => 80.0;
  @override
  double get spacing16 => 72.0;
  @override
  double get spacing28 => 23.0;
  @override
  double get spacing21 => 25.0;
  @override
  double get spacing24 => 64.0;
  @override
  double get spacing8 => 56.0;
  @override
  double get spacing4 => 48.0;

  @override
  double get radius6 => 10.0;
  @override
  double get radius10 => 14.0;
  @override
  double get radius16 => 20.0;
  @override
  double get radius24 => 28.0;
  @override
  double get radius32 => 36.0;
  @override
  double get radius40 => 44.0;

  @override
  double get header3 => 35.0;
  @override
  double get header2 => 27.0;
}

class Metrics {
  static AppMetrics instance = _MobileMetrics();

  Metrics() {
    instance = GetPlatform.isMobile ? _MobileMetrics() : _TabletMetrics();
  }
}
