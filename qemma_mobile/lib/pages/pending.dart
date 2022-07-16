import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:qemma_mobile/models/pending_arrgument_model.dart';
import 'package:qemma_mobile/widgets/alert_dialog.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';

class PendingPage extends StatelessWidget {
  const PendingPage({Key? key}) : super(key: key);
  static bool shown = false;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Arguments? args =
          ModalRoute.of(context)!.settings.arguments as Arguments?;
      if (args?.firstTime == true && args?.studentId != null && !shown) {
        shown = true;
        DialogBox.show(
          context: context,
          title: Text(Locales.t('welcome')),
          content: Column(
            children: [
              Text(
                Locales.t('app.pending.first'),
                //"This is your serial number that you can log into the app by.\nWe recommend you not to show it to any one.",
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: InkWell(
                  child: TextField(
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.copy),
                    ),
                    enabled: false,
                    controller: TextEditingController(text: args!.studentId),
                  ),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: args.studentId))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              Locales.t('copied')), //Code copied to clipboard
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ).then((value) => shown = false);
      }
    });
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
                        Icons.watch_later,
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
                        Locales.t('app.pending.title'),
                        //'الحساب قيد الإنتظار',
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
                          Locales.t('app.pending.msg'),
                          textAlign: TextAlign.center,
                          //'سيقوم المركز بتأكيد التسجيل في أسرع وقت',
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
                        child: TextButton(
                          child: Text(
                            Locales.t('app.backtolanding'),
                            //'العودة للقائمة السابقة',
                          ),
                          onPressed: () {
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
