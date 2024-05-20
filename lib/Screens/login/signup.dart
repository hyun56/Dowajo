import 'package:flutter/material.dart';
import 'package:dowajo/Screens/login/login.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => signUpPage();
}

class signUpPage extends State<signUp> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //toggle button
  bool isVisible = false;
  //signup state
  bool isSignUp = false;

  signUp() async {
    try {
      //authentication에 추가
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "${idController.text}@example.com", // ID
        password: passController.text,
      );
      //firestore에 추가
      await firestore
          .collection("Nurse")
          .add({'id': idController.text, 'name': nameController.text});
      Get.snackbar("회원가입 성공", "회원가입되었습니다.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      Get.snackbar("회원가입 실패", "입력된 정보를 확인해 주세요");
    }
  }

  //ID 중복
  bool idAvailable = false;
  String _errorText = '';
  checkId(String id) async {
    if (id.isEmpty) {
      setState(() {
        _errorText = 'ID를 입력해주세요';
      });
      return;
    }

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Nurse')
        .where('id', isEqualTo: id)
        .get();

    if (result.docs.isNotEmpty) {
      setState(() {
        _errorText = "이미 사용 중인 ID입니다.";
      });
    } else if (result.docs.isEmpty) {
      setState(() {
        idAvailable = true;
        _errorText = '사용 가능한 ID입니다.';
      });
    }
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "비밀번호를 입력해 주세요";
    } else if (value.length < 6) {
      return '비밀번호는 6글자 이상이어야 합니다';
    } else if (passController.text != confirmPassController.text) {
      return "비밀번호가 일치하지 않습니다";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ListTile(
                    title: Text(
                      "회원가입",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA6CBA5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 35),

                  //id
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(255, 194, 193, 193),
                              width: 1.5,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextFormField(
                                controller: idController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "아이디를 입력해 주세요";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  icon: const Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 194, 193, 193),
                                      size: 23,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  hintText: "아이디",
                                  hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 169, 169, 169),
                                    fontSize: 15,
                                  ),
                                  errorText: idController.text.isEmpty
                                      ? null
                                      : _errorText,
                                  contentPadding:
                                      const EdgeInsets.only(right: 80),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await checkId(idController.text);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    textStyle: const TextStyle(fontSize: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  child: const Text(
                                    '중복 확인',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 155, 192, 154),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // const SizedBox(width: 5.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _checkDuplicateId(idController.text);
                  //   },
                  //   child: const Text('중복 확인'),
                  // ),
                  // const SizedBox(height: 8.0),

                  const SizedBox(height: 20),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 194, 193, 193),
                        width: 1.5,
                      ),
                    ),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "이름을 입력해 주세요";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 194, 193, 193),
                            size: 23,
                          ),
                        ),
                        border: InputBorder.none,
                        hintText: "이름",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 169, 169, 169),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //Password field
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 194, 193, 193),
                        width: 1.5,
                      ),
                    ),
                    child: TextFormField(
                      controller: passController,
                      validator: validatePassword,
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 194, 193, 193),
                              size: 23,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: "비밀번호 (6글자 이상)",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 169, 169, 169),
                            fontSize: 15,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                //toggle button
                                isVisible = !isVisible;
                              });
                            },
                            icon: Icon(isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: const Color.fromARGB(255, 169, 169, 169),
                          )),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //Confirm Password field
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 194, 193, 193),
                        width: 1.5,
                      ),
                    ),
                    child: TextFormField(
                      controller: confirmPassController,
                      validator: validatePassword,
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 194, 193, 193),
                              size: 23,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: "비밀번호 확인",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 169, 169, 169),
                            fontSize: 15,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                //toggle button
                                isVisible = !isVisible;
                              });
                            },
                            icon: Icon(isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: const Color.fromARGB(255, 169, 169, 169),
                          )),
                    ),
                  ),
                  const SizedBox(height: 40),

                  //SignUp button
                  Container(
                    height: 53,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFA6CBA5),
                    ),
                    child: TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (idAvailable) {
                              signUp();
                            } else {
                              Get.snackbar("회원가입 실패", "아이디 중복 확인해주세요");
                            }
                          }
                        },
                        child: const Text(
                          "회원가입",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.5,
                          ),
                        )),
                  ),
                  const SizedBox(height: 5),

                  //Sign up button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "이미 계정이 있으신가요?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 162, 162, 162),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //Navigate to sign up
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          "로그인",
                          style: TextStyle(
                            color: Color.fromARGB(255, 155, 192, 154),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
