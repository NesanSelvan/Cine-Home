import 'dart:async';
import 'dart:convert';

import 'package:basics/constants/SizeConfig.dart';
import 'package:basics/db/user.dart';
import 'package:basics/pages/Drawer.dart';
import 'package:basics/pages/body.dart';
import 'package:basics/pages/dialog.dart';
import 'package:basics/pages/moviePage.dart';
import 'package:basics/pages/profile.dart';
import 'package:basics/services/api.dart';
import 'package:basics/utils/MyRoutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:basics/utils/database.dart';
import 'package:http/http.dart' as http;
import 'package:basics/pages/search.dart';

//import 'package:basics/login_page.dart';
//import 'dart:ui';
class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;
  List<Widget> screens = [
    body(),
    MoviePage(),
    ProfileScreen(),
    ProfileScreen(),
  ];

  void getInitialData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
      return;
    }
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    debugPrint("Data: ${data.data()}");
    final userData = data.data();
    if (userData == null) {
      Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
      return;
    } else {
      try {
        final favourites = userData['favourites'] as List;
        if (favourites.isEmpty) {
          Timer(Duration(seconds: 1), () async {
            await dialog().showMyDialog(context);
            getInitialData();
          });
        }
      } catch (e) {}
    }
    await Userfirestore.addIfCustomUserIdNotExists();
  }

  @override
  void initState() {
    super.initState();
    getInitialData();

    // if (FirebaseAuth.instance.currentUser == null) {
    //   Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
    // }
  }

  @override
  Widget build(BuildContext context) {
    var customIcon;
    var customSearchbar;
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(),

      //child: UserAccountsDrawerHeader(
      // //accountName: Text(user!.displayName!),
      //accountEmail: Text(user!.email!)),
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        leading: IconButton(
          icon: Image.asset(
            "assets/Drawer.png",
            height: 70,
            width: 25,
          ),
          iconSize: 25,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchPage())),
              icon: Icon(Icons.search)),

          IconButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => HomePage())),
              icon: Icon(Icons
                  .refresh_outlined)) // child: Image.asset("assets/search.png", height: 35, width: 24),
          // onTap: () {

          // Navigator.pushNamed(context, MyRoutes.searchRoute);
          // ),
          // SizedBox(
          //   width: 20,
          // )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        buildtabitem(
            index: 0,
            icon: Icon(Icons.home,
                color: index == 0 ? Colors.yellow : Colors.white),
            onPressed: () async {
              // debugPrint("responseData : $responseData");
              setState(() {
                index = 0;
              });
            }),
        buildtabitem(
            index: 1,
            icon: Icon(Icons.movie_sharp,
                color: index == 1 ? Colors.yellow : Colors.white),
            onPressed: () {
              // Navigator.pushNamed(context, MyRoutes.movieRoute);
              setState(() {
                index = 1;
              });
            }),
        buildtabitem(
            index: 2,
            icon: Icon(Icons.video_library_outlined,
                color: index == 2 ? Colors.yellow : Colors.white),
            onPressed: () {
              setState(() {
                index = 2;
              });
            }),
        buildtabitem(
            index: 3,
            icon: Icon(Icons.account_circle_sharp,
                color: index == 3 ? Colors.yellow : Colors.white),
            onPressed: () {
              // Navigator.pushNamed(context, MyRoutes.databaseRoute);
              setState(() {
                index = 3;
              });
            }),
      ])),
      body: screens[index],
    );
  }

  Widget buildtabitem({
    required int index,
    required Icon icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: 29,
    );
  }
}
