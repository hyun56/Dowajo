class Medicine {
  // final List<dynamic> notificationIDs; // 알림 ID
  final int? id; // id 필드 추가
  final String medicineName;
  final String medicinePicture; // 사진 파일의 경로를 저장
  final String medicineDay; // 요일
  final int medicineRepeat; // 반복 횟수
  final String medicineTime;
  bool isTaken; // 복용 여부

  Medicine({
    // required this.notificationIDs,
    this.id, // 생성자에 id 추가
    required this.medicineName,
    required this.medicinePicture,
    required this.medicineDay,
    required this.medicineRepeat,
    required this.medicineTime,
    this.isTaken = false, // 기본값은 false
  });

  // List<dynamic> get getIDs => notificationIDs;
  int? get getId => id; // id getter 추가
  String get getName => medicineName;
  String get getPicture => medicinePicture;
  String get getDay => medicineDay;
  int get getRepeat => medicineRepeat;

  //String get getTime => medicineTime;

  Map<String, dynamic> toMap() {
    return {
      'id': id, // toMap 메서드에 id 추가
      'medicineName': medicineName,
      'medicinePicture': medicinePicture,
      'medicineDay': medicineDay,
      'medicineRepeat': medicineRepeat,
      'medicineTime': medicineTime,
      'isTaken': isTaken ? 1 : 0,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      medicineName: map['medicineName'],
      medicinePicture: map['medicinePicture'],
      medicineDay: map['medicineDay'],
      medicineRepeat: map['medicineRepeat'],
      medicineTime: map['medicineTime'],
      isTaken: map['isTaken'] == 1,
    );
  }
}