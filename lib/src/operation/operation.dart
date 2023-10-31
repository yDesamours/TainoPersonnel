import 'dart:io';

import 'package:tainopersonnel/src/model/api.dart';
import 'package:tainopersonnel/src/model/employee.dart';
import 'package:tainopersonnel/src/model/report.dart';
import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/model/tenant.dart';
import 'package:tainopersonnel/src/model/user.dart';
import 'package:tainopersonnel/src/data/database.dart';

class OperationOutcome {
  final bool success;
  final String message;

  const OperationOutcome({this.message = '', required this.success});
}

Future<void> login(String username, String password, AppState state) async {
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
  } on SocketException {
    return (user, tenant);
  } catch (e) {
    TainoPersonnelDatabase.deleteTenant();
    TainoPersonnelDatabase.deleteUser();

    return (null, null);
  }

  return (user, tenant);
}

Future<OperationOutcome> createDailyReport(AppState state) async {
  try {
    await API.sendDailyReport(state);
    TainoPersonnelDatabase.insertReport(state.report);
    return const OperationOutcome(success: true);
  } catch (e) {
    return OperationOutcome(success: false, message: e.toString());
  }
}

Future<List<Report>> getDailyReports(AppState state,
    {int limit = 10, offset = 0}) async {
  String? date;
  List<Report> reports;

  reports = await TainoPersonnelDatabase.getReports(state.empid,
      limit: limit, offset: offset);
  if (reports.isNotEmpty) {
    date = DateTime.parse(reports[0].day)
        .add(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);
  }

  try {
    var newReports = await API.getDailyReports(
      state,
      from: date,
      limit: limit,
      offset: offset,
    );
    if (newReports.isNotEmpty) {
      await TainoPersonnelDatabase.insertReports(newReports);
      reports = await TainoPersonnelDatabase.getReports(state.empid,
          limit: limit, offset: offset);
    }
  } catch (_) {}

  return reports;
}

Future<Report?> getDailyReport(int id, AppState state) async {
  try {
    var report = await API.getDailyReport(state, id);
    await TainoPersonnelDatabase.updateReport(report);

    return Future.value(report);
  } catch (_) {
    return null;
  }
}

Future<OperationOutcome> updateDailyReport(AppState state) async {
  try {
    await API.sendDailyReport(state);
    TainoPersonnelDatabase.insertReport(state.report);
    return const OperationOutcome(success: true);
  } catch (e) {
    return OperationOutcome(success: false, message: e.toString());
  }
}

Future<List<Employee>> getSubordonates(AppState state) async {
  var res = await API.getSubordonates(state);
  return res.map((e) => Employee.fromJSON(e)).toList();
}

Future<List<Employee>> getSubordonatesLastReportDate(AppState state) async {
  var res = await API.getSubordonatesLastReportDate(state);
  return res.map((e) => Employee.fromJSON(e)).toList();
}

String formatDate(String date) {
  if (date.isEmpty || date.startsWith('0001-')) {
    return "";
  }

  try {
    date = DateTime.parse(date).toLocal().toIso8601String().substring(0, 10);
    return date;
  } catch (_) {}
  return "";
}
