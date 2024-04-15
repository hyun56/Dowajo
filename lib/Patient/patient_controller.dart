import 'package:get/get.dart';

class PatientController extends GetxController {
  // Rx 타입을 사용하여 반응형 상태 관리
  var searchResult = Rxn<List<Patient>>();

  // 환자 검색 메서드
  void searchPatient(int id) {

    List<Patient> dummyPatients = [
      Patient(id: 11, name: "홍길동"),
      Patient(id: 22, name: "김철수"),
      Patient(id: 33, name: "김영희"),
      Patient(id: 44, name: "이영애"),
      Patient(id: 55, name: "강영현"),
    ];

    // 고유번호로 환자 검색
    searchResult.value = dummyPatients.where((patient) => patient.id == id).toList();
  }
}

// 환자 정보 저장 클래스
class Patient {
  final int id;
  final String name;

  Patient({required this.id, required this.name});
}
