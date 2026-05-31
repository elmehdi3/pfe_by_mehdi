class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? profileImage;
  final String? bio;
  final String? gameRank;
  final String? favoriteGame;
  final List<String>? servers;
  final Map<String, List<String>>? availability;
  final bool onboardingCompleted;
  final double? reputationScore;
  final bool isOnline;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImage,
    this.bio,
    this.gameRank,
    this.favoriteGame,
    this.servers,
    this.availability,
    this.onboardingCompleted = false,
    this.reputationScore,
    this.isOnline = false,
  });

  factory UserModel.fromMap(dynamic id, Map<String, dynamic> data) {
    return UserModel(
      id: id is String ? int.parse(id) : id,
      fullName: data['fullName'] ?? data['pseudo'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profileImage'] ?? data['avatar'],
      bio: data['bio'],
      gameRank: data['gameRank'] ?? data['level'],
      favoriteGame: data['favoriteGame'],
      servers: data['servers'] != null
          ? List<String>.from(data['servers'])
          : (data['languages'] != null
                ? List<String>.from(data['languages'])
                : null),
      availability: data['availability'] is Map
          ? (data['availability'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            )
          : null,
      onboardingCompleted: data['onboardingCompleted'] ?? true,
      reputationScore: (data['reputationScore'] as num?)?.toDouble(),
      isOnline: data['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
      'bio': bio,
      'gameRank': gameRank,
      'favoriteGame': favoriteGame,
      'servers': servers,
      'availability': availability,
      'onboardingCompleted': onboardingCompleted,
    };
  }
}
