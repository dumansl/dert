import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dert/services/firebase_service_provider.dart';
import 'package:dert/services/handler_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth get _auth => FirebaseServiceProvider().auth;
  FirebaseFirestore get _db => FirebaseServiceProvider().firestore;
  User? get currentUser => _auth.currentUser;

  // Kullanıcı bilgilerini kaydetme
  Future<void> registerUser({
    required User user,
    required String name,
    required String lastName,
    required String email,
  }) async {
    return handleErrors(
      operation: () async {
        await _db.collection("users").doc(user.uid).set({
          'firstName': name,
          'lastName': lastName,
          'email': email,
        });
      },
      onError: (e) {
        debugPrint('Error registering user: $e');
        throw e;
      },
    );
  }

  // Giriş yapma işlemi
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    return handleErrors(
      operation: () async {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        notifyListeners();
        debugPrint(userCredential.user?.uid);
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
      },
    );
  }

  // Kaydolma işlemi
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String lastName,
  }) async {
    return handleErrors(
      operation: () async {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;
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
}
