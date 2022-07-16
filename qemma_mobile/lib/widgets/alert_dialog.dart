import 'package:flutter/material.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';
import 'package:qemma_mobile/models/dialog_buttons_enum.dart';
import 'package:qemma_mobile/models/dialog_result_enum.dart';
import 'package:qemma_mobile/helpers/app_extensions.dart';

class DialogBox {
  static List<Widget> _buttons(
      BuildContext context, DialogButtons dialogButton) {
    List<Widget> result = [];
    var enumChose = dialogButton.toName();
    var buttons = enumChose.split('_');

    for (var button in buttons) {
      result.add(
        TextButton(
          child: Text(Locales.t('dialogs.btn.$button')),
          onPressed: () {
            var clickedButton = button.toEnum(DialogResult.values);
            Navigator.pop(context, clickedButton);
          },
        ),
      );
    }
    return result;
  }

  static Widget dialog({
    EdgeInsetsGeometry? padding,
    required BuildContext context,
    required Widget title,
    Widget? content,
    Widget? titleTrailing,
    DialogButtons dialogButton = DialogButtons.ok,
  }) {
    return Directionality(
      textDirection: Locales.getDirection(),
      child: Center(
        child: AlertDialog(
          buttonPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: AppBar(
            automaticallyImplyLeading: false,
            title: title,
            actions: titleTrailing != null
                ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: titleTrailing,
                    ),
                  ]
                : [],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(20),
                  child: SingleChildScrollView(child: content),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: _buttons(context, dialogButton),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<DialogResult?> show(
      {required BuildContext context,
      required Widget title,
      Widget? content,
      DialogButtons dialogButton = DialogButtons.ok}) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return WillPopScope(
          onWillPop: () async => false,
          child: dialog(
              context: buildContext,
              title: title,
              content: content,
              dialogButton: dialogButton,
              titleTrailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context, DialogResult.close);
                },
              )),
        );
      },
    );
  }
}
