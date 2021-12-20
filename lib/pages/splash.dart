import 'package:basics/constants/constants.dart';
import 'package:basics/utils/MyRoutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SpashScreen extends StatefulWidget {
  SpashScreen({Key? key}) : super(key: key);

  @override
  _SpashScreenState createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen> {
  FirebaseAuth get auth => FirebaseAuth.instance;

  Future<void> checkLoginIn() async {
    debugPrint("${await GoogleSignIn().isSignedIn()}");
    if (await GoogleSignIn().isSignedIn()) {
      Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
    } else {
      Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
    }
    debugPrint("${FirebaseAuth.instance.currentUser}");
  }

  @override
  void initState() {
    super.initState();
    checkLoginIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "CINE HOME",
            style: TextStyle(
                letterSpacing: 1,
                color: kPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(width: 20, height: 20, child: CircularProgressIndicator())
        ],
      ),
    ));
  }
}
