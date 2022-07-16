import 'package:flutter/cupertino.dart';
import 'package:qemma_mobile/helpers/app_firestore.dart';
import 'package:qemma_mobile/models/app_degree_model.dart';
import 'package:qemma_mobile/models/app_locale_model.dart';
import 'package:qemma_mobile/models/field_filter_model.dart';

class Locales {
  static AppLocale _current = AppLocale(code: 'ar', rtl: true, supported: true);
  static List<AppLocale> _locales = List.empty();
  static List<AppDegree> _degrees = List.empty();

  static Future<AppLocale?> init(String localeCode) async {
    var locales = await FireStore.getAllFiltered(
      FirestoreCollections.locales,
      (data) => AppLocale.fromJson(data),
      [
        FieldFilter('supported', isEqualTo: true),
      ],
    );
    var degree = await FireStore.getAllFiltered(
      FirestoreCollections.degrees,
      (data) => AppDegree.fromJson(data),
      [],
    );

    if (locales == null || degree == null) return null;
    _locales = locales;
    _degrees = degree;
    _degrees.sort((a, b) => b.min.compareTo(a.min));

    if (_locales.isNotEmpty) {
      _current = _locales.firstWhere(
        (l) => l.code == localeCode,
        orElse: () => _locales.first,
      );
    }
    return _current;
  }

  static TextDirection getDirection() {
    return _current.rtl ? TextDirection.rtl : TextDirection.ltr;
  }

  static void changeLocale(String langCode) {
    _current = _locales.firstWhere((l) => l.code == langCode);
  }

  static String t(String key) => _translate(key);
  static String _translate(key) {
    return _current.translations[key] ?? key;
  }

  static List<LocaleResult> getGenders() => List.generate(
      2,
      (index) => LocaleResult(
          id: index + 1, value: _translate("lookups.gender.${(index + 1)}")));

  static List<LocaleResult> getYears() => List.generate(
      12,
      (index) => LocaleResult(
          id: index + 1, value: _translate("lookups.year.${(index + 1)}")));

  static List<LocaleResult> getStatus() => List.generate(
      3,
      (index) => LocaleResult(
          id: index + 1, value: _translate("lookups.status.${(index + 1)}")));

  static String studentDegree(double degree) {
    for (var degreeRange in _degrees) {
      if (degree >= degreeRange.min) {
        return _translate(degreeRange.translationKey);
      }
    }
    return _translate("lookups.degree.nodegree");
  }

  static List<LocaleResult> chartGroupingOptions() {
    return [
      LocaleResult(id: 1, value: _translate('filter.monthly')),
      LocaleResult(id: 2, value: _translate('filter.daily'))
    ];
  }
}

class LocaleResult {
  int id;
  String value;
  LocaleResult({
    required this.id,
    required this.value,
  });
}
