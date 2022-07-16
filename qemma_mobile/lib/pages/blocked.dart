import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';

class BlockedPage extends StatelessWidget {
  const BlockedPage({Key? key}) : super(key: key);

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
                    child: const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Icon(
                        Icons.block,
                        color: Colors.black,
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col',
                    child: Center(
                      child: Text(
                        Locales.t('app.blocked.title'), //'الحساب محظور',
                        style: const TextStyle(
                          fontSize: 24,
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
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Center(
                        child: Text(
                          Locales.t('app.blocked.msg'),
                          //'يمكنك المتابعة مع السنتر لمعرفة السبب او لإلغاء الحظر',
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
                        child: InkWell(
                          child: Text(
                            Locales.t('app.backtolanding'),
                            //'العودة للقائمة السابقة',
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/landing");
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
