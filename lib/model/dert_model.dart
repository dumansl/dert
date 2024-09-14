import 'package:cloud_firestore/cloud_firestore.dart';

class DertModel {
  String? dertId;
  final String content;
  final bool isClosed;
  final String? selectedSolution;
  final int timestamp;
  final int bips;
  final String userId;

  DertModel({
    this.dertId,
    required this.content,
    required this.isClosed,
    required this.bips,
    required this.timestamp,
    this.selectedSolution,
    required this.userId,
  });

  factory DertModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DertModel(
      dertId: doc.id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      isClosed: data['isClosed'] ?? false,
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
      'bips': bips,
      'timestamp': timestamp,
    };
  }
}

class DermanModel {
  String? dermanId;
  final String userId;
  final String dertId;
  final String content;
  final bool isApproved;
  final int timestamp;

  DermanModel({
    this.dermanId,
    required this.userId,
    required this.dertId,
    required this.content,
    required this.isApproved,
    required this.timestamp,
  });

  factory DermanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DermanModel(
      dermanId: doc.id,
      userId: data['userId'] ?? '',
      dertId: data['dertId'] ?? '',
      content: data['derman'] ?? '',
      isApproved: data['isApproved'] ?? false,
      timestamp: data['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'dertId': dertId,
      'derman': content,
      'isApproved': isApproved,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'DermanModel(content: $content, isApproved: $isApproved)';
  }
}
