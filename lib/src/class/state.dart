import 'package:flutter/material.dart';

import 'package:tainopersonnel/src/class/user.dart';

class AppState extends ChangeNotifier {
  User? user = User(
      firstname: "Theo",
      lastname: "Lanhi",
      tenant: "Tainosystems",
      id: 2,
      role: "comptable",
      tenantId: 4,
      roleId: 4);

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }
}
