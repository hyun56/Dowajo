import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dowajo/components/models/injectModel.dart';

class InjectDatabaseHelper {
  static const _databaseName = "InjectDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'inject_table';

  static const columnId = 'id';
  static const columnType = 'injectType';
  static const columnName = 'injectName';
  static const columnPicture = 'injectPicture';
  static const columnDay = 'injectDay';
  static const columnStartTime = 'injectStartTime';
  static const columnEndTime = 'injectEndTime';
  static const columnAmount = 'injectAmount';
  static const columnChange = 'injectChange';

  // Singleton class
  InjectDatabaseHelper._privateConstructor();
  static final InjectDatabaseHelper instance =
      InjectDatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnType TEXT NOT NULL,
            $columnName TEXT NOT NULL,
            $columnPicture TEXT NOT NULL,
            $columnDay TEXT NOT NULL,
            $columnStartTime TEXT NOT NULL,
            $columnEndTime TEXT NOT NULL DEFAULT '{}',
            $columnAmount TEXT NOT NULL,
            $columnChange BOOL NOT NULL
          )
          ''');
  }

  Future<int> insert(InjectModel inject) async {
    Database db = await database;
    int id = await db.insert(table, inject.toMap());
    return id;
  }

  Future<List<InjectModel>> getAllInjects() async {
    //final db = await instance.database;
    //var res = await db.query(table);
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return InjectModel(
          id: maps[i]['id'],
          injectType: maps[i]['injectType'],
          injectName: maps[i]['injectName'],
          injectPicture: maps[i]['injectPicture'],
          injectDay: maps[i]['injectDay'],
          injectStartTime: maps[i]['injectStartTime'],
          injectAmount: maps[i]['injectAmount'],
          injectChange: maps[i]['injectChange'] == 1,
          // injectEndTime: jsonEncode(
          //     (jsonDecode(maps[i][columnEndTime].toString()) as Map)
          //         .map((key, value) => MapEntry(key, value == 1))),
          injectEndTime: maps[i]['injectEndTime']);
    });
  }

  Future<int> update(InjectModel inject) async {
    Database? db = await instance.database;
    return await db.update(
      table,
      inject.toMap(),
      where: '$columnId = ?',
      whereArgs: [inject.id],
    );
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
  //getIsTaken, updateIsTaken, getMedicineCountOnDay,
  //getTakenDates, updateTakenDates, getTimeFromDatabase
  //후일 사용
}
