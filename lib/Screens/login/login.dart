import 'package:flutter/material.dart';
import 'package:dowajo/Screens/login/signup.dart';
import 'package:dowajo/Screens/patient_search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idController = TextEditingController();
  final passController = TextEditingController();

  //show and hide password
  bool isVisible = false;
  //login
  bool isLogin = false;

  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  login() async {
    setState(() {
      isLogin = true;
    });

    try {
      await auth.signInWithEmailAndPassword(
          email: "${idController.text}@example.com", // ID
          password: passController.text);

      Get.snackbar("로그인 성공", "성공적으로 로그인되었습니다.");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PatientSearchScreen()));
    } catch (error) {
      Get.snackbar("로그인 실패", error.toString());
    } finally {
      setState(() {
        isLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text(
                      'Dowajo',
                      style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA6CBA5),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      //margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 194, 193, 193),
                          width: 1.5,
                        ),
                      ),
                      child: TextFormField(
                        controller: idController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "아이디를 입력해 주세요";
                          }
                          return null;
                        },
                        style: const TextStyle(
                          fontSize: 15,
                        ),
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
                          hintText: "아이디",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 169, 169, 169),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    //Password field
                    Container(
                      //margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 194, 193, 193),
                          width: 1.5,
                        ),
                      ),
                      child: TextFormField(
                        controller: passController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "비밀번호를 입력해 주세요";
                          }
                          return null;
                        },
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
                            hintText: "비밀번호",
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

                    const SizedBox(height: 30),
                    //Login button
                    Container(
                      height: 53,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFA6CBA5),
                      ),
                      child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              login();
                            }
                          },
                          child: const Text(
                            "로그인",
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
                          "계정이 없으신가요?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 162, 162, 162),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const signUp()));
                          },
                          child: const Text(
                            "회원가입",
                            style: TextStyle(
                              color: Color.fromARGB(255, 155, 192, 154),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
