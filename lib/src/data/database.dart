import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:tainopersonnel/src/model/report.dart';
import 'package:tainopersonnel/src/model/tenant.dart';
import 'package:tainopersonnel/src/model/user.dart';

class TainoPersonnelDatabase {
  static sql.Database? instance;
  static const databaseName = 'tainopersonnel.db';
  static const userTable = 'user';
  static const tenantTable = 'tenant';
  static const reportTable = 'reports';

  static Future<sql.Database> get localDatabase async {
    if (instance != null) {
      return instance!;
    }
    String databasePath = (await sql.getDatabasesPath());
    instance = await sql.openDatabase(
      path.join(databasePath, databaseName),
      version: 2,
      onCreate: _createDatabase,
      onUpgrade: (db, oldVersion, newVersion) => _createDatabase(db, 2),
    );

    return instance!;
  }

  static Future<void> _createDatabase(
      sql.Database database, int version) async {
    await database.execute('''
    CREATE TABLE $userTable(
      id INTEGER,
      firstname TEXT,
      lastname TEXT,
      username TEXT,
      password TEXT,
      token TEXT,
      role TEXT,
      idrole int,
      empid int
    )''');

    await database.execute('''
    CREATE TABLE $tenantTable(
      id INTEGER,
      name TEXT,
      logo TEXT
    )''');

    await database.execute('''
    CREATE TABLE $reportTable(
      id INTEGER UNIQUE,
      empid INTEGER,
      content TEXT,
      dayreport TEXT,
      createdat TEXT
    )''');
  }

  static Future<int> insertUser(User user) async {
    var database = await localDatabase;
    return database.insert(userTable, user.toJSON());
  }

  static Future<int> insertTenant(Tenant tenant) async {
    var database = await localDatabase;
    return database.insert(tenantTable, tenant.toJSON());
  }

  static Future<User?> getUser() async {
    var database = await localDatabase;

    var users = await database.query(userTable, limit: 1);
    if (users.isEmpty) {
      return null;
    }

    return User.fromJSON(users[0]);
  }

  static Future<Tenant?> getTenant() async {
    var database = await localDatabase;

    var tenants = await database.query(tenantTable, limit: 1);
    if (tenants.isEmpty) {
      return null;
    }

    return Tenant.fromJSON(tenants[0]);
  }

  static void deleteUser() async {
    var database = await localDatabase;

    await database.delete(userTable);
  }

  static void deleteTenant() async {
    var database = await localDatabase;

    await database.delete(tenantTable);
  }

  static Future<List<Report>> getReports(int empId,
      {int offset = 0, int limit = 10}) async {
    var database = await localDatabase;

    var reports = await database.query(
      reportTable,
      limit: limit,
      offset: offset,
      orderBy: '${Report.dayColumn} DESC',
      where: "empid=?",
      whereArgs: [empId],
    );

    return reports.map((e) => Report.fromJSON(e)).toList();
  }

  static Future<int> insertReport(Report report) async {
    var database = await localDatabase;

    var x = await database.rawQuery('SELECT MIN(id) FROM $reportTable');

    return database.insert(reportTable, report.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertReports(List<dynamic> reports) async {
    var database = await localDatabase;

    for (dynamic r in reports) {
      await database.insert(reportTable, Report.fromJSON(r).toJSON(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<int> updateReport(Report report) async {
    var database = await localDatabase;

    return database.update(reportTable, report.toJSON(),
        where: 'id=?', whereArgs: [report.id]);
  }
}
