import 'package:flutter/material.dart';

extension IntX on int {
  Duration get minute => Duration(minutes: this);
  Duration get second => Duration(seconds: this);
  Duration get milliSecond => Duration(milliseconds: this);

  Widget get width => SizedBox(width: toDouble());
  Widget get height => SizedBox(height: toDouble());

  BorderRadius get radius => BorderRadius.circular(toDouble());

  EdgeInsets get paddingAllEdge => EdgeInsets.all(toDouble());
  EdgeInsets get paddingHorizontalSide => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get paddingVerticalSide => EdgeInsets.symmetric(vertical: toDouble());

  String get printDuration {
    final duration = Duration(seconds: this);
    
    String twoDigits(int n, int pad) => n.toString().padLeft(pad, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60), 1);
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60), 2);
    // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
