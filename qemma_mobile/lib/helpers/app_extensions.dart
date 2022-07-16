extension EnumExtensions on Enum {
  String toName() {
    return toString().split(".").last;
  }
}

extension StringExtensions on String {
  T toEnum<T extends Enum>(List<T> enumValues) {
    return enumValues.firstWhere(
      (enumValue) => enumValue.toName().toUpperCase() == toUpperCase(),
    );
  }

  String truncateWithEllipsis(int maxLength) {
    return (length <= maxLength) ? this : '${substring(0, maxLength)}...';
  }

  bool isStartWithArabic() {
    return RegExp(r"^[\u0600-\u06FF]").hasMatch(this);
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension DateTimeExtensions on DateTime {
  DateTime toEndOfDay() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  DateTime toStartOfDay() {
    return DateTime(year, month, day);
  }
}
