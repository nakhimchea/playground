String convertMillisecondsToTimeString(int milliseconds) {
  int seconds = (milliseconds / 1000).floor();
  int minutes = (seconds / 60).floor();
  int hours = (minutes / 60).floor();
  double remainingSeconds = seconds % 60.0;

  String hoursString = hours.toStringAsFixed(0);
  String minutesString = (minutes % 60).toStringAsFixed(0);
  String secondsString = remainingSeconds.toStringAsFixed(0);

  return "$hoursString : $minutesString : $secondsString ";
}

String convertSecondsToTimeString(int seconds) {
  int hours = (seconds ~/ 3600);
  int minutes = ((seconds - (hours * 3600)) ~/ 60);
  double remainingSeconds = (seconds - (hours * 3600) - (minutes * 60));

  String hoursString = hours.toString().padLeft(2, '0');
  String minutesString = minutes.toString().padLeft(2, '0');
  String secondsString = remainingSeconds.toStringAsFixed(0).padLeft(2, '0');

  return "$hoursString:$minutesString:$secondsString";
}
