class User {
  String lastname, firstname, username, password, role, token;
  int roleId, id;

  User({
    this.lastname = '',
    this.firstname = '',
    this.roleId = 0,
    this.role = '',
    this.username = '',
    this.password = '',
    this.id = 0,
    this.token = '',
  });
}
