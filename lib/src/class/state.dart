import 'package:flutter/material.dart';
import 'package:tainopersonnel/src/class/report.dart';
import 'package:tainopersonnel/src/class/tenant.dart';

import 'package:tainopersonnel/src/class/user.dart';

class AppState extends ChangeNotifier {
  AppState(this.user, this.tenant);

  AppState.fromMemory((User?, Tenant?) data) : this(data.$1, data.$2);

  User? user;
  Tenant? tenant;
  Report report = Report();

  String get token => user?.token ?? '';
  String get username => user?.username ?? '';
  String get password => user?.password ?? '';

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
    notifyListeners();
  }
}
