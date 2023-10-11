import 'package:flutter/material.dart';
import 'package:tainopersonnel/src/class/tenant.dart';

import 'package:tainopersonnel/src/class/user.dart';

class AppState extends ChangeNotifier {
  User? user = User(
      firstname: "Theo",
      lastname: "Lanhi",
      id: 2,
      role: "comptable",
      roleId: 4);

  Tenant? tenant = Tenant(name: 'Tainosystems');
  String token = '';

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  void setTenant(Tenant tenant) {
    this.tenant = tenant;
    notifyListeners();
  }
}
