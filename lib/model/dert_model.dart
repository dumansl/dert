import 'package:cloud_firestore/cloud_firestore.dart';

class DertModel {
  final String dert;
  final bool isConfirmed;
  final List<DermanModel> derman;
  final int bip;

  DertModel({
    required this.dert,
    required this.isConfirmed,
    required this.derman,
    required this.bip,
  });

  factory DertModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final dermanList = (data['derman'] as List<dynamic>)
        .map((item) => DermanModel.fromMap(item as Map<String, dynamic>))
        .toList();

    return DertModel(
      dert: data['dert'] ?? '',
      isConfirmed: data['isConfirmed'] ?? false,
      derman: dermanList,
      bip: data['bip'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dert': dert,
      'isConfirmed': isConfirmed,
      'derman': derman.map((item) => item.toMap()).toList(),
      'bip': bip,
    };
  }

  @override
  String toString() {
    return 'DertModel(dert: $dert, isConfirmed: $isConfirmed, bip: $bip, derman: [${derman.map((d) => d.toString()).join(', ')}])';
  }
}

class DermanModel {
  final String derman;
  final bool isSolution;

  DermanModel({
    required this.derman,
    required this.isSolution,
  });

  factory DermanModel.fromMap(Map<String, dynamic> map) {
    return DermanModel(
      derman: map['derman'] ?? '',
      isSolution: map['isSolution'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'derman': derman,
      'isSolution': isSolution,
    };
  }

  @override
  String toString() {
    return 'DermanModel(derman: $derman, isSolution: $isSolution)';
  }
}
