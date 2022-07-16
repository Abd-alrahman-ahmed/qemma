import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qemma_mobile/models/year_enum.dart';

class Group {
  String id;
  String name;
  String subject;
  Year year;
  List<GroupDates>? dates;
  num price;
  List<String>? studentIds;
  List<String>? lessonIds;

  Group({
    required this.id,
    required this.name,
    required this.subject,
    required this.year,
    this.dates,
    required this.price,
    this.studentIds,
    this.lessonIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'year': year.index,
      'price': price,
      'studentIds': studentIds,
      'lessonIds': lessonIds,
    };
  }

  factory Group.fromJson(Map<String, dynamic> data) {
    return Group(
      id: data['id'],
      name: data['name'],
      subject: data['subject'],
      year: Year.values[data['year']],
      dates: data['dates'] == null
          ? null
          : (data['dates'] as List<Map<String, dynamic>>)
              .map((e) => GroupDates.fromJson(e))
              .toList(),
      price: data['price'],
      studentIds: data['studentIds'] == null
          ? null
          : (data['studentIds'] as List<dynamic>)
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

// -- group_dates.dart --
class GroupDates {
  int day;
  DateTime startTime;

  GroupDates({
    required this.day,
    required this.startTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime': startTime,
    };
  }

  factory GroupDates.fromJson(Map<String, dynamic> data) {
    return GroupDates(
      day: data['day'],
      startTime: (data['startTime'] as Timestamp).toDate(),
    );
  }
}
