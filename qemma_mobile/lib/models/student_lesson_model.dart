// -- student_lesson.dart --
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qemma_mobile/models/lesson_model.dart';
import 'package:qemma_mobile/models/student_model.dart';

class StudentLesson {
  String id;
  DateTime start;
  String studentId;
  Student? student;
  String groupId;
  String lessonId;
  Lesson? lesson;
  num? quizDegree;
  num? homeworkDegree;
  num? inClassExamDegree;
  num? behaviourDegree;
  num? interactionDegree;
  bool hasAttend;
  num paidAmount;

  StudentLesson({
    required this.id,
    required this.start,
    required this.studentId,
    this.student,
    required this.groupId,
    required this.lessonId,
    this.lesson,
    this.quizDegree,
    this.homeworkDegree,
    this.inClassExamDegree,
    this.behaviourDegree,
    this.interactionDegree,
    required this.hasAttend,
    required this.paidAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start': start,
      'studentId': studentId,
      'student': student?.toJson(),
      'groupId': groupId,
      'lessonId': lessonId,
      'lesson': lesson?.toJson(),
      'quizDegree': quizDegree,
      'homeworkDegree': homeworkDegree,
      'inClassExamDegree': inClassExamDegree,
      'behaviourDegree': behaviourDegree,
      'interactionDegree': interactionDegree,
      'hasAttend': hasAttend,
      'paidAmount': paidAmount
    };
  }

  factory StudentLesson.fromJson(Map<String, dynamic> data) {
    return StudentLesson(
      id: data['id'],
      start: (data['start'] as Timestamp).toDate(),
      studentId: data['studentId'],
      student: null,
      groupId: data['groupId'],
      lessonId: data['lessonId'],
      lesson: null,
      quizDegree: data['quizDegree'],
      homeworkDegree: data['homeworkDegree'],
      inClassExamDegree: data['inClassExamDegree'],
      behaviourDegree: data['behaviourDegree'],
      interactionDegree: data['interactionDegree'],
      hasAttend: data['hasAttend'],
      paidAmount: data['paidAmount'],
    );
  }
}
