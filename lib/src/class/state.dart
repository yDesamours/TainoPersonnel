import 'package:flutter/material.dart';
import 'package:tainopersonnel/src/class/tenant.dart';

import 'package:tainopersonnel/src/class/user.dart';

class AppState extends ChangeNotifier {
  AppState(this.user);

  User? user;
  Tenant? tenant;
  String token = '';

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  void setTenant(Tenant tenant) {
    this.tenant = tenant;
    notifyListeners();
  }

  void logout() {
    user = null;
    tenant = null;
    token = '';
    notifyListeners();
  }
}
