
import 'package:companio_diabetes_app/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusable_widgets/reusable_widgets.dart';
import '../utilis/colors_utilis.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("#3158C3"),
            hexStringToColor("#3184C3"),
            hexStringToColor("#551CB4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Companio",
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: -1.0,
                      ),
                    ),
                    logoWidget("assets/images/App_Logo.png"),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter UserName", Icons.person_outline, false, _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    signInSignUpButton(context, true, () {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text).then((value) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    }),
                    signUpOption(context)
                  ],
                )
              ),
            ),
          ),
    );
  }
}

Row signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have account?",
          style: TextStyle(color: Colors.white70)),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()));
        },
        child: const Text(
          " Sign Up",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}
