class Creator {
  final String? id;
  final String? name;
  final String? email;
  final String? password;

  Creator({this.id, this.name, this.email, this.password});

  factory Creator.fromMap(Map<String, dynamic> json) => Creator(
        id: json["_id"] as String,
        name: json["name"] as String,
        email: json["email"] as String,
        password: json["password"] as String,
      );
}
