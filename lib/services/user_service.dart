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
        QuerySnapshot snapshot = await _db
            .collection('users')
            .doc(userId)
            .collection('followers')
            .get();

        List<FollowModel> followers = snapshot.docs.map((doc) {
          return FollowModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>);
        }).toList();
        notifyListeners();

        return followers;
      },
      onError: (e) {
        throw Exception("Takipçi getirme hatası: $e");
      },
    );
  }

  Future<void> addFollower(String userId, FollowModel follow) async {
    return handleErrors(
      operation: () async {
        await _db
            .collection('users')
            .doc(userId)
            .collection('followers')
            .add(follow.toMap());
        notifyListeners();
      },
      onError: (e) {
        throw Exception("Takipçi ekleme hatası: $e");
      },
    );
  }

  Future<void> removeFollower(String userId, String followId) async {
    return handleErrors(
      operation: () async {
        await _db
            .collection('users')
            .doc(userId)
            .collection('followers')
            .doc(followId)
            .delete();
        notifyListeners();
      },
      onError: (e) {
        throw Exception("Takipçi çıkarma hatası: $e");
      },
    );
  }

  Future<List<FollowModel>> getFollows(String userId) async {
    return handleErrors(
      operation: () async {
        QuerySnapshot snapshot = await _db
            .collection('users')
            .doc(userId)
            .collection('follows')
            .get();

        List<FollowModel> follows = snapshot.docs.map((doc) {
          return FollowModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>);
        }).toList();
        notifyListeners();
        return follows;
      },
      onError: (e) {
        throw Exception("Takip ettiklerimi getirme hatası: $e");
      },
    );
  }

  Future<void> followUser(String userId, FollowModel follow) async {
    return handleErrors(
      operation: () async {
        await _db
            .collection('users')
            .doc(userId)
            .collection('follows')
            .add(follow.toMap());
        notifyListeners();
      },
      onError: (e) {
        throw Exception("Kullanıcıyı takip etme hatası: $e");
      },
    );
  }

  Future<void> unfollowUser(String userId, String followId) async {
    return handleErrors(
      operation: () async {
        await _db
            .collection('users')
            .doc(userId)
            .collection('follows')
            .doc(followId)
            .delete();
        notifyListeners();
      },
      onError: (e) {
        throw Exception("Takipten çıkma hatası: $e");
      },
    );
  }
}
