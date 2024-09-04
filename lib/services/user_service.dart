import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dert/model/follow_model.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/services/firebase_service_provider.dart';
import 'package:dert/services/handler_errors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserService extends ChangeNotifier {
  FirebaseFirestore get _db => FirebaseServiceProvider().firestore;
  FirebaseStorage get storage => FirebaseServiceProvider().storage;

  Future<UserModel?> getUserById(String uid) async {
    return handleErrors(
      operation: () async {
        debugPrint("Fetching user document with UID: $uid");
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _db.collection("users").doc(uid).get();
        debugPrint("User document fetched: ${userDoc.data()}");

        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data()!, uid);
        } else {
          debugPrint("User document does not exist for UID: $uid");
          return null;
        }
      },
      onError: (e) {
        debugPrint("Error fetching user data: $e");
        throw Exception("Kullanıcı bilgilerini çekerken hata oluştu: $e");
      },
    );
  }

  Future<void> updateUserFields({
    required String userId,
    required Map<String, dynamic> updatedFields,
  }) async {
    return handleErrors(
      operation: () async {
        await _db.collection('users').doc(userId).update(updatedFields);
        notifyListeners();
      },
      onError: (e) {
        throw Exception("Kullanıcı bilgilerini güncelleme hatası: $e");
      },
    );
  }

  Future<String?> uploadProfileImage({required String userId}) async {
    return handleErrors(operation: () async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final storageRef = storage.ref().child('profile_images/$userId');
        final uploadTask = storageRef.putFile(File(pickedFile.path));

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        await _db.collection('users').doc(userId).update({
          'profileImageUrl': downloadUrl,
        });

        return downloadUrl;
      } else {
        debugPrint("Resim seçilmedi.");
        return null;
      }
    }, onError: (e) {
      throw Exception("Profil fotoğrafı yüklenirken bir hata oluştu: $e");
    });
  }

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
