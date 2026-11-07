class User {
  final String imagePath;
  final String name;
  final String email;
  final String phone;
  final String about;
  final String birthday;

  const User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.phone,
    required this.about,
    required this.birthday,
  });

  User copy({
    String? imagePath,
    String? name,
    String? email,
    String? phone,
    String? about,
    String? birthday,
  }) {
    return User(
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      about: about ?? this.about,
      birthday: birthday ?? this.birthday,
    );
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      imagePath: json['imagePath'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      about: json['about'] ?? '',
      birthday: json['birthday'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'name': name,
      'email': email,
      'phone': phone,
      'about': about,
      'birthday': birthday,
    };
  }
}