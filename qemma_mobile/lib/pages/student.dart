import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:qemma_mobile/helpers/app_extensions.dart';
import 'package:qemma_mobile/models/chart_aggregator_enum.dart';
import 'package:qemma_mobile/models/chart_model.dart';
import 'package:qemma_mobile/presenters/student_presenter.dart';
import 'package:qemma_mobile/widgets/bar_chart.dart';
import 'package:qemma_mobile/widgets/lessons_table.dart';
import 'package:qemma_mobile/widgets/progress_dialog.dart';
import 'package:qemma_mobile/widgets/student_card.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';
import 'dart:math' as math;

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);
  @override
  StudentPageState createState() {
    return StudentPageState();
  }
}

class StudentPageState extends State<StudentPage> {
  final StudentPresenter _studentPresenter = StudentPresenter();
  bool update = false;
  DateTime from =
      DateTime.now().toStartOfDay().subtract(const Duration(days: 30)).toUtc();
  DateTime to = DateTime.now().toEndOfDay().toUtc();
  ChartAggregator aggregator = ChartAggregator.daily;

  void load() {
    ProgressDialog.show(
      context: context,
      method: () =>
          _studentPresenter.loadStudentData(from, to, aggregator).then(
        (value) {
          if (!mounted) return;
          setState(() {
            update = !update;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, load);
  }

  Future<void> selectFromDate(BuildContext context, DateTime? initDate) async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: initDate ?? DateTime.now(),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != initDate) {
      setState(() {
        from = pickedDate.toStartOfDay();
      });
    }
  }

  Future<void> selectToDate(BuildContext context, DateTime? initDate) async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: initDate ?? DateTime.now(),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != initDate) {
      setState(() {
        to = pickedDate.toEndOfDay();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Locales.getDirection(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(Locales.t('app.title')),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Transform.rotate(
                angle:
                    Locales.getDirection() == TextDirection.rtl ? math.pi : 0,
                child: IconButton(
                  icon: const Icon(Icons.logout_outlined),
                  onPressed: () {
                    Future.delayed(Duration.zero, _studentPresenter.clear);
                    Navigator.pushReplacementNamed(context, "/landing");
                  },
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: StudentCard(student: StudentPresenter.student),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: BootstrapRow(
                  children: [
                    BootstrapCol(
                      child: Text(
                        "${Locales.t('filter.from')}: ",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BootstrapCol(
                      child: TextButton(
                        onPressed: () {
                          selectFromDate(context, from);
                        },
                        child: Text(Jiffy(from.toLocal()).yMMMMd),
                      ),
                    ),
                    BootstrapCol(
                      child: Text(
                        "${Locales.t('filter.to')}: ",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BootstrapCol(
                      child: TextButton(
                        onPressed: () {
                          selectToDate(context, to);
                        },
                        child: Text(Jiffy(to.toLocal()).yMMMMd),
                      ),
                    ),
                    BootstrapCol(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40),
                        ),
                        onPressed: () {
                          load();
                        },
                        child: Text(Locales.t('filter.apply')),
                      ),
                    ),
                  ],
                ),
              ),
              LessonsTable(
                lessons: _studentPresenter.studentLessons,
              ),
              const Divider(),
              BarChartWidget(
                points: _studentPresenter.chartPoints,
                aggregator: aggregator,
                onChanged: (v) {
                  aggregator = ChartAggregator.values[v ?? 0];
                  _studentPresenter.chartPoints =
                      _studentPresenter.getAnalytics(aggregator) ??
                          List<ChartPoint>.empty();
                  setState(() {
                    update = !update;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
