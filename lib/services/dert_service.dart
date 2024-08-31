import 'dart:math';

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
        String newDertId = _db.collection('derts').doc().id;

        dert.dertId = newDertId;
        await _db
            .collection('users')
            .doc(userId)
            .collection('my_derts')
            .doc(newDertId)
            .set(dert.toMap());
        await _db.collection('derts').doc(newDertId).set(dert.toMap());
        notifyListeners();
      },
      onError: (e) {
        throw Exception("Dert ekleme hatası: $e");
      },
    );
  }

  Stream<List<DertModel>> streamDerts(String userId) {
    try {
      return _db
          .collection('users')
          .doc(userId)
          .collection('my_derts')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DertModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      throw Exception("Dertleri akışa alma hatası: $e");
    }
  }

  Future<DertModel?> findRandomDert() async {
    return handleErrors(
      operation: () async {
        QuerySnapshot dertSnapshot = await _db.collection('derts').get();

        if (dertSnapshot.docs.isEmpty) {
          throw Exception("Hiç dert bulunamadı");
        }

        Random random = Random();
        int randomIndex = random.nextInt(dertSnapshot.docs.length);
        DocumentSnapshot randomDertDoc = dertSnapshot.docs[randomIndex];

        DertModel? derts = DertModel.fromFirestore(randomDertDoc);

        return derts;
      },
      onError: (e) {
        throw Exception("Rastgele dert bulma hatası: $e");
      },
    );
  }

  Future<void> addDermanToDert(DertModel dert, DermanModel derman) async {
    return handleErrors(
      operation: () async {
        dert.dermans.add(derman);

        await _db
            .collection('derts')
            .doc(dert.dertId)
            .update({'dermans': dert.dermans.map((d) => d.toMap()).toList()});

        await _db
            .collection('users')
            .doc(dert.userId)
            .collection('my_derts')
            .doc(dert.dertId)
            .update({'dermans': dert.dermans.map((d) => d.toMap()).toList()});
        notifyListeners();
      },
      onError: (e) {
        throw Exception("Derman ekleme hatası: $e");
      },
    );
  }
}
