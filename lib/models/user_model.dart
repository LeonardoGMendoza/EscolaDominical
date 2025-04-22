class UserModel {
  final String uid;
  final String name;
  final String email;
  final String calling;
  final String organization;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.calling,
    required this.organization,
    this.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      calling: data['calling'] ?? 'Membro',
      organization: data['organization'] ?? 'Geral',
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'calling': calling,
      'organization': organization,
      'photoUrl': photoUrl,
    };
  }
}