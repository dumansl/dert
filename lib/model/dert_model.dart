import 'package:cloud_firestore/cloud_firestore.dart';

class DertModel {
  final String? dertId;
  final String content;
  final bool isClosed;
  final String? selectedSolution;
  final int timestamp;
  final List<DermanModel> dermans;
  final int bips;
  final String userId;

  DertModel({
    this.dertId,
    required this.content,
    required this.isClosed,
    required this.dermans,
    required this.bips,
    required this.timestamp,
    this.selectedSolution,
    required this.userId,
  });

  factory DertModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // `dermans` alanını kontrol ediyoruz. Eğer null ise boş bir liste atıyoruz.
    final dermanList = (data['dermans'] as List<dynamic>?)
            ?.map((item) => DermanModel.fromMap(item as Map<String, dynamic>))
            .toList() ??
        [];

    return DertModel(
      dertId: doc.id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      isClosed: data['isClosed'] ?? false,
      dermans: dermanList,
      bips: data['bips'] ?? 0,
      selectedSolution: data['selectedSolution'] ?? '',
      timestamp: data['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'isClosed': isClosed,
      'derman': dermans.map((item) => item.toMap()).toList(),
      'bips': bips,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'DertModel(content: $content, isClosed: $isClosed, bips: $bips, derman: [${dermans.map((d) => d.toString()).join(', ')}])';
  }
}

class DermanModel {
  final int userId;
  final String content;
  final bool isApproved;
  final int timestamp;

  DermanModel({
    required this.userId,
    required this.content,
    required this.isApproved,
    required this.timestamp,
  });

  factory DermanModel.fromMap(Map<String, dynamic> map) {
    return DermanModel(
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      isApproved: map['isApproved'] ?? false,
      timestamp: map['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'isApproved': isApproved,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'DermanModel(content: $content, isApproved: $isApproved)';
  }
}
