import 'package:qemma_mobile/helpers/app_firestore.dart';
import 'package:qemma_mobile/models/lesson_model.dart';

class LessonPresenter {
  Future<Lesson?> getLesson(String lessonId) => FireStore.get(
      FirestoreCollections.lessons, lessonId, (l) => Lesson.fromJson(l));
}
