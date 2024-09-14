import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dert/model/dert_model.dart';
import 'package:dert/services/firebase_service_provider.dart';
import 'package:dert/services/handler_errors.dart';

class DertService with ChangeNotifier {
  FirebaseFirestore get _db => FirebaseServiceProvider().firestore;

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
        debugPrint("Error fetching dert data: $e");
        throw Exception("Dert bilgilerini çekerken hata oluştu: $e");
      },
    );
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

  Future<void> deleteDert(String dertId, String userId) async {
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
          DocumentSnapshot userDertSnapshot =
              await transaction.get(userDertRef);

          if (!dertSnapshot.exists || !userDertSnapshot.exists) {
            throw Exception("Silinecek dert bulunamadı!");
          }

          transaction.delete(dertRef);
          transaction.delete(userDertRef);
        });

        notifyListeners();
      },
      onError: (e) {
        throw Exception("Dert silme hatası: $e");
      },
    );
  }

  Future<List<DermanModel>> getDermansForDert(String dertId) async {
    return handleErrors(
      operation: () async {
        QuerySnapshot dermanSnapshot = await _db
            .collection('derts')
            .doc(dertId)
            .collection('dermans')
            .get();

        return dermanSnapshot.docs
            .map((doc) => DermanModel.fromFirestore(doc))
            .toList();
      },
      onError: (e) {
        throw Exception("Dermanları alma hatası: $e");
      },
    );
  }

  Future<void> addDermanToDert(
      String userId, DertModel dert, DermanModel derman) async {
    return handleErrors(
      operation: () async {
        String dermanId = _db
            .collection('derts')
            .doc(dert.dertId)
            .collection('dermans')
            .doc()
            .id;

        derman.dermanId = dermanId;

        await _db
            .collection('derts')
            .doc(dert.dertId)
            .collection('dermans')
            .doc(dermanId)
            .set(derman.toMap());
        await _db
            .collection('users')
            .doc(dert.userId)
            .collection('my_derts')
            .doc(dert.dertId)
            .collection('dermans')
            .doc(dermanId)
            .set(derman.toMap());

        notifyListeners();
      },
      onError: (e) {
        throw Exception("Derman ekleme hatası: $e");
      },
    );
  }

  Future<void> addBipToDert(
    String dertId,
    String userId,
  ) async {
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

  // Future<void> addReactionToDert(
  //     {required String userId,
  //     required DertModel dert,
  //     DermanModel? derman,
  //     required String reactionType}) async {
  //   return handleErrors(
  //     operation: () async {
  //       DocumentReference userReactionRef = _db
  //           .collection('users')
  //           .doc(userId)
  //           .collection('user_reactions')
  //           .doc(dert.dertId);

  //       DocumentSnapshot reactionSnapshot = await userReactionRef.get();

  //       if (reactionSnapshot.exists) {
  //         throw Exception("Bu derde zaten tepki verdiniz.");
  //       }

  //       await userReactionRef.set({
  //         'reactionType': reactionType,
  //         'timestamp': DateTime.now().millisecondsSinceEpoch,
  //       });

  //       if (reactionType == 'bip') {
  //         await addBipToDert(dert.dertId!, userId);
  //       } else if (reactionType == 'derman') {
  //         await addDermanToDert(userId, dert, derman!);
  //       }
  //     },
  //     onError: (e) {
  //       throw Exception("Tepki ekleme hatası: $e");
  //     },
  //   );
  // }

  Stream<List<DermanModel>> streamDerman(String dertId) {
    return _db
        .collection('derts')
        .doc(dertId)
        .collection('dermans')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DermanModel.fromFirestore(doc))
            .toList());
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

  Future<void> closeDertAndApproveDerman(String dertId, String dermanId) async {
    return handleErrors(
      operation: () async {
        DocumentReference dertRef = _db.collection('derts').doc(dertId);

        DocumentReference dermanRef =
            dertRef.collection('dermans').doc(dermanId);

        await _db.runTransaction((transaction) async {
          DocumentSnapshot dertSnapshot = await transaction.get(dertRef);
          DocumentSnapshot dermanSnapshot = await transaction.get(dermanRef);

          if (!dertSnapshot.exists || !dermanSnapshot.exists) {
            throw Exception("Dert veya derman bulunamadı!");
          }

          transaction.update(dertRef, {'isClosed': true});
          transaction.update(dermanRef, {'isApproved': true});
        });

        notifyListeners();
      },
      onError: (e) {
        debugPrint("Error fetching dert data: $e");
        throw Exception("Dert ve Derman güncelleme hatası: $e");
      },
    );
  }

  Future<void> closeUserDertAndApproveDerman(
      String dertId, String dermanId, String userId) async {
    return handleErrors(
      operation: () async {
        DocumentReference userDertRef =
            _db.collection('users').doc(userId).collection('derts').doc(dertId);

        DocumentReference userDermanRef =
            userDertRef.collection('dermans').doc(dermanId);

        await _db.runTransaction((transaction) async {
          DocumentSnapshot userDertSnapshot =
              await transaction.get(userDermanRef);
          DocumentSnapshot userDermanSnapshot =
              await transaction.get(userDermanRef);

          if (!userDertSnapshot.exists || !userDermanSnapshot.exists) {
            throw Exception("Dert veya derman bulunamadı!");
          }

          transaction.update(userDertRef, {'isClosed': true});
          transaction.update(userDermanRef, {'isApproved': true});
        });

        notifyListeners();
      },
      onError: (e) {
        debugPrint("Error fetching dert data: $e");
        throw Exception("Dert ve Derman güncelleme hatası: $e");
      },
    );
  }
}
