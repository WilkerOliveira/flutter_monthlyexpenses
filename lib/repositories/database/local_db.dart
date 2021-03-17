import 'package:sqflite/sqflite.dart';
import 'package:summarizeddebts/model/user_model.dart';
import 'package:path/path.dart';

class LocalDB {

  static final LocalDB _instance = LocalDB._();
  static Database _database;
  static const _TB_USER = "tb_user";

  LocalDB._();

  factory LocalDB() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }

    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    var databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'se.db');

    var database = openDatabase(dbPath, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE $_TB_USER(
        userID TEXT PRIMARY KEY,
        email TEXT,        
        customLogin TEXT)
    ''');
    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<int> saveUser(UserModel user) async {
    var client = await db;

    await removeAll();
    var returnValue = client.insert(_TB_USER, user.toMapForDb(), conflictAlgorithm: ConflictAlgorithm.replace);

    return returnValue;
  }


  Future<UserModel> fetchUserData() async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps = client.query(_TB_USER);
    var maps = await futureMaps;

    if (maps.length != 0) {
      return UserModel.fromDb(maps.first);
    }

    return null;
  }

  Future<void> removeUser(String userId) async {
    var client = await db;
    return client.delete(_TB_USER, where: 'userID = ?', whereArgs: [userId]);
  }

  Future<void> removeAll() async {
    var client = await db;
    return client.delete(_TB_USER);
  }

  Future closeDb() async {
    var client = await db;
    client.close();
  }
}
