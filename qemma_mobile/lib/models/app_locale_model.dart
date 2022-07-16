class AppLocale {
  String code;
  bool rtl;
  bool supported;
  String? countryCode;
  Map<String, String> translations = {};

  AppLocale({
    required this.code,
    required this.rtl,
    required this.supported,
    this.countryCode,
    this.translations = const {},
  });

  factory AppLocale.fromJson(Map<String, dynamic> data) {
    return AppLocale(
      code: data['code'],
      rtl: data['rtl'],
      supported: data['supported'],
      countryCode: data['countryCode'],
      translations: (data['translations'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, v.toString()),
      ),
    );
  }
}
