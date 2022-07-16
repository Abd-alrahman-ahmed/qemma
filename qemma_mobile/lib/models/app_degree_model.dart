class AppDegree {
  String translationKey;
  num min;

  AppDegree({
    required this.translationKey,
    required this.min,
  });

  factory AppDegree.fromJson(Map<String, dynamic> data) {
    return AppDegree(
      translationKey: data['translationKey'],
      min: data['min'],
    );
  }
}
