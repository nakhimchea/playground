extension DateOnlyCompare on DateTime {
  int daysDifference(DateTime? other) {
    if (other == null) return 0;

    final a = DateTime(year, month, day);
    final b = DateTime(other.year, other.month, other.day);

    return a.difference(b).inDays.abs();
  }

  bool isSameDate(DateTime? other) {
    if (other == null) return false;

    return year == other.year && month == other.month && day == other.day;
  }
}
