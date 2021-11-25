import 'dart:math';

import 'package:basics/models/ratings.dart';
import 'package:basics/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Color kPrimaryColor = Colors.yellow;

List<String> thumbnailUrl = [
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOySjlFqo4d2OBtWSLRCGC3fgLGZJ-mAZ93p9BNgIrIwedeyGVwN-RQliwgSjQbid4daI&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSleGNNRBs1qjs1hwPLXDKwf7pDK_tUXmbkVShqfvRIIuHffCvGpxS-NKz4VaP8t6wADZA&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZ6ZDpbQK8e1fMb5pgXZ9Rr9QgcezGxI3m5-V_7GKITsMD0GRc1PT-N2hn4EMJGg9z8M&usqp=CAU",
  "https://media.istockphoto.com/photos/popcorn-and-clapperboard-picture-id1191001701?k=20&m=1191001701&s=612x612&w=0&h=uDszifNzvgeY5QrPwWvocFOUCw8ugViuw-U8LCJ1wu8=",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8vQXlhkxFYbEECVtagy2QyWw8_sjoToh-O5U6qTLOZXlFgguDYOwMk4gksO8_zPLdLfU&usqp=CAU"
];

String getRandomthumbnail() {
  thumbnailUrl.shuffle();
  return thumbnailUrl.first;
}

int getRatingsFromListOfSameMovies(List<RatingsModel> data) {
  try {
    double r = 0;
    for (var item in data) {
      r += item.rating;
    }
    return (r / data.length).round();
  } catch (e) {
    // return Random().nextInt(5);
    return 0;
  }
}

List<UserModel> getRandomCast() {
  castList.shuffle();
  return castList.take(4).toList();
}

List<UserModel> castList = [
  UserModel(
      email: "",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BMTM0ODU5Nzk2OV5BMl5BanBnXkFtZTcwMzI2ODgyNQ@@._V1_UY209_CR3,0,140,209_AL_.jpg",
      name: "Johonny Depp",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BMTQzMzg1ODAyNl5BMl5BanBnXkFtZTYwMjAxODQ1._V1_UX140_CR0,0,140,209_AL_.jpg",
      name: "Al Pacino",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BMjAwNDU3MzcyOV5BMl5BanBnXkFtZTcwMjc0MTIxMw@@._V1_UY209_CR9,0,140,209_AL_.jpg",
      name: "Robert De Niro",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BMTQ3ODEyNjA4Nl5BMl5BanBnXkFtZTgwMTE4ODMyMjE@._V1_UX140_CR0,0,140,209_AL_.jpg",
      name: "Tom hardy",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BMTM3OTUwMDYwNl5BMl5BanBnXkFtZTcwNTUyNzc3Nw@@._V1_UY209_CR16,0,140,209_AL_.jpg",
      name: "Scarlett Johnsson",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BNzg1MTUyNDYxOF5BMl5BanBnXkFtZTgwNTQ4MTE2MjE@._V1_UX140_CR0,0,140,209_AL_.jpg",
      name: "Robert Downey Jr",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY209_CR3,0,140,209_AL_.jpg",
      name: "Megan fox",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BMjExNzA4MDYxN15BMl5BanBnXkFtZTcwOTI1MDAxOQ@@._V1_UY209_CR5,0,140,209_AL_.jpg",
      name: "Vin Diesel",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BMTYwNDM0NDA3M15BMl5BanBnXkFtZTcwNTkzMjQ3OA@@._V1_UY209_CR4,0,140,209_AL_.jpg",
      name: "keira knightley",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BNTczMzk1MjU1MV5BMl5BanBnXkFtZTcwNDk2MzAyMg@@._V1_UY209_CR2,0,140,209_AL_.jpg",
      name: "will smith ",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BNDExMzIzNjk3Nl5BMl5BanBnXkFtZTcwOTE4NDU5OA@@._V1_UX140_CR0,0,140,209_AL_.jpg",
      name: "Hugh jackman",
      favourites: []),
  UserModel(
      email: "email",
      userPhoto:
          "https://m.media-amazon.com/images/M/MV5BMjUxMjE4MTQxMF5BMl5BanBnXkFtZTcwNzc2MDM1NA@@._V1_UY209_CR6,0,140,209_AL_.jpg",
      name: "Nicolas Cage",
      favourites: [])
];
