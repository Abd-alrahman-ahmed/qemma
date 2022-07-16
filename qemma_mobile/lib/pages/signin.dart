import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:qemma_mobile/models/action_status_enum.dart';
import 'package:qemma_mobile/models/pending_arrgument_model.dart';
import 'package:qemma_mobile/presenters/student_presenter.dart';
import 'package:qemma_mobile/widgets/alert_dialog.dart';
import 'package:qemma_mobile/widgets/progress_dialog.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';
import 'package:qemma_mobile/helpers/app_validator.dart';

class SigninPage extends StatelessWidget {
  SigninPage({Key? key}) : super(key: key);
  final StudentPresenter _studentPresenter = StudentPresenter();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          Locales.t('signin.btn'),
                          //'تسجيل الدخول',
                          style: const TextStyle(fontSize: 18),
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
                      padding: const EdgeInsets.only(top: 20),
                      child: Form(
                        key: formkey,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.person),
                            labelText: Locales.t('student.code'),
                            hintText: Locales.t('student.code.ph'),
                          ),
                          validator: Validator.requiredField,
                          onChanged: _studentPresenter.setId,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: ElevatedButton(
                          child: Text(Locales.t('signin.btn')),
                          onPressed: () {
                            _login(context);
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

  void _login(BuildContext context) {
    if (formkey.currentState?.validate() == false) return;
    formkey.currentState?.save();
    ProgressDialog.show(
      context: context,
      method: _studentPresenter.signin,
    ).then((result) {
      if (result == null ||
          result.data == null ||
          result.status == ActionStatus.error) {
        DialogBox.show(
          context: context,
          title: Text(
            Locales.t('app.error.title'),
          ),
          content: Center(
            child: Text(
              Locales.t('signin.student.invalid'),
            ),
          ),
        );
        return;
      }

      if (result.status == ActionStatus.blocked) {
        Navigator.pushReplacementNamed(context, "/blocked");
      } else if (result.status == ActionStatus.pending) {
        Navigator.pushReplacementNamed(context, "/pending",
            arguments: Arguments(result.data!.id, false));
      } else if (result.status == ActionStatus.ok) {
        Navigator.pushReplacementNamed(context, "/home");
      }
    });
  }
}
