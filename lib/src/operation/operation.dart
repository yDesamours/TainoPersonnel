import 'package:flutter/material.dart';
import 'package:tainopersonnel/src/class/api.dart';
import 'package:tainopersonnel/src/class/state.dart';
import 'package:tainopersonnel/src/class/tenant.dart';
import 'package:tainopersonnel/src/class/user.dart';
import 'package:tainopersonnel/src/data/database.dart';

void login(String username, String password, AppState state) async {
  var (user, tenant) = await API.login(username, password);

  state.setUser(user);
  state.setTenant(tenant);
  await TainoPersonnelDatabase.insertUser(user);
  await TainoPersonnelDatabase.insertTenant(tenant);
}

void logout(String token, AppState state) {
  API.logout(token);
  TainoPersonnelDatabase.deleteUser();
  TainoPersonnelDatabase.deleteTenant();
  state.logout();
}

Future<(User?, Tenant?)> launchApp() async {
  User? user = await TainoPersonnelDatabase.getUser();
  Tenant? tenant = await TainoPersonnelDatabase.getTenant();

  if (user == null) {
    return (null, null);
  }

  try {
    (user, tenant) = await API.login(user.username, user.password);
  } catch (e) {
    TainoPersonnelDatabase.deleteTenant();
    TainoPersonnelDatabase.deleteUser();

    return (null, null);
  }

  return (user, tenant);
}

void showModal(BuildContext context, Widget widget) {
  showModalBottomSheet(
    context: context,
    builder: (context) => widget,
  );
}
