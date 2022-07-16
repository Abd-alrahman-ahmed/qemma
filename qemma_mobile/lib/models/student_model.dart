// -- student.dart --
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qemma_mobile/models/account_status_enum.dart';
import 'package:qemma_mobile/models/gender_enum.dart';
import 'package:qemma_mobile/models/year_enum.dart';

class Student {
  String id;
  String code;
  String name;
  String? phoneNumber;
  Gender gender;
  Year year;
  num degree;
  num totalDegree;
  AccountStatus status;
  DateTime registrationDate;
  List<String>? groupIds;
  List<String>? lessonIds;

  Student({
    required this.id,
    required this.code,
    required this.name,
    required this.phoneNumber,
    required this.gender,
    required this.year,
    required this.degree,
    required this.totalDegree,
    required this.status,
    required this.registrationDate,
    this.groupIds,
    this.lessonIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'phoneNumber': phoneNumber,
      'gender': gender.index,
      'year': year.index,
      'degree': degree,
      'totalDegree': totalDegree,
      'status': status.index,
      'registrationDate': registrationDate,
      'groupIds': groupIds,
      'lessonIds': lessonIds
    };
  }

  factory Student.fromJson(Map<String, dynamic> data) {
    return Student(
      id: data['id'],
      code: data['code'],
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      gender: Gender.values[data['gender']],
      year: Year.values[data['year']],
      degree: data['degree'],
      totalDegree: data['totalDegree'],
      status: AccountStatus.values[data['status']],
      registrationDate: (data['registrationDate'] as Timestamp).toDate(),
      groupIds: data['groupIds'] == null
          ? null
          : (data['groupIds'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
      lessonIds: data['lessonIds'] == null
          ? null
          : (data['lessonIds'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
    );
  }
}
