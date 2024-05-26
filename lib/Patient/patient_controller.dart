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
              picture: doc['picture']))
          .toList();
    });
  }

  var patientId = ''.obs;

  // patientId를 설정하는 메서드
  void setPatientId(String id) {
    patientId.value = id;
  }

  String getPatientId() {
    return patientId.value;
  }

  Future<String?> getPatientNameById(String id) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Patient')
          .where('id', isEqualTo: id)
          .get();

      // 검색 결과가 있다면 이름을 반환, 없다면 null 반환
      if (querySnapshot.docs.isNotEmpty) {
        var patientName = querySnapshot.docs.first['name'];
        return patientName;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting patient name: $e");
      return null;
    }
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
      required this.picture});
}
