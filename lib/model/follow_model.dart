class FollowModel {
  final String id;
  final String username;
  final String? profileImageUrl;
  final String? musicUrl;

  FollowModel({
    required this.id,
    required this.username,
    this.profileImageUrl,
    this.musicUrl,
  });

  factory FollowModel.fromMap(String id, Map<String, dynamic> data) {
    return FollowModel(
      id: id,
      username: data['username'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      musicUrl: data['musicUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (musicUrl != null) 'musicUrl': musicUrl,
    };
  }

  @override
  String toString() {
    return 'FollowModel(id: $id, username: $username, profileImageUrl: $profileImageUrl, musicUrl: $musicUrl)';
  }
}
