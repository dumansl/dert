class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final String? profileImageUrl;
  final String gender;
  final int birthdate;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.profileImageUrl,
    required this.gender,
    required this.birthdate,
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
    );
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
    };
  }
}
