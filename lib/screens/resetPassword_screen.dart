import 'package:companio_diabetes_app/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusable_widgets/reusable_widgets.dart';
import '../utilis/colors_utilis.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Passwort zurücksetzen",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("#3158C3"),
          hexStringToColor("#3184C3"),
          hexStringToColor("#551CB4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Bitte gib die E-Mail-Adresse deines Companio-Kontos ein",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField(
                    "E-Mail-Adresse",
                    Icons.account_balance_wallet_outlined,
                    false,
                    emailController,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {
                  resetPassword();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black26;
                    }
                    return Colors.white;
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                child: Text(
                  'Bestätigen',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Change text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword() {
    if (emailController.text.isEmpty) {
      showSnackBar(context, "E-Mail-Adresse ist leer");
      return;
    }
    //Firebase Auth-Funktionen zum Passwort-Zurücksetzen (versendet die E-Mail zum zurücksetzen)
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text)
        .then((value) {
      showSnackBar(context, "Passwort-Zurücksetzen-E-Mail gesendet");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
    }).catchError((error) {
      showSnackBar(context, "Fehler beim Zurücksetzen des Passworts: $error");
    });
  }
}
