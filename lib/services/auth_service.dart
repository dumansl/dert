import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/services/firebase_service_provider.dart';
import 'package:dert/services/handler_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth get _auth => FirebaseServiceProvider().auth;
  FirebaseFirestore get _db => FirebaseServiceProvider().firestore;
  User? get currentUser => _auth.currentUser;
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

  Future<void> registerUser({
    required User? user,
    required String name,
    required String lastName,
    required String email,
    required String username,
    required String gender,
    required int birthdate,
  }) async {
    return handleErrors(
      operation: () async {
        await _db.collection("users").doc(user!.uid).set({
          'firstName': name,
          'lastName': lastName,
          'email': email,
          "username": username,
          "gender": gender,
          "birthdate": birthdate,
        });
      },
      onError: (e) {
        debugPrint('Error registering user: $e');
        throw e;
      },
    );
  }

  // Giriş yapma işlemi
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    return handleErrors(
      operation: () async {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        notifyListeners();
        debugPrint(user?.uid);

        if (user != null) {
          DocumentSnapshot<Map<String, dynamic>> userDoc =
              await _db.collection("users").doc(user.uid).get();

          if (userDoc.exists) {
            UserModel userModel = UserModel.fromMap(userDoc.data()!, user.uid);
            return userModel;
          } else {
            throw Exception("Kullanıcı verisi bulunamadı.");
          }
        } else {
          throw Exception("Kullanıcı bulunamadı.");
        }
      },
      onError: (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'invalid-email') {
            throw Exception(
                'E-posta adresi geçersizdir, bilgilerinizi kontrol ediniz.');
          } else if (e.code == 'invalid-credential') {
            throw Exception(
                'Kimlik doğrulama bilgileriniz yanlış, bilgilerinizi kontrol ediniz.');
          } else {
            throw Exception("Bir hata oluştu: ${e.message}");
          }
        }
        debugPrint("Giriş hatası: $e");
        return;
      },
    );
  }

  Future<User?> createUserWithEmailAndPassword({
    required String name,
    required String lastName,
    required String email,
    required String password,
    required String username,
    required String gender,
    required int birthdate,
  }) async {
    return handleErrors(
      operation: () async {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;
        if (user != null) {
          await registerUser(
            user: user,
            name: name,
            lastName: lastName,
            email: email,
            username: username,
            gender: gender,
            birthdate: birthdate,
          );
        }
        notifyListeners();
        return user;
      },
      onError: (e) {
        if (e is FirebaseAuthException) {
          if (e.code == "weak-password") {
            throw Exception("Bu şifre çok zayıf");
          } else if (e.code == "email-already-in-use") {
            throw Exception("Bu e-posta için hesap zaten mevcut");
          } else {
            throw Exception("Bir hata oluştu: ${e.message}");
          }
        }
        debugPrint("Kaydolma hatası: $e");
      },
    );
  }

  Future<String?> uploadProfileImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final storageRef =
            storage.ref().child('profile_images/${currentUser!.uid}');
        final uploadTask = storageRef.putFile(File(pickedFile.path));

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        await _db.collection('users').doc(currentUser!.uid).update({
          'profileImageUrl': downloadUrl,
        });

        return downloadUrl;
      } else {
        debugPrint("Resim seçilmedi.");
        return null;
      }
    } catch (e) {
      debugPrint("Profil fotoğrafı yüklenirken bir hata oluştu: $e");
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    return handleErrors(
      operation: () async {
        await _auth.sendPasswordResetEmail(email: email);
        notifyListeners();
      },
      onError: (e) {
        debugPrint("Şifre sıfırlama hatası: $e");
        throw Exception("Şifre sıfırlama işlemi başarısız oldu.");
      },
    );
  }

  Future<void> signOut() async {
    return handleErrors(
      operation: () async {
        await _auth.signOut();
        notifyListeners();
      },
      onError: (e) {
        debugPrint("Çıkış yapma hatası: $e");
        throw Exception("Çıkış yapma işlemi başarısız oldu.");
      },
    );
  }
}
