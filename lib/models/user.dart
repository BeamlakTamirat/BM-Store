class User {
  final String id;
  final String email;
  final String token;

  User({required this.id, required this.email, required this.token});

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'token': token};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], email: json['email'], token: json['token']);
  }
}
