extension ListX on List {
  List<List> chunk(int chunkSize) {
    List<List> chunks = [];

    int len = length;
    for (var i = 0; i < len; i += chunkSize) {
      int size = i + chunkSize;
      chunks.add(sublist(i, size > len ? len : size));
    }

    return chunks;
  }

  List<E> sublistMinMaxLength<E>(int start, [int? end]) {
    if (start < 0) start = 0;
    if (end != null && end >= length) end = length;
    if (end != null && end < start) return [];

    return sublist(start, end) as List<E>;
  }
}

/// Useful extension functions for [Iterable]
extension IterableX<T> on Iterable<T?> {
  /// Removes all the null values
  /// and converts Iterable<T?> into Iterable<T>
  Iterable<T> get withNullifyer => whereType();
}

extension OptionalListX on List? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;
}
