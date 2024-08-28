import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dert/model/follow_model.dart';
import 'package:dert/services/firebase_service_provider.dart';
import 'package:dert/services/handler_errors.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  FirebaseFirestore get _db => FirebaseServiceProvider().firestore;

  Future<List<FollowModel>> getFollowers(String userId) async {
    return handleErrors(
      operation: () async {
        List<FollowModel> followers = [];
        final snapshot = await _db
            .collection('users')
            .doc(userId)
            .collection('followers')
            .get();

        for (var doc in snapshot.docs) {
          followers.add(FollowModel.fromMap(doc.data()));
        }
        notifyListeners();
        return followers;
      },
      onError: (e) {
        throw Exception("Takipçi getirme hatası: $e");
      },
    );
  }

  Future<List<FollowModel>> getFollows(String userId) async {
    return handleErrors(
      operation: () async {
        List<FollowModel> follows = [];
        final snapshot = await _db
            .collection('users')
            .doc(userId)
            .collection('follows')
            .get();

        for (var doc in snapshot.docs) {
          follows.add(FollowModel.fromMap(doc.data()));
        }
        notifyListeners();
        return follows;
      },
      onError: (e) {
        throw Exception("Takip ettiklerimi getirme hatası: $e");
      },
    );
  }
}
