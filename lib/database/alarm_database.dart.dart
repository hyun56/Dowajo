import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('userRequires.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE userRequires(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    patientId TEXT,
    data TEXT,
    timestamp TEXT
)
''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

// 환자 ID와 함께 데이터베이스에 데이터를 추가하는 예시입니다.
void insertUserRequire(String newData, String patientId) {
  FirebaseDatabase database = FirebaseDatabase.instance; // Firebase Database 인스턴스를 얻습니다.
  DatabaseReference ref = database.ref('userRequires/$patientId'); // 환자 ID를 포함한 경로로 데이터베이스 참조를 설정합니다.
  ref.push().set({'data': newData, 'timestamp':  DateFormat('yy.MM.dd - HH:mm:ss').format(DateTime.now())});
}

Future<List<Map<String, dynamic>>> getUserRequiresByPatientId(String patientId) async {
  FirebaseDatabase database = FirebaseDatabase.instance; // Firebase Database 인스턴스를 얻습니다.
  DatabaseReference ref = database.ref('userRequires/$patientId'); // 환자 ID를 포함한 경로로 데이터베이스 참조를 설정합니다.
  
  DatabaseEvent event = await ref.once(); // 데이터를 한 번만 불러옵니다.
  
  List<Map<String, dynamic>> userRequires = [];
  
  if (event.snapshot.exists) {
    event.snapshot.children.forEach((child) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(child.value as Map);
      data['key'] = child.key; // 필요한 경우 key도 저장합니다.
      userRequires.add(data);
    });
  }
  return userRequires;
}

}
