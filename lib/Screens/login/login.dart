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
          email: idController.text + "@example.com", // ID
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Text('Dowajo',
                      style: TextStyle(
                          fontSize: 45.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: TextFormField(
                      controller: idController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "ID를 반드시 입력해야 합니다.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "ID",
                      ),
                    ),
                  ),

                  //Password field
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: TextFormField(
                      controller: passController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "비밀번호를 반드시 입력해야 합니다.";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "비밀번호",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  //toggle button
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),
                  const SizedBox(height: 10),

                  //Login button
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.lightGreen),
                    child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),

                  //Sign up button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("계정이 없으신가요?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const signUp()));
                          },
                          child: const Text("회원가입"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
