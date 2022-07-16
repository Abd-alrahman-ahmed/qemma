import 'package:flutter/material.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';

class ProgressDialog {
  static Future<T?> show<T>(
      {required BuildContext context,
      required Future<T> Function() method,
      bool isCircular = true}) {
    method().then((value) {
      Navigator.pop(context, value);
    });
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              content: SingleChildScrollView(
                child: Center(
                  child: ListTile(
                      title: Center(child: Text(Locales.t('loading'))),
                      subtitle: !isCircular
                          ? LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor))
                          : null,
                      leading: isCircular
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor))
                          : null),
                ),
              ),
            ),
          );
        });
  }
}
