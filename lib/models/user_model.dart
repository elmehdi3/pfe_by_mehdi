class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? profileImage;
  final String? gameRank;
  final String? favoriteGame;
  final List<String>? servers;
  final Map<String, List<String>>? availability;
  final bool onboardingCompleted;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImage,
    this.gameRank,
    this.favoriteGame,
    this.servers,
    this.availability,
    this.onboardingCompleted = false,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profileImage'],
      gameRank: data['gameRank'],
      favoriteGame: data['favoriteGame'],
      servers: data['servers'] != null
          ? List<String>.from(data['servers'])
          : null,
      availability: data['availability'] != null
          ? (data['availability'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            )
          : null,
      onboardingCompleted: data['onboardingCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
      'gameRank': gameRank,
      'favoriteGame': favoriteGame,
      'servers': servers,
      'availability': availability,
      'onboardingCompleted': onboardingCompleted,
    };
  }
}
