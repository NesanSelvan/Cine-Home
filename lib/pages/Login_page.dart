//import 'dart:html';

import 'dart:async';

import 'package:basics/constants/constants.dart';
import 'package:basics/db/user.dart';
import 'package:basics/utils/MyRoutes.dart';
//import 'package:basics/utils/routes.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:basics/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:basics/utils/database.dart';
//import 'package:basics/pages/home_page.dart';
//import 'dart:ui';
//import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  //const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth get auth => FirebaseAuth.instance;

  Future<void> checkLoginIn() async {
    debugPrint("${await GoogleSignIn().isSignedIn()}");
    if (await GoogleSignIn().isSignedIn()) {
      Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
    }
    debugPrint("${FirebaseAuth.instance.currentUser}");
  }

  @override
  void initState() {
    super.initState();
    checkLoginIn();
  }

  Future<void> performGoogleLogin() async {
    try {
      final result = await GoogleSignIn().signIn();
      debugPrint("Result : ${result}");
      if (result != null) {
        GoogleSignInAuthentication _googleAuth = await result.authentication;
        if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
          final sonuc = await FirebaseAuth.instance.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: _googleAuth.idToken,
                  accessToken: _googleAuth.accessToken));
          User? _user = sonuc.user;

          if (_user != null) {
            await Userfirestore().createUserData(
                _user.uid,
                _user.displayName ?? "",
                _user.email ?? "",
                [],
                _user.photoURL ?? "");
            Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
          }
        }
      }
    } catch (e) {
      debugPrint("Error : ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                // image: DecorationImage(
                //     image: AssetImage(
                //       'assets/login-bg.jpg',
                //     ),
                //     colorFilter: ColorFilter.mode(
                //         Colors.grey[700]!.withOpacity(0.5), BlendMode.colorBurn),
                //     fit: BoxFit.cover),
                ),
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25.0,
                    ),
                    // Image.asset(
                    //   "assets/login.png",
                    //   fit: BoxFit.cover,
                    //   height: 200,
                    // ),
                    SvgPicture.asset(
                      "assets/svg/login-svg.svg",
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Cine Home',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 32.0),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              focusColor: kPrimaryColor,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                    color: kPrimaryColor, width: 2.0),
                              ),

                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              hintText: "Enter Email",
                              //  hintStyle: TextStyle(color: Colors.white),
                              labelText: "Email",
                            ),
                            controller: emailController,
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                focusColor: kPrimaryColor,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                        color: kPrimaryColor, width: 2.0)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                hintText: "Enter Password",
                                labelText: "Password"),
                            controller: passwordController,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ElevatedButton(
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                            style: TextButton.styleFrom(
                                minimumSize: Size(75, 36),
                                backgroundColor: kPrimaryColor),
                            onPressed: () async {
                              try {
                                final userData =
                                    await auth.signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);

                                // final UserCredential =
                                if (userData.user != null)
                                  Navigator.pushReplacementNamed(
                                      context, MyRoutes.homeRoute);
                                else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Something went wrong",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                }
                              } on FirebaseAuthException catch (e) {
                                debugPrint("Error:${(e.toString())}");
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    e.toString(),
                                  ),
                                ));
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Divider()),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Or',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  // style: (fon),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Divider()),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Image.asset('assets/google.png'),
                                iconSize: 10,
                                onPressed: performGoogleLogin,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New to this app?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, MyRoutes.registerRoute);
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
