import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:qemma_mobile/models/action_status_enum.dart';
import 'package:qemma_mobile/models/pending_arrgument_model.dart';
import 'package:qemma_mobile/presenters/student_presenter.dart';
import 'package:qemma_mobile/widgets/alert_dialog.dart';
import 'package:qemma_mobile/widgets/progress_dialog.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';
import 'package:qemma_mobile/helpers/app_validator.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);
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
                          Locales.t('student.register'),
                          //'تسجيل طالب إلى مسار التعليم',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    BootstrapRow(
                      children: <BootstrapCol>[
                        BootstrapCol(
                          sizes: 'col',
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                icon: const Icon(Icons.person),
                                labelText: Locales.t('student.name'),
                                hintText: Locales.t('student.name.ph'),
                              ),
                              validator: Validator.requiredField,
                              onChanged: _studentPresenter.setName,
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
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                icon: const Icon(Icons.phone),
                                labelText: Locales.t('student.phonenumber'),
                                hintText: Locales.t('student.phonenumber.ph'),
                              ),
                              validator: Validator.phoneField,
                              onChanged: _studentPresenter.setPhoneNumber,
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
                            child: DropdownButtonFormField<int>(
                              items: Locales.getGenders()
                                  .map(
                                    (e) => DropdownMenuItem<int>(
                                      value: e.id,
                                      child: Text(e.value),
                                    ),
                                  )
                                  .toList(),
                              decoration: InputDecoration(
                                icon: const Icon(Icons.person),
                                labelText: Locales.t('student.gender'),
                                hintText: Locales.t('student.gender.ph'),
                              ),
                              validator: (value) =>
                                  Validator.requiredField(value?.toString()),
                              onChanged: _studentPresenter.setGender,
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
                            child: DropdownButtonFormField<int>(
                              items: Locales.getYears()
                                  .map(
                                    (e) => DropdownMenuItem<int>(
                                      value: e.id,
                                      child: Text(e.value),
                                    ),
                                  )
                                  .toList(),
                              decoration: InputDecoration(
                                icon: const Icon(Icons.school),
                                labelText: Locales.t('student.year'),
                                hintText: Locales.t('student.year.ph'),
                              ),
                              validator: (value) =>
                                  Validator.requiredField(value?.toString()),
                              onChanged: _studentPresenter.setYear,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: ElevatedButton(
                          child: Text(Locales.t('signup.btn')),
                          onPressed: () {
                            _register(context);
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

  void _register(BuildContext context) {
    if (formkey.currentState?.validate() == false) return;
    formkey.currentState?.save();
    ProgressDialog.show(
      context: context,
      method: _studentPresenter.signup,
    ).then((res) {
      if (res == null || res.data == null || res.status == ActionStatus.error) {
        DialogBox.show(
            context: context,
            title: Text(Locales.t('app.error.title')),
            content: Text(Locales.t('app.error.msg')));
        return;
      } else {
        Navigator.pushReplacementNamed(context, "/pending",
            arguments: Arguments(res.data ?? "", true));
      }
    });
  }
}
