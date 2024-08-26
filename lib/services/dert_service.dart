import 'package:dert/model/dert_model.dart';
import 'package:dert/services/firebase_service_provider.dart';
import 'package:dert/services/handler_errors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DertService with ChangeNotifier {
  FirebaseFirestore get _db => FirebaseServiceProvider().firestore;

  Future<void> addDert(String userId, DertModel dert) async {
    return handleErrors(
      operation: () async {
        await _db
            .collection('users')
            .doc(userId)
            .collection('my_derts')
            .add(dert.toMap());
        notifyListeners();
      },
      onError: (e) {
        throw Exception("Dert ekleme hatası: $e");
      },
    );
  }

  Stream<List<DertModel>> streamDerts(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('my_derts')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => DertModel.fromFirestore(doc)).toList());
  }
}
