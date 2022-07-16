class FieldFilter {
  String field;
  Object? isEqualTo;
  Object? isNotEqualTo;
  Object? isLessThan;
  Object? isLessThanOrEqualTo;
  Object? isGreaterThan;
  Object? isGreaterThanOrEqualTo;
  Object? arrayContains;
  List<Object?>? arrayContainsAny;
  List<Object?>? whereIn;
  List<Object?>? whereNotIn;
  bool? isNull;

  FieldFilter(
    this.field, {
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}
