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
