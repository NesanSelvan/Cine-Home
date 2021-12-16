import 'dart:convert';

import 'package:basics/models/movies.dart';
import 'package:basics/models/ratings.dart';
import 'package:basics/models/upcoming.dart';
import 'package:basics/pages/moviePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String ngRokUrl = "https://2790-117-212-188-82.ngrok.io";

class API {
  final header = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<List<UpcomingMoviesModel>> getUpcomingMovies(
      String year, String month) async {
    final response = await http.post(Uri.parse(ngRokUrl + "/upcomingmovies"),
        headers: header,
        body: jsonEncode(<String, String>{"year": year, "month": month}));
    print("Response from Upcoming Movies : ${response.body}");
    final jsonDecoded = jsonDecode(response.body);
    print(jsonDecoded['data']);
    List<UpcomingMoviesModel> data = [];
    for (final item in jsonDecoded['data']) {
      final map = item as Map<String, dynamic>;
      final upcomingMovies = UpcomingMoviesModel.fromJson(map);
      debugPrint("Upcoming Movies: ${upcomingMovies.title}");
      data.add(upcomingMovies);
    }

    return data;
  }

  Future<List<RatingsModel>> getRatingsByMovieId(
      String movieId, String count) async {
    final response = await http.post(Uri.parse(ngRokUrl + "/getRatingsByMovie"),
        headers: header,
        body: jsonEncode(<String, String>{"movieId": movieId, "count": count}));
    // print(response.body);
    final jsonDecoded = jsonDecode(response.body);
    print(jsonDecoded['data']);
    List<RatingsModel> data = [];
    for (final item in jsonDecoded['data']) {
      final map = item as Map<String, dynamic>;
      final upcomingMovies = RatingsModel.fromJson(map);
      data.add(upcomingMovies);
    }

    return data;
  }

  Future<List<String>> getAllCategories() async {
    final response = await http.get(Uri.parse(ngRokUrl + "/getAllCategory"),
        headers: header);
    print("Get All Catgoeyr Data :${response.body}");
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final category = data['data'] as List;

    return category.cast<String>();
  }

  Future<List<MoviesModel>> getMovies(int count) async {
    debugPrint("Movies API Called...");
    final response = await http.post(Uri.parse(ngRokUrl + "/getMovies"),
        headers: header, body: jsonEncode({"count": count}));
    debugPrint("Movies : ${response.body}");
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    // print(jeson)
    List<MoviesModel> movies = [];
    for (var item in data['data']) {
      movies.add(MoviesModel.fromJson(item));
    }

    return movies;
  }

  Future<List<MoviesModel>> getMoviesByFavourite(
      List<String> fav, int count) async {
    final response = await http.post(Uri.parse(ngRokUrl + "/genre"),
        headers: header,
        body: jsonEncode(<String, dynamic>{"count": count, "fav": fav}));
    // print(response.body);
    final jsonDecoded = jsonDecode(response.body);
    List<MoviesModel> data = [];
    for (final item in jsonDecoded['data']) {
      final map = item as Map<String, dynamic>;
      print("map : $map");
      final upcomingMovies = MoviesModel.fromJson(map);

      data.add(upcomingMovies);
    }

    return data;
  }

  Future<List<MoviesModel>> searchMovie(String moviename, int count) async {
    final response = await http.post(Uri.parse(ngRokUrl + "/searchMovie"),
        headers: header,
        body: jsonEncode(<String, dynamic>{"count": count, "name": moviename}));
    // print(response.body);
    final jsonDecoded = jsonDecode(response.body);
    List<MoviesModel> data = [];
    for (final item in jsonDecoded['data']) {
      final map = item as Map<String, dynamic>;
      print("map : $map");
      final upcomingMovies = MoviesModel.fromJson(map);

      data.add(upcomingMovies);
    }

    return data;
  }

  Future<List<MoviesModel>> getSimilarMoviesByMovieId(String movieID) async {
    final response = await http.post(Uri.parse(ngRokUrl + "/similarMovies"),
        headers: header,
        body: jsonEncode(<String, dynamic>{"movieId": movieID}));
    // print(response.body);
    final jsonDecoded = jsonDecode(response.body);
    List<MoviesModel> data = [];
    for (final item in jsonDecoded['data']) {
      final map = item as Map<String, dynamic>;
      print("map : $map");
      final upcomingMovies = MoviesModel.fromJson(map);

      data.add(upcomingMovies);
    }

    return data;
  }

  Future<List<MoviesModel>> getContentBasedSimilarityByMovieId(
      String movieID) async {
    try {
      final response =
          await http.post(Uri.parse(ngRokUrl + "/contentbasedmovie"),
              headers: header,
              body: jsonEncode(<String, dynamic>{
                "movieId": "1",
                "count": 0,
              }));
      // print(response.body);
      final jsonDecoded = jsonDecode(response.body);
      List<MoviesModel> data = [];
      for (final item in jsonDecoded['data']) {
        final map = item as Map<String, dynamic>;
        print("map : $map");
        final upcomingMovies = MoviesModel.fromJson(map);

        data.add(upcomingMovies);
      }

      return data;
    } catch (e) {
      return [];
    }
  }
}
