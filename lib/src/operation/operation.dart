import 'package:tainopersonnel/src/class/api.dart';
import 'package:tainopersonnel/src/class/report.dart';
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

Future<bool> createDailyReport(AppState state) async {
  try {
    await API.sendDailyReport(state);
  } catch (e) {
    rethrow;
  }

  TainoPersonnelDatabase.insertReport(state.report);
  return true;
}

Future<List<Report>> getDailyReports(int limit, AppState state) async {
  String? date;

  var reports = await TainoPersonnelDatabase.getReports(limit: 1);
  if (reports.isNotEmpty) {
    date = DateTime.parse(reports[0].day)
        .add(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);
  }

  var newReports = await API.getDailyReports(state, date);
  if (newReports.isNotEmpty) {
    await TainoPersonnelDatabase.insertReports(newReports);
  }
  reports = await TainoPersonnelDatabase.getReports(limit: limit);

  return reports;
}

Future<Report> getDailyReport(int id, AppState state) async {
  var report = await API.getDailyReport(state, id);
  await TainoPersonnelDatabase.updateReport(report);

  return Future.value(report);
}

Future<bool> updateDailyReport(AppState state) async {
  try {
    await API.sendDailyReport(state);
  } catch (e) {
    rethrow;
  }

  TainoPersonnelDatabase.insertReport(state.report);
  return true;
}
