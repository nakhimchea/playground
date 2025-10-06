import 'package:intl/intl.dart';

String timeTranslator(String localeName, DateTime dateTime) {
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return DateFormat('d MMM y', localeName).format(dateTime);
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m ago';
  } else {
    return 'Just now';
  }
}
