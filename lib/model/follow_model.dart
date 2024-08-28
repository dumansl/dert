class FollowModel {
  final String username;
  final String? profileImageUrl;
  final String? musicUrl;

  FollowModel({
    required this.username,
    this.profileImageUrl,
    this.musicUrl,
  });

  factory FollowModel.fromMap(Map<String, dynamic> map) {
    return FollowModel(
      username: map['username'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      musicUrl: map['musicUrl'],
    );
  }
}
