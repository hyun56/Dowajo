import 'package:firebase_core/firebase_core.dart';
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
timestamp TEXT UNIQUE
)
''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  void syncFirebaseWithSQLite(String patientId) {
    getUserRequiresStreamByPatientId(patientId).listen((userRequires) async {
      final db = await instance.database;

      // Firebase에서 받은 최신 데이터로 SQLite 데이터베이스를 업데이트합니다.
      for (var userRequire in userRequires) {
        await db.insert(
            'userRequires',
            {
              'patientId': patientId,
              'data': userRequire['data'],
              'timestamp': userRequire['timestamp'],
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> insertUserRequire(String newData, String patientId) async {
    try {
      await Firebase.initializeApp();
      FirebaseDatabase database = FirebaseDatabase.instance;
      DatabaseReference ref = database.ref('userRequires/$patientId');
      String timestamp =
          DateFormat('yy.MM.dd - HH:mm:ss').format(DateTime.now());

      // Firebase에 데이터 추가
      await ref.push().set({'data': newData, 'timestamp': timestamp});

      // SQLite에 데이터 추가
      final db = await instance.database;
      await db.insert('userRequires', {
        'patientId': patientId,
        'data': newData,
        'timestamp': timestamp,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Error inserting user require: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getUserRequiresStreamByPatientId(
      String patientId) {
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference ref = database.ref('userRequires/$patientId');

    return ref.onValue.map((event) {
      List<Map<String, dynamic>> userRequires = [];

      if (event.snapshot.exists) {
        for (var child in event.snapshot.children) {
          final Map<String, dynamic> data =
              Map<String, dynamic>.from(child.value as Map);
          data['key'] = child.key;
          userRequires.add(data);
        }
      }
      return userRequires;
    });
  }

  Future<List<Map<String, dynamic>>> getUserRequiresByPatientId(
      String patientId) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'userRequires',
        where: 'patientId = ?',
        whereArgs: [patientId],
      );
      return result;
    } catch (e) {
      print('Error getting user requires by patient ID: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserRequires() async {
    try {
      final db = await instance.database;
      final result = await db.query('userRequires');
      return result;
    } catch (e) {
      print('Error getting all user requires: $e');
      return [];
    }
  }

  // Future<void> updateUserRequire(int id, String newData) async {
  //   try {
  //     final db = await instance.database;
  //     await db.update(
  //       'userRequires',
  //       {'data': newData},
  //       where: 'id = ?',
  //       whereArgs: [id],
  //     );
  //   } catch (e) {
  //     print('Error updating user require: $e');
  //   }
  // }

  // Future<void> deleteUserRequire(int id) async {
  //   try {
  //     final db = await instance.database;
  //     await db.delete(
  //       'userRequires',
  //       where: 'id = ?',
  //       whereArgs: [id],
  //     );
  //   } catch (e) {
  //     print('Error deleting user require: $e');
  //   }
  // }
}
