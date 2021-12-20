import 'package:basics/constants/constants.dart';
import 'package:basics/db/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? userModel;
  List<String> favList = [];
  bool isLoading = true;
  Future<void> getCurrentUser() async {
    final user = Userfirestore.getCurrentUser();
    final fav = await Userfirestore.getMyFavourites();
    if (user != null) {
      setState(() {
        userModel = user;
        favList = fav;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonGridLoader(
                  builder: Card(
                    color: Colors.transparent,
                    child: GridTile(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 10,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 70,
                            height: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  items: 1,
                  period: Duration(seconds: 2),
                  highlightColor: Colors.grey,
                  direction: SkeletonDirection.ltr,
                  childAspectRatio: 1,
                ),
                SkeletonLoader(
                  builder: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 300,
                                height: 10,
                                color: Colors.white,
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 100,
                                height: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  items: 1,
                  period: Duration(seconds: 2),
                  highlightColor: Colors.grey,
                  direction: SkeletonDirection.ltr,
                )
              ],
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              SizedBox(height: 30),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userModel!.photoURL ??
                    "https://miro.medium.com/max/1400/1*8LqM01R9CUiJ8xVreYx5jw.jpeg"),
              ),
              SizedBox(height: 10),
              Text(
                userModel!.displayName ?? "",
                style: TextStyle(
                    color: kPrimaryColor,
                    letterSpacing: 0.8,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Text(
                userModel!.email ?? "",
                style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 0.8,
                    fontSize: 8,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Favourites",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: favList
                            .map((e) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    )
                  ],
                ),
              )
            ]));
  }
}
