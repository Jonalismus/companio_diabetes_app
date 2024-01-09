import 'package:flutter/material.dart';

import '../../utilis/colors_utilis.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        hexStringToColor("#3158C3"),
        hexStringToColor("#3184C3"),
        hexStringToColor("#551CB4")
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
    ));
  }
}
