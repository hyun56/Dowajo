// import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dowajo/components/models/nurse.dart';

class DatabaseHelper {
  static const _databaseName = "nurses.db";
  static const _databaseVersion = 3;

  static const table = 'nurse_table';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPassword = 'password';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      //onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
       id INTEGER,
       name TEXT,
       password TEXT NOT NULL)
       ''');
  }

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  //login
  Future<bool> login(Nurse nurse) async {
    Database? db = await instance.database;
    var result = await db!.rawQuery(
        "SELECT * FROM nurse_table where id ='${nurse.id}' AND password = '${nurse.password}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //signup
  Future<int> createNurse(Nurse nurse) async {
    Database? db = await instance.database;
    return db!.insert('nurse_table', nurse.toMap());
  }

  //id 중복 검사
  Future<bool> checkDuplicateId(String id) async {
    Database? db = await instance.database;
    var res = await db!.query('nurse_table', where: "id = ?", whereArgs: [id]);
    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Get all nurses
  Future<void> printAllNurses() async {
    final Database? db = await instance.database;
    List<Map<String, dynamic>> nurses = await db!.query(table);
    for (var nurse in nurses) {
      print(
          'ID: ${nurse['id']}, Name: ${nurse['name']}, Password: ${nurse['password']}');
    }
  }

  //Get current nurse details
  Future<Nurse?> getNurse(String id) async {
    final Database? db = await instance.database;
    var res = await db!.query('nurse_table', where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Nurse.fromMap(res.first) : null;
  }
}
