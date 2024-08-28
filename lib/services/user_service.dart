import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dert/services/firebase_service_provider.dart';
import 'package:dert/services/handler_errors.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  FirebaseFirestore get _firestore => FirebaseServiceProvider().firestore;

  Future<List<String>> fetchFollowers(String userId) async {
    return handleErrors(
      operation: () async {
        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('followers')
            .get();
        List<String> followers = snapshot.docs.map((doc) => doc.id).toList();
        notifyListeners();
        return followers;
      },
      onError: (e) {
        throw Exception('Error fetching followers: $e');
      },
    );
  }

  Future<List<String>> fetchFollows(String userId) async {
    return handleErrors(
      operation: () async {
        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('follows')
            .get();
        List<String> follows = snapshot.docs.map((doc) => doc.id).toList();
        notifyListeners();
        return follows;
      },
      onError: (e) {
        throw Exception('Error fetching follows: $e');
      },
    );
  }
}
