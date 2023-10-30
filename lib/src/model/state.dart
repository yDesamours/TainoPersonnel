import 'package:flutter/material.dart';

import 'package:tainopersonnel/src/model/report.dart';
import 'package:tainopersonnel/src/model/tenant.dart';
import 'package:tainopersonnel/src/model/user.dart';
import 'package:connectivity/connectivity.dart';

class AppState extends ChangeNotifier {
  AppState(this.user, this.tenant);

  AppState.fromMemory((User?, Tenant?) data) : this(data.$1, data.$2);

  User? user;
  Tenant? tenant;
  Report report = Report();

  String get token => user?.token ?? '';
  String get username => user?.username ?? '';
  String get password => user?.password ?? '';
  int get empid => user?.empId ?? 0;
  int get userId => user?.id ?? 0;

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

class ConnectivityState extends ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityState() {
    Connectivity().onConnectivityChanged.listen((result) {
      _connectivityResult = result;
      notifyListeners();
    });
  }

  ConnectivityResult get connectivityResult => _connectivityResult;
  bool get isOnline => _connectivityResult != ConnectivityResult.none;
}
