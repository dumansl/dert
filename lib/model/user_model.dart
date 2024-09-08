import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String firstName;

  @HiveField(3)
  final String lastName;

  @HiveField(4)
  final String username;

  @HiveField(5)
  final String? profileImageUrl;

  @HiveField(6)
  final String gender;

  @HiveField(7)
  final int birthdate;

  @HiveField(8)
  final String? musicUrl;

  final int? points;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.profileImageUrl,
    required this.gender,
    required this.birthdate,
    this.musicUrl,
    this.points,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      username: map['username'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      gender: map['gender'] ?? '',
      birthdate: map['birthdate'] ?? 0,
      musicUrl: map['musicUrl'] ?? "",
      points: map['points'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, firstName: $firstName, lastName: $lastName, username: $username, profileImageUrl: $profileImageUrl, gender: $gender, birthdate: $birthdate, musicUrl: $musicUrl)';
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'gender': gender,
      'birthdate': birthdate,
      'musicUrl': musicUrl,
      'points': points,
    };
  }
}
