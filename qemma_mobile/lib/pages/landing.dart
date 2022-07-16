import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Locales.getDirection(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(Locales.t("app.title")),
        ),
        body: SingleChildScrollView(
          child: BootstrapContainer(
            fluid: true,
            children: [
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col',
                    child: Center(
                      child: Image(
                        image: const AssetImage('assets/images/logo.png'),
                        height: MediaQuery.of(context).size.height * 0.40,
                      ),
                    ),
                  ),
                ],
              ),
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: ElevatedButton(
                          child:
                              Text(Locales.t('signin.btn')), //"تسجيل الدخول",
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "/sign-in");
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 50),
                      child: Center(
                        child: ElevatedButton(
                          child: Text(
                              Locales.t('signup.btn')), //"تسجيل حساب جديد",
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "/sign-up");
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
