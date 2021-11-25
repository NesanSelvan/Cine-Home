import 'package:basics/constants/constants.dart';
import 'package:basics/pages/getMovies.dart';
import 'package:basics/services/api.dart';
import 'package:basics/utils/MyRoutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class dialog {
  Future<void> showMyDialog(context) async {
    List<String> data = await API().getAllCategories();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CategoryDialogBox(data: data);
      },
    );
  }
}

class CategoryDialogBox extends StatefulWidget {
  const CategoryDialogBox({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<String> data;

  @override
  State<CategoryDialogBox> createState() => _CategoryDialogBoxState();
}

class _CategoryDialogBoxState extends State<CategoryDialogBox> {
  List<String> selectedCategory = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Select Genere'),
        content: Wrap(
          children: widget.data
              .map((e) => InkWell(
                    onTap: () {
                      if (selectedCategory.contains(e)) {
                        selectedCategory.remove(e);
                      } else {
                        selectedCategory.add(e);
                      }
                      // Navigator.pushNamed(context, MyRoutes.homeRoute);
                      print(e);
                      selectedGenre();
                      setState(() {});
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                        decoration: selectedCategory.contains(e)
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryColor,
                              )
                            : null,
                        child: Container(
                          child: Text(
                            e,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: selectedCategory.contains(e)
                                    ? Colors.black
                                    : null),
                          ),
                        )),
                  ))
              .toList(),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('ok'),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.uid)
                      .update({"favourites": selectedCategory});
                }
                Navigator.pop(context);
              })
        ]);
  }
}

class selectedGenre extends StatefulWidget {
  selectedGenre({Key? key}) : super(key: key);

  @override
  _selectedGenreState createState() => _selectedGenreState();
}

class _selectedGenreState extends State<selectedGenre> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
