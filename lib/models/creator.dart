class Creator {
  final String? id;
  final String? email;
  final String? password;

  Creator({this.id, this.email, this.password});

  factory Creator.fromMap(Map<String, dynamic> json) => Creator(
        id: json["_id"] as String,
        email: json["email"] as String,
        password: json["password"] as String,
      );
}
