import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';
import 'package:qemma_mobile/models/student_lesson_model.dart';
import 'package:qemma_mobile/widgets/empty_state.dart';

class LessonsTable extends StatelessWidget {
  const LessonsTable({
    Key? key,
    required this.lessons,
  }) : super(key: key);
  final List<StudentLesson> lessons;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                Locales.t('lessons.title'),
                //'الحصص',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
        if (lessons.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 212, 237, 218)),
              columnSpacing: 40,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              columns: [
                DataColumn(
                  label: Text(Locales.t('lesson.name')),
                ),
                DataColumn(
                  label: Text(Locales.t('lesson.start')),
                ),
                DataColumn(
                  label: Text(Locales.t('lesson.attend')),
                ),
                DataColumn(
                  label: Text(Locales.t('lesson.quiz')),
                ),
                DataColumn(
                  label: Text(Locales.t('lesson.homework')),
                ),
                DataColumn(
                  label: Text(Locales.t('lesson.dictation')),
                ),
                DataColumn(
                  label: Text(Locales.t('lesson.behaviour')),
                ),
                DataColumn(
                  label: Text(Locales.t('lesson.interaction')),
                ),
                DataColumn(
                  label: Text(Locales.t('lesson.paid')),
                ),
              ],
              rows: [
                ...lessons.where((l) => l.lesson != null).map(
                      (l) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              l.lesson?.name ?? "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              Jiffy(l.start.toLocal()).yMMMMEEEEdjm,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              Locales.t(
                                  "lookups.attend.${l.hasAttend ? '1' : '2'}"),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${l.quizDegree.toString()}/${l.lesson?.quizDegree.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${l.homeworkDegree.toString()}/${l.lesson?.homeworkDegree.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${l.inClassExamDegree.toString()}/${l.lesson?.inClassExamDegree.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${l.behaviourDegree.toString()}/${l.lesson?.behaviourDegree.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${l.interactionDegree.toString()}/${l.lesson?.interactionDegree.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              l.paidAmount.toString(),
                            ),
                          ),
                        ],
                      ),
                    )
              ],
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: EmptyState(),
          )
      ],
    );
  }
}
