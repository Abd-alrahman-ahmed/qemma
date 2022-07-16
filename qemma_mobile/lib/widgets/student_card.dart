import 'package:flutter/material.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';
import 'package:qemma_mobile/models/student_model.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({Key? key, required this.student}) : super(key: key);
  final Student student;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: const Image(
          image: AssetImage('assets/images/user.png'),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Text(
                      student.name,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Locales.t("lookups.year.${student.year.index}"),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: Locales.getDirection() == TextDirection.rtl
                        ? const BorderSide(
                            color: Colors.black,
                            width: 2,
                          )
                        : BorderSide.none,
                    left: Locales.getDirection() == TextDirection.ltr
                        ? const BorderSide(
                            color: Colors.black,
                            width: 2,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Text(
                        Locales.studentDegree(student.totalDegree > 0
                            ? (student.degree / student.totalDegree) * 100
                            : double.nan),
                      ),
                      Text(
                        "${Locales.t('student.degree')}: ${student.degree.toString()}",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
