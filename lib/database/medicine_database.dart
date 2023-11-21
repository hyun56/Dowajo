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

  // Singleton class, 생성자
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database reference, 인스턴스 가져오는 메소드
  static Database? _database;

// 데이터 로딩
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

// 데이터베이스 초기화 메소드
  Future<Database> _initDatabase() async {
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

// 데이터 추가
  Future<int> insert(Medicine medicine) async {
    Database? db = await instance.database;
    return await db!.insert(table, medicine.toMap());
  }

// 데이터 조회
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

// 데이터 수정
  Future<int> update(Medicine medicine) async {
    Database? db = await instance.database;
    return await db!.update(
      table,
      medicine.toMap(),
      where: '$columnId = ?', // 수정 데이터 조건 설정
      whereArgs: [medicine.id], // 수정 데이터 조건 값
    );
  }

//  데이터 삭제
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
