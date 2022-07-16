import 'package:qemma_mobile/helpers/app_firestore.dart';
import 'package:qemma_mobile/models/field_filter_model.dart';
import 'package:qemma_mobile/models/student_lesson_model.dart';

class StudentLessonPresenter {
  Future<List<StudentLesson>?> getLessons(List<FieldFilter> filters) =>
      FireStore.getAllFiltered(FirestoreCollections.studentLesson,
          (l) => StudentLesson.fromJson(l), filters);
}
