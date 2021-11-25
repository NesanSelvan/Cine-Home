import 'package:basics/constants/constants.dart';
import 'package:basics/pages/Login_page.dart';
import 'package:basics/pages/home_page.dart';
import 'package:basics/pages/moviePage.dart';
import 'package:basics/pages/search.dart';
import 'package:basics/utils/MyRoutes.dart';
import 'package:basics/utils/database.dart';
import './pages/register.dart';
//import 'package:basics/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'dart:ui';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //var GoogleFonts;

  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  var deepPurple;
    return MaterialApp(
      // home: HomePage(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        primarySwatch: Colors.yellow,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      // themeMode:ThemeMode.syste(),
      // darkTheme:ThemeData.dark(),
      //  primaryTextTheme: GoogleFonts.LatoTextTheme()),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.registerRoute: (context) => register(),
        MyRoutes.databaseRoute: (context) => Database(),
        MyRoutes.searchRoute: (context) => SearchPage(),
        MyRoutes.movieRoute: (context) => MoviePage()
      },
    );
  }
}
