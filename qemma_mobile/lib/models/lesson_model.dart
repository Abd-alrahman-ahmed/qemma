// -- lesson.dart --
import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  String id;
  String name;
  String? teacherName;
  DateTime start;
  num? quizDegree;
  num? homeworkDegree;
  num? inClassExamDegree;
  num? behaviourDegree;
  num? interactionDegree;
  String groupId;
  List<String>? studentIds;

  Lesson({
    required this.id,
    required this.name,
    this.teacherName,
    required this.start,
    this.quizDegree,
    this.homeworkDegree,
    this.inClassExamDegree,
    this.behaviourDegree,
    this.interactionDegree,
    required this.groupId,
    this.studentIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacherName': teacherName,
      'start': start,
      'quizDegree': quizDegree,
      'homeworkDegree': homeworkDegree,
      'inClassExamDegree': inClassExamDegree,
      'behaviourDegree': behaviourDegree,
      'interactionDegree': interactionDegree,
      'groupId': groupId,
      'studentIds': studentIds
    };
  }

  factory Lesson.fromJson(Map<String, dynamic> data) {
    return Lesson(
      id: data['id'],
      name: data['name'],
      teacherName: data['teacherName'],
      start: (data['start'] as Timestamp).toDate(),
      quizDegree: data['quizDegree'],
      homeworkDegree: data['homeworkDegree'],
      inClassExamDegree: data['inClassExamDegree'],
      behaviourDegree: data['behaviourDegree'],
      interactionDegree: data['interactionDegree'],
      groupId: data['groupId'],
      studentIds: data['studentIds'] == null
          ? null
          : (data['studentIds'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
    );
  }
}
