import 'package:basics/constants/SizeConfig.dart';
import 'package:basics/constants/constants.dart';
import 'package:basics/services/api.dart';
import 'package:basics/utils/MyRoutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'Login_page.dart';
import 'home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainDrawer extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      UserAccountsDrawerHeader(
        accountEmail: Text(user!.email ?? ""),
        accountName: Text(user!.displayName ?? ""),
        currentAccountPicture: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(user == null || user!.photoURL == null
              ? "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-unknown-social-media-user-photo-default-avatar-profile-icon-vector-unknown-social-media-user-184816085.jpg"
              : user!.photoURL!),
        ),
      ),

      // Row(
      //   children: [
      ListTile(
          title: Icon(Icons.logout_rounded, color: Colors.white),
          onTap: () {
            GoogleSignIn().signOut();
            Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
          }),

      Text("Log Out"),
      //   ],
      // ),
      ListTile(
        title: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NgrokUrl()));
          },
          child: Text("Ngrok"),
        ),

        //    TextButton(onPressed: () {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => NgrokUrl()));
        // }),
      )
    ]));
  }
}

class NgrokUrl extends StatelessWidget {
  const NgrokUrl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ngrokController = TextEditingController(
        text: "http://8d06-2409-4072-6c04-2b2d-ed81-136f-4262-90ae.ngrok.io");
    return Scaffold(
      appBar: AppBar(
        title: Text("Ngrok"),
      ),
      body: Stack(
        children: [
          Container(
            width: SizeConfig.screenwidth,
            height: SizeConfig.screenheight,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 150, horizontal: 25),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        focusColor: kPrimaryColor,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter Ngrok Url",
                        labelText: "Ngrok url"),
                    controller: ngrokController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ngRokUrl = ngrokController.text;
                    },
                    child: Text(
                      "ok",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[850],
                          fontSize: 15),
                    ),
                    style: TextButton.styleFrom(
                        minimumSize: Size(75, 36),
                        backgroundColor: kPrimaryColor),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
