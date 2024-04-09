class InjectModels{
  final int? id;
  final String injectType;
  final String injectName;
  final String injectPicture; // 사진 파일의 경로를 저장
  final String injectDay; // 요일
  final String injectStartTime;
  final String injectEndTime;
  final String injectMount;
  final bool injectChange;

  InjectModels({
    required this.id,
    required this.injectType,
    required this.injectName,
    required this.injectPicture, // 사진 파일의 경로를 저장
    required this.injectDay, //요일
    required this.injectStartTime,
    required this.injectEndTime,
    required this.injectMount,
    required this.injectChange,
  });
}