import 'package:flutter/material.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key, this.image, this.message}) : super(key: key);
  final String? image;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(image ?? 'assets/images/no_items.png'),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                message ?? Locales.t('emptystate.default'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
