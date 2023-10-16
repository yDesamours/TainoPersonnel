class User {
  String lastname, firstname, username, password, role, token;
  int idRole, id;

  User({
    this.lastname = '',
    this.firstname = '',
    this.idRole = 0,
    this.role = '',
    this.username = '',
    this.password = '',
    this.id = 0,
    this.token = '',
  });

  User.fromJSON(Map<String, dynamic> json)
      : this(
          firstname: json['firstname'] ?? '',
          lastname: json['lastname'] ?? '',
          username: json['username'] ?? '',
          password: json['password'] ?? '',
          role: json['role'] ?? '',
          idRole: json['idrole'] ?? 0,
          id: json['id'],
        );

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "lastname": lastname,
      "firstname": firstname,
      "role": role,
      "idrole": idRole,
      "token": token,
      "username": username,
      "password": password
    };
  }
}
