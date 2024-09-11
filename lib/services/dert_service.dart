import 'dart:math';

import 'package:dert/model/dert_model.dart';
import 'package:dert/services/firebase_service_provider.dart';
import 'package:dert/services/handler_errors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DertService with ChangeNotifier {
  FirebaseFirestore get _db => FirebaseServiceProvider().firestore;

  Future<DertModel?> getDert(String dertId) async {
    return handleErrors(
      operation: () async {
        DocumentSnapshot<Map<String, dynamic>> dertDoc =
            await _db.collection("derts").doc(dertId).get();

        if (dertDoc.exists) {
          return DertModel.fromFirestore(dertDoc);
        } else {
          debugPrint("Dert document does not exist for dertId: $dertId");
          return null;
        }
      },
      onError: (e) {
        debugPrint("Error fetching user data: $e");
        throw Exception("Kullanıcı bilgilerini çekerken hata oluştu: $e");
      },
    );
  }

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

  Future<DertModel?> findRandomDert(String userId) async {
    return handleErrors(
      operation: () async {
        QuerySnapshot dertSnapshot = await _db
            .collection('derts')
            .where('userId', isNotEqualTo: userId)
            .get();

        if (dertSnapshot.docs.isEmpty) {
          throw Exception("Hiç dert bulunamadı");
        }

        Random random = Random();
        int randomIndex = random.nextInt(dertSnapshot.docs.length);
        DocumentSnapshot randomDertDoc = dertSnapshot.docs[randomIndex];

        DertModel? randomDert = DertModel.fromFirestore(randomDertDoc);

        return randomDert;
      },
      onError: (e) {
        throw Exception("Rastgele dert bulma hatası: $e");
      },
    );
  }

  Future<void> addDermanToDert(
      String userId, DertModel dert, DermanModel derman) async {
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

        await _db
            .collection('users')
            .doc(userId)
            .collection('my_dermans')
            .add(derman.toMap());
        notifyListeners();
      },
      onError: (e) {
        throw Exception("Derman ekleme hatası: $e");
      },
    );
  }

  Stream<List<DermanModel>> streamDerman(String userId) {
    try {
      return _db
          .collection('users')
          .doc(userId)
          .collection('my_dermans')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DermanModel.fromMap(doc.data()))
              .toList());
    } catch (e) {
      throw Exception("Dertleri akışa alma hatası: $e");
    }
  }

  Stream<List<DertModel>> getFollowedDerts(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('follows')
        .snapshots()
        .asyncExpand((followedSnapshot) {
      List<String> followedIds =
          followedSnapshot.docs.map((doc) => doc.id).toList();

      return _db
          .collection('derts')
          .where('userId', whereIn: followedIds)
          .where('isClosed', isEqualTo: false)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return DertModel.fromFirestore(doc);
        }).toList();
      });
    });
  }

  Future<void> addBipToDert(String dertId, String userId) async {
    return handleErrors(
      operation: () async {
        DocumentReference dertRef = _db.collection('derts').doc(dertId);
        DocumentReference userDertRef = _db
            .collection('users')
            .doc(userId)
            .collection('my_derts')
            .doc(dertId);

        await _db.runTransaction((transaction) async {
          DocumentSnapshot dertSnapshot = await transaction.get(dertRef);
          if (!dertSnapshot.exists) {
            throw Exception("Dert bulunamadı!");
          }

          DocumentSnapshot userDertSnapshot =
              await transaction.get(userDertRef);
          if (!userDertSnapshot.exists) {
            throw Exception("Kullanıcının derti bulunamadı!");
          }

          int currentBips = dertSnapshot.get('bips') ?? 0;
          int userCurrentBips = userDertSnapshot.get('bips') ?? 0;

          transaction.update(dertRef, {'bips': currentBips + 1});
          transaction.update(userDertRef, {'bips': userCurrentBips + 1});
        });

        notifyListeners();
      },
      onError: (e) {
        throw Exception("Bip ekleme hatası: $e");
      },
    );
  }

  Future<void> closeDertAndApproveDerman(
      String dertId, String dermanId, String userId) async {
    return handleErrors(
      operation: () async {
        DocumentReference dertRef = _db.collection('derts').doc(dertId);
        DocumentReference userDertRef = _db
            .collection('users')
            .doc(userId)
            .collection('my_derts')
            .doc(dertId);

        await _db.runTransaction((transaction) async {
          DocumentSnapshot dertSnapshot = await transaction.get(dertRef);
          if (!dertSnapshot.exists) {
            throw Exception("Dert bulunamadı!");
          }

          DocumentSnapshot userDertSnapshot =
              await transaction.get(userDertRef);
          if (!userDertSnapshot.exists) {
            throw Exception("Kullanıcının derti bulunamadı!");
          }

          transaction.update(dertRef, {'isClosed': true});
          transaction.update(userDertRef, {'isClosed': true});

          List<dynamic> dermans = dertSnapshot.get('dermans') ?? [];
          dermans = dermans.map((dermanData) {
            if (dermanData['dermanId'] == dermanId) {
              return {
                ...dermanData,
                'isApproved': true,
              };
            }
            return dermanData;
          }).toList();

          transaction.update(dertRef, {'dermans': dermans});
          transaction.update(userDertRef, {'dermans': dermans});
        });

        notifyListeners();
      },
      onError: (e) {
        throw Exception("Dert ve Derman güncelleme hatası: $e");
      },
    );
  }
}
