class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? avatarUrl;

  const UserModel({this.id, required this.name, required this.email, this.avatarUrl});

  UserModel copyWith({int? id, String? name, String? email, String? avatarUrl}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
    }..removeWhere((key, value) => value == null);
  }
}
