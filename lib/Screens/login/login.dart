import 'package:flutter/material.dart';
import 'package:dowajo/Screens/login/signup.dart';
import 'package:dowajo/Screens/patient_search_screen.dart';
import 'package:dowajo/components/models/nurse.dart';
import 'package:dowajo/database/login_signup_database.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => loginState();
}

class loginState extends State<login> {
  final id = TextEditingController();
  final password = TextEditingController();

  //show and hide password
  bool isVisible = false;
  //login
  bool isLoginTrue = false;

  var db = DatabaseHelper.instance;
  final formKey = GlobalKey<FormState>();

  login() async {
    var response = await db.login(Nurse(id: id.text, password: password.text));
    if (response == true) {
      //if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => PatientSearchScreen()));
    } else {
      setState(() {
        isLoginTrue = false;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Center(child: Text("로그인 실패")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("ID나 비밀번호가 틀렸습니다."),
                  ElevatedButton(
                    child: const Text("확인"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
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
                      controller: id,
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
                        color: Colors.black, // 테두리 색상
                        width: 1.0, // 테두리 두께
                      ),
                    ),
                    child: TextFormField(
                      controller: password,
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
