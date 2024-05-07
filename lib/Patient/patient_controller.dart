// import 'package:get/get.dart';

// class PatientController extends GetxController {
//   // Rx 타입을 사용하여 반응형 상태 관리
//   var searchResult = Rxn<List<Patient>>();

//   // 환자 검색 메서드
//   void searchPatient(int id) {
//     // final patientController = Get.put(PatientController());
//     // patientController.searchPatient(id);

//     List<Patient> dummyPatients = [
//       Patient(
//           id: 11,
//           name: "홍길동",
//           gender: "남",
//           birth: "1970-12-01",
//           disease: "당뇨",
//           room: 506),
//       Patient(
//           id: 22,
//           name: "김철수",
//           gender: "남",
//           birth: "1989-11-01",
//           disease: "고혈압",
//           room: 406),
//       Patient(
//           id: 33,
//           name: "김영희",
//           gender: "여",
//           birth: "1990-10-01",
//           disease: "고혈압",
//           room: 305),
//       Patient(
//           id: 44,
//           name: "이영애",
//           gender: "여",
//           birth: "1965-09-11",
//           disease: "당뇨",
//           room: 204),
//       Patient(
//           id: 55,
//           name: "강영현",
//           gender: "남",
//           birth: "1993-12-31",
//           disease: "골절",
//           room: 506),
//     ];

//     // 고유번호로 환자 검색
//     searchResult.value =
//         dummyPatients.where((patient) => patient.id == id).toList();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PatientController extends GetxController {
  var searchResult = Rxn<List<Patient>>();

  void searchPatient(String id) async {
    FirebaseFirestore.instance
        .collection(
            'Patient') // 'patients'는 Firestore에서 환자 정보를 저장하고 있는 컬렉션 이름입니다.
        .where('id', isEqualTo: id) // 'id' 필드가 검색하려는 id와 일치하는 문서를 찾습니다.
        .get()
        .then((querySnapshot) {
      searchResult.value = querySnapshot.docs
          .map((doc) => Patient(
                birth: doc['birth'],
                disease: doc['disease'],
                gender: doc['gender'],
                id: doc['id'],
                name: doc['name'],
                room: doc['room'],
                picture:doc['picture']
              ))
          .toList();
    });
  }
}

// 환자 정보 저장 클래스
class Patient {
  final String id;
  final String name;
  final String gender;
  final String birth;
  final String disease;
  final int room;
  final String picture;
  Patient(
      {required this.id,
      required this.name,
      required this.gender,
      required this.birth,
      required this.disease,
      required this.room,
      required this.picture
      });
}
