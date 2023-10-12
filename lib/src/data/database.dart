import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:tainopersonnel/src/class/user.dart';

class TainoPersonnelDatabase {
  static sql.Database? instance;
  static const databaseName = 'tainopersonnel.db';
  static const userTable = 'user';

  static Future<sql.Database> get localDatabase async {
    if (instance != null) {
      return instance!;
    }
    String databasePath = (await sql.getDatabasesPath());
    instance = await sql.openDatabase(
      path.join(databasePath, databaseName),
      version: 1,
      onCreate: _createDatabase,
    );

    return instance!;
  }

  static Future<void> _createDatabase(sql.Database database, int version) {
    return database.execute('''CREATE TABLE $userTable(
      id INTEGER,
      firstname TEXT,
      lastname TEXT,
      token TEXT,
      role TEXT,
      idrole int)''');
  }

  static Future<int> insertUser(User user) async {
    var database = await localDatabase;
    return database.insert(userTable, user.toJSON());
  }

  static Future<User?> getUser() async {
    var database = await localDatabase;
    var users = await database.query(userTable, limit: 1);
    if (users.isEmpty) {
      return null;
    }

    return users[0] as User;
  }
}
