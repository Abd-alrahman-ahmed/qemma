import 'package:qemma_mobile/helpers/app_locales.dart';

class Validator {
  static final String _required =
      Locales.t('field.require'); //'This field is required';
  static final String _number =
      Locales.t('field.number'); //'This field value must be numeric';
  static final String _phone =
      Locales.t('field.phone'); //'The phone number is\'t valid';

  static String? requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return _required;
    }
    return null;
  }

  static String? numberField(String? value) {
    if (value == null || value.isEmpty) {
      return _required;
    }
    if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
      return _number;
    }

    return null;
  }

  static String? phoneField(String? value) {
    if (value == null || value.isEmpty) {
      return _required;
    }
    if (!RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$")
        .hasMatch(value)) {
      return _phone;
    }

    return null;
  }
}
