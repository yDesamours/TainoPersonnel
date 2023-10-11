class User {
  String lastname, firstname, username, password, role, tenant;
  int roleId, tenantId, id;

  User({
    this.lastname = '',
    this.firstname = '',
    this.roleId = 0,
    this.role = '',
    this.username = '',
    this.password = '',
    this.tenant = '',
    this.tenantId = 0,
    this.id = 0,
  });
}
