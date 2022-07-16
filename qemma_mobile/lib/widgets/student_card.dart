import 'package:dotted_border/dotted_border.dart';
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
          child: IntrinsicHeight(
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
                const VerticalDivider(
                  color: Colors.black,
                  width: 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [10, 5, 10, 5, 10, 5],
                    color: const Color.fromARGB(255, 48, 118, 114),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Text(
                            Locales.studentDegree(student.totalDegree > 0
                                ? double.parse(studentDegree())
                                : double.nan),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${Locales.t('student.degree')}: ${studentDegree()}%",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String studentDegree() {
    var finalDegree = student.totalDegree == 0
        ? 0
        : (student.degree / student.totalDegree) * 100;
    return finalDegree.toStringAsFixed(1);
  }
}
