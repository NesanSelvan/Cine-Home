// ignore_for_file: camel_case_types, unused_import

import 'package:basics/constants/SizeConfig.dart';
import 'package:basics/constants/constants.dart';
import 'package:basics/db/user.dart';
import 'package:basics/main.dart';
import 'package:basics/utils/MyRoutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Login_page.dart';
import 'package:basics/utils/MyRoutes.dart';

class register extends StatelessWidget {
  final auth =
      FirebaseAuth.instance; // const name({Key? key}) : super(key: key);
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildContainer(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            'Create Account',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: kPrimaryColor),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          width: SizeConfig.screenwidth! * 0.75,
          child: TextFormField(
            decoration: InputDecoration(
              focusColor: kPrimaryColor,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: kPrimaryColor, width: 2.0)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
              labelText: 'Name',
              labelStyle: TextStyle(color: kPrimaryColor),
              hintText: 'Enter Name',
            ),
            controller: nameController,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: SizeConfig.screenwidth! * 0.75,
          child: TextFormField(
            decoration: InputDecoration(
                focusColor: kPrimaryColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
                  borderRadius: BorderRadius.circular(25),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(18)),
                labelText: 'Email Address',
                labelStyle: TextStyle(color: kPrimaryColor),
                hintText: 'Enter Email Address'),
            controller: emailController,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: SizeConfig.screenwidth! * 0.75,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
                focusColor: kPrimaryColor,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: kPrimaryColor, width: 2.0)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                labelText: ' Password',
                labelStyle: TextStyle(color: kPrimaryColor),
                hintText: 'Enter Password'),
            controller: passwordController,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
              minimumSize: Size(100, 40), backgroundColor: kPrimaryColor),
          onPressed: () async {
            debugPrint(nameController.text);
            try {
              final userCred = await auth.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
              if (userCred.user == null) {
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                    content: Text(
                  "Error : in login",
                )));
              } else {
                await Userfirestore().createUserData(userCred.user!.uid,
                    nameController.text, emailController.text, [], "");
                Navigator.pushNamed(context, MyRoutes.homeRoute);
              }
            } on FirebaseAuthException catch (e) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                "Error : ${e.message}",
              )));
            }
          },
          child: Text(
            'Register',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
                },
                child: Text('Sign in',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kPrimaryColor)),
              ),
            ])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: SizeConfig.screenwidth,
          height: SizeConfig.screenheight,
          decoration: BoxDecoration(color: Colors.grey[800]),
          child: Stack(
            children: <Widget>[
              Container(
                  width: SizeConfig.screenwidth!,
                  height: SizeConfig.screenheight! * 0.57,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(70),
                          bottomRight: const Radius.circular(70)))),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: SizeConfig.screenheight! * 0.7,
                  width: SizeConfig.screenwidth! * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(50),
                          topRight: const Radius.circular(50),
                          bottomLeft: const Radius.circular(50),
                          bottomRight: const Radius.circular(50))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildContainer(context),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
