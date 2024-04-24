class Nurse {
  final String id;
  final String? name;
  final String password;

  Nurse({required this.id, this.name, required this.password});

  factory Nurse.fromMap(Map<String, dynamic> json) => Nurse(
        id: json['id'],
        name: json['name'],
        password: json['password'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'password': password,
      };
}

//TestData
// I/flutter (19401): ID: 1, Name: nurse1, Password: 1234
// I/flutter (19401): ID: 2, Name: nurse2, Password: 1234
// I/flutter (19401): ID: 3, Name: nurse3, Password: 1234
// I/flutter (19401): ID: 4, Name: nurse4, Password: 1234

