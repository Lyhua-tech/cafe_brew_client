class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? gender;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['profileImage'] ?? json['avatar'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
    );
  }

  User copyWith({
    String? name,
    String? email,
    String? avatar,
    String? phoneNumber,
    String? dateOfBirth,
    String? gender,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    };
  }
}
