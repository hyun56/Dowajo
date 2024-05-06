import 'package:flutter/material.dart';
import 'package:dowajo/Screens/login/login.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
// Firestore
// await FirebaseFirestore.instance
//     .collection('Nurse')
//     .doc(userCredential.user!.uid)
//     .set({
//   'id': idController.text,
//   'name': nameController.text,
// });

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

  bool isVisible = false;

  bool isSignUp = false;

  signUp() async {
    setState(() {
      isSignUp = true;
    });

    try {
      //UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "${idController.text}@example.com", // ID
        password: passController.text,
      );
      Get.snackbar("회원가입 성공", "성공적으로 회원가입되었습니다.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      Get.snackbar("회원가입 실패", error.toString());
    } finally {
      setState(() {
        isSignUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ListTile(
                    title: Text(
                      "회원가입",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //id
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
                  //name
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
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "성함을 반드시 입력해야 합니다.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "성함",
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
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),

                  //Confirm Password field
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
                      controller: confirmPassController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "비밀번호를 반드시 입력해야 합니다.";
                        } else if (passController.text !=
                            confirmPassController.text) {
                          return "비밀번호가 안 맞습니다.";
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
                            signUp();
                          }
                        },
                        child: const Text(
                          "회원가입",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),

                  //Sign up button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("이미 계정이 있으신가요?"),
                      TextButton(
                          onPressed: () {
                            //Navigate to sign up
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text("Login"))
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
