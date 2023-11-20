import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dowajo/components/models/medicine.dart';

class DatabaseHelper {
  static const _databaseName = "MedicineDatabase.db";
  static const _databaseVersion = 3;

  static const table = 'medicine_table';

  static const columnId = 'id';
  static const columnName = 'medicineName';
  static const columnPicture = 'medicinePicture';
  static const columnDay = 'medicineDay';
  static const columnRepeat = 'medicineRepeat';
  static const columnTime = 'medicineTime';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      //onUpgrade: _onUpgrade,
    );
  }

  // Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (newVersion > oldVersion) {
  //     // 기존에 isTaken 컬럼이 없었다면 추가합니다.
  //     await db.execute(
  //         "ALTER TABLE $table ADD COLUMN isTaken INTEGER NOT NULL DEFAULT 0");
  //   }
  // }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPicture TEXT NOT NULL,
            $columnDay TEXT NOT NULL,
            $columnRepeat INTEGER NOT NULL,
            $columnTime TEXT NOT NULL,
            isTaken INTEGER NOT NULL DEFAULT 0
          )
          ''');
  }

  Future<int> insert(Medicine medicine) async {
    Database? db = await instance.database;
    return await db!.insert(table, medicine.toMap());
  }

  Future<List<Medicine>> getAllMedicines() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(table);

    return List.generate(maps.length, (i) {
      return Medicine(
        id: maps[i]['id'],
        medicineName: maps[i]['medicineName'],
        medicinePicture: maps[i]['medicinePicture'],
        medicineDay: maps[i]['medicineDay'],
        medicineRepeat: maps[i]['medicineRepeat'],
        medicineTime: maps[i]['medicineTime'],
      );
    });
  }

  Future<int> update(Medicine medicine) async {
    Database? db = await instance.database;
    return await db!.update(
      table,
      medicine.toMap(),
      where: '$columnId = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> getIsTaken(int id) async {
    // 복용 완료 상태 가져오기
    final db = await database;
    final maps = await db!.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first['isTaken'] == 1;
    } else {
      return false;
    }
  }

  Future<void> updateIsTaken(int id, bool isTaken) async {
    Database? db = await instance.database;
    await db!.update(
      table,
      {'isTaken': isTaken ? 1 : 0},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Future<int?> getRemainingMedicineCount() async {
  //   final db = await database;
  //   final result = await db!
  //       .rawQuery('SELECT COUNT(*) FROM medicine_table WHERE isTaken = 0');
  //   int? count = Sqflite.firstIntValue(result);
  //   return count;
  // }
  Future<int?> getRemainingMedicineCount(String dayOfWeek) async {
    final db = await database;
    final result = await db!.rawQuery(
        'SELECT COUNT(*) FROM $table WHERE isTaken = 0 AND medicineDay LIKE "%$dayOfWeek%"');
    int? count = Sqflite.firstIntValue(result);
    return count;
  }

  Future<int?> getMedicineCountOnDay(String dayOfWeek) async {
    var db = await database;
    var result = await db!.rawQuery(
        'SELECT COUNT(*) FROM Medicine WHERE medicineDay LIKE "%$dayOfWeek%"');
    return Sqflite.firstIntValue(result);
  }
}