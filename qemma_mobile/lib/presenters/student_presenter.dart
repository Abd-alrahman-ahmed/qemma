import 'package:jiffy/jiffy.dart';
import 'package:qemma_mobile/helpers/app_firestore.dart';
import 'package:qemma_mobile/helpers/shared_preferences.dart';
import 'package:qemma_mobile/models/account_status_enum.dart';
import 'package:qemma_mobile/models/action_result.dart';
import 'package:qemma_mobile/models/action_status_enum.dart';
import 'package:qemma_mobile/models/chart_aggregator_enum.dart';
import 'package:qemma_mobile/models/chart_model.dart';
import 'package:qemma_mobile/models/field_filter_model.dart';
import 'package:qemma_mobile/models/gender_enum.dart';
import 'package:qemma_mobile/models/student_lesson_model.dart';
import 'package:qemma_mobile/models/student_model.dart';
import 'package:qemma_mobile/models/year_enum.dart';
import 'package:qemma_mobile/presenters/group_presenter.dart';
import 'package:qemma_mobile/presenters/lesson_presenter.dart';
import 'package:qemma_mobile/presenters/student_lesson_presenter.dart';
import 'package:qemma_mobile/helpers/app_extensions.dart';

class StudentPresenter {
  final GroupPresenter _groupPresenter = GroupPresenter();
  final StudentLessonPresenter _studentLessonPresenter =
      StudentLessonPresenter();
  final LessonPresenter _lessonPresenter = LessonPresenter();
  static Student student = Student(
    id: "",
    code: "",
    name: "",
    phoneNumber: "",
    gender: Gender.blank,
    year: Year.blank,
    degree: 0,
    totalDegree: 0,
    status: AccountStatus.blank,
    registrationDate: DateTime.now().toUtc(),
  );
  List<StudentLesson> studentLessons = List.empty();
  List<ChartPoint> chartPoints = List.empty();

  static Future initStudent() async {
    try {
      var studentId = await SharedPreference.getData(
        key: SharedPreferenceKeys.user_data,
        mapper: (d) => d,
      );
      if (studentId != null) {
        student.id = studentId;
      }
    } catch (e) {
      // nothing to do just student not in SharedPrefrence
    }
  }

  static bool isLogged() {
    return student.id.isNotEmpty;
  }

  void setId(String value) {
    student.code = value;
  }

  void setName(String value) {
    student.name = value;
  }

  void setPhoneNumber(String value) {
    student.phoneNumber = value;
  }

  void setGender(int? value) {
    student.gender = Gender.values[value ?? 0];
  }

  void setYear(int? value) {
    student.year = Year.values[value ?? 0];
  }

  Future<Student?> getStudentById() async => FireStore.get(
        FirestoreCollections.students,
        student.id,
        (s) => Student.fromJson(s),
      );

  Future<List<Student>?> getStudentByCode() async => FireStore.getAllFiltered(
        FirestoreCollections.students,
        (s) => Student.fromJson(s),
        [
          FieldFilter("code", isEqualTo: student.code.toUpperCase()),
        ],
      );

  Future<String?> addStudent() async => FireStore.add(
        FirestoreCollections.students,
        student.toJson(),
      );

  Future<ActionResult<Student>> signin() async {
    var localStudent = await getStudentByCode();
    if (localStudent == null || localStudent.isEmpty) {
      return ActionResult(
        status: ActionStatus.error,
        isSucceeded: false,
      );
    }
    if (localStudent.length > 1) {
      return ActionResult(
        status: ActionStatus.error,
        isSucceeded: false,
      );
    }
    student = localStudent.first;
    if (student.status == AccountStatus.confirmed) {
      await SharedPreference.setString(
        key: SharedPreferenceKeys.user_data,
        value: student.id,
      );
    }
    return ActionResult(
      data: student,
      status: student.status == AccountStatus.blocked
          ? ActionStatus.blocked
          : (student.status == AccountStatus.pending
              ? ActionStatus.pending
              : ActionStatus.ok),
      isSucceeded: true,
    );
  }

  Future<ActionResult<String?>> signup() async {
    student.registrationDate = DateTime.now().toUtc();
    student.status = AccountStatus.pending;

    var groups =
        await _groupPresenter.getGroups((ele) => ele.year == student.year);
    if (groups == null || groups.isEmpty) {
      return ActionResult(
        data: null,
        status: ActionStatus.error,
        isSucceeded: false,
      );
    }

    var group = groups.first;
    student.groupIds = [group.id];
    student.code =
        int.parse(Jiffy(student.registrationDate).format("yyMMddHHmmss"))
            .toRadixString(16)
            .toUpperCase();
    var studentId = await addStudent();
    if (studentId == null) {
      return ActionResult(
        data: null,
        status: ActionStatus.error,
        isSucceeded: false,
      );
    }

    group.studentIds ??= List<String>.empty(growable: true);
    group.studentIds?.add(studentId);
    var update = await _groupPresenter.updateGroup(group);
    if (update) {
      return ActionResult(
        data: student.code,
        status: ActionStatus.ok,
        isSucceeded: true,
      );
    } else {
      return ActionResult(
        data: null,
        status: ActionStatus.error,
        isSucceeded: false,
      );
    }
  }

  Future<ActionResult<bool>> loadStudentData(
    DateTime from,
    DateTime to,
    ChartAggregator aggregator,
  ) async {
    var localeStudent = await getStudentById();
    if (localeStudent == null) {
      return ActionResult(isSucceeded: false);
    }
    student = localeStudent;
    var lessons = await _studentLessonPresenter.getLessons([
      FieldFilter("studentId", isEqualTo: student.id),
      FieldFilter("start",
          isGreaterThanOrEqualTo: from, isLessThanOrEqualTo: to),
    ]);
    if (lessons == null) {
      return ActionResult(isSucceeded: false);
    }
    studentLessons = lessons;
    for (var studetLesson in studentLessons) {
      studetLesson.lesson = await _lessonPresenter.getLesson(
        studetLesson.lessonId,
      );
    }
    var chart = getAnalytics(aggregator);
    if (chart == null) {
      return ActionResult(isSucceeded: false);
    }
    chartPoints = chart;
    return ActionResult(isSucceeded: true);
  }

  List<ChartPoint>? getAnalytics(ChartAggregator aggregator) {
    return studentLessons
        .groupBy((l) => convertDate(l.start, aggregator))
        .entries
        .map((kv) {
      var studentDegree = kv.value
          .fold<double>(0.0, (sum, item) => sum + (item.quizDegree ?? 0.0));
      var totalDegree = kv.value.fold<double>(
          0.0, (sum, item) => sum + (item.lesson?.quizDegree ?? 0.0));
      var finalDegree =
          totalDegree == 0 ? 0 : (studentDegree / totalDegree) * 100;
      return ChartPoint(
        id: kv.key.microsecondsSinceEpoch,
        value: double.parse(finalDegree.toStringAsFixed(1)),
        key: aggregator == ChartAggregator.daily
            ? Jiffy(kv.key.toLocal()).yMMMMd
            : Jiffy(kv.key.toLocal()).yMMMM,
      );
    }).toList();
  }

  DateTime convertDate(DateTime start, ChartAggregator aggregator) {
    switch (aggregator) {
      case ChartAggregator.daily:
        return DateTime(start.year, start.month, start.day);
      case ChartAggregator.monthly:
        return DateTime(start.year, start.month);
      default:
        return start;
    }
  }

  Future clear() async {
    await SharedPreference.clear();
  }
}
