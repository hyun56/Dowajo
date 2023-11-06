import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dowajo/components/models/medicine.dart';

class DatabaseHelper {
  static const _databaseName = "MedicineDatabase.db";
  static const _databaseVersion = 1;

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
  //     // 기존에 medicineTime 컬럼이 없었다면 추가합니다.
  //     await db.execute(
  //         "ALTER TABLE $table ADD COLUMN $columnTime TEXT NOT NULL DEFAULT ''");
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
            $columnTime TEXT NOT NULL
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
}
