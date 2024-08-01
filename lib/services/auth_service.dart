import 'package:dert/services/firebase_service_provider.dart';
import 'package:dert/services/handler_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth get _auth => FirebaseServiceProvider().auth;

  User? get currentUser => _auth.currentUser;

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
          debugPrint('Hata kodu: ${e.code}');
          debugPrint('Hata mesajı: ${e.message}');
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
}
