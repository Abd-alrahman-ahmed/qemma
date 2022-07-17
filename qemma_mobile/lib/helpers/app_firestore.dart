import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qemma_mobile/models/field_filter_model.dart';
import 'dart:io';

class FireStore {
  static Future<bool> checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isEmpty || result.first.rawAddress.isEmpty) {
        return false;
      }
      return true;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<T?> get<T>(String collection, String doc,
      T Function(Map<String, dynamic> element) mapper) async {
    try {
      if (!await checkNetwork()) return null;
      FirebaseFirestore db = FirebaseFirestore.instance;
      var result = await db.collection(collection).doc(doc).get();
      var d = result.data();
      if (d != null) d['id'] = result.id;
      return d != null ? mapper(d) : null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<T>?> getAll<T>(
    String collection,
    T Function(Map<String, dynamic> element) mapper,
    bool Function(T element) test,
  ) async {
    try {
      if (!await checkNetwork()) return null;
      FirebaseFirestore db = FirebaseFirestore.instance;
      var result = await db.collection(collection).get();
      return result.docs
          .where((doc) => doc.exists)
          .map((doc) {
            var d = doc.data();
            d['id'] = doc.id;
            return mapper(d);
          })
          .where(test)
          .toList();
    } catch (e) {
      return List.empty();
    }
  }

  static Future<List<T>?> getAllFiltered<T>(
    String collection,
    T Function(Map<String, dynamic> element) mapper,
    List<FieldFilter> filters,
  ) async {
    try {
      if (!await checkNetwork()) return null;
      FirebaseFirestore db = FirebaseFirestore.instance;
      Query<Map<String, dynamic>> query = db.collection(collection);
      for (var filter in filters) {
        query = query.where(
          filter.field,
          isEqualTo: filter.isEqualTo,
          isNotEqualTo: filter.isNotEqualTo,
          isLessThan: filter.isLessThan,
          isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
          isGreaterThan: filter.isGreaterThan,
          isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
          arrayContains: filter.arrayContains,
          arrayContainsAny: filter.arrayContainsAny,
          whereIn: filter.whereIn,
          whereNotIn: filter.whereNotIn,
          isNull: filter.isNull,
        );
      }
      var result = await query.get();
      return result.docs.where((doc) => doc.exists).map((doc) {
        var d = doc.data();
        d['id'] = doc.id;
        return mapper(d);
      }).toList();
    } catch (e) {
      return List.empty();
    }
  }

  static Future<String?> add(
      String collection, Map<String, dynamic> data) async {
    try {
      if (!await checkNetwork()) return null;
      FirebaseFirestore db = FirebaseFirestore.instance;
      var result = await db.collection(collection).add(data);
      return result.id;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> update(
      String collection, String doc, Map<String, dynamic> data) async {
    try {
      if (!await checkNetwork()) return false;
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection(collection).doc(doc).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class FirestoreCollections {
  static const String students = "students";
  static const String group = "qemma_groups";
  static const String lessons = "lessons";
  static const String studentLesson = "student_lessons";
  static const String event = "qemma_events";
  static const String locales = "locales";
  static const String degrees = "degrees_range";
}
