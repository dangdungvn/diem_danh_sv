class User {
  final int id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? address;
  final String? dateOfBirth;
  final String? gender;
  final String? avatar;
  final String? avatarUrl;
  final String? bio;
  final bool isActive;
  final String dateJoined;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.avatar,
    this.avatarUrl,
    this.bio,
    required this.isActive,
    required this.dateJoined,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'],
      address: json['address'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      avatar: json['avatar'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      isActive: json['is_active'] ?? false,
      dateJoined: json['date_joined'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'avatar': avatar,
      'avatar_url': avatarUrl,
      'bio': bio,
      'is_active': isActive,
      'date_joined': dateJoined,
    };
  }
}
