import 'package:dert/model/dert_model.dart';
import 'package:dert/services/firebase_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DertService with ChangeNotifier {
  FirebaseFirestore get _db => FirebaseServiceProvider().firestore;
  List<DertModel> derts = [];

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
