// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'dart:ui';

import 'package:basics/constants/SizeConfig.dart';
import 'package:basics/constants/constants.dart';
import 'package:basics/db/user.dart';
import 'package:basics/models/movies.dart';
import 'package:basics/models/upcoming.dart';
import 'package:basics/pages/home_page.dart';
import 'package:basics/pages/movies_screen.dart';
import 'package:basics/services/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:basics/pages/moviePage.dart';
import 'package:basics/pages/dialog.dart';

class body extends StatefulWidget {
  const body({Key? key}) : super(key: key);

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  List<MoviesModel> favMoviesList = [];
  List<MoviesModel> moviesList = [];
  bool isLoading = true, isMoreLoading = false, isRecoLoading = true;
  void getMoviesByFav() async {
    try {
      final fav = await Userfirestore.getMyFavourites();
      // favMoviesList = await API().getMoviesByFavourite(fav, 5);
      favMoviesList = await API().getMoviesByFavourite(fav, 5);
      setState(() {
        isLoading = false;
      });
      final userId = await Userfirestore.getCurrentCustomUserID();
      API().getMoviesByRecommandation(userId!, 10).then((value) {
        moviesList = value;
        isRecoLoading = false;
        setState(() {});
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMoviesByFav();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final user = FirebaseAuth.instance.currentUser;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]!),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hello  ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                        Text(
                          user!.displayName ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: kPrimaryColor),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: InkWell(
                          onTap: () {},
                          child:
                              Icon(Icons.cancel_outlined, color: Colors.red)),
                    ),
                  ],
                ),
              ),

              //       if ( user != null) {
              //   print("Signed out " + user.displayName);
              // },

              // name = Text(user!.displayName ?? ""),
              _buildbody(),
              Moviecarousel(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Movie based on your Favourite",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              isLoading
                  ? Container(
                      height: 155,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ))
                  : Container(
                      height: 175,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 2, bottom: 0),
                            child: Row(
                              children: favMoviesList
                                  .map(
                                    (e) => Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          child: Container(
                                            child:
                                                MovieContainer(moviesModel: e),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () async {
                      isMoreLoading = true;
                      setState(() {});
                      final fav = await Userfirestore.getMyFavourites();
                      favMoviesList = await API().getMoviesByFavourite(fav, 50);
                      isMoreLoading = false;
                      setState(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoviesScreen(
                                  screenTitle: "Favourite Movies",
                                  moviesList: favMoviesList)));
                    },
                    child: Text("More >")),
              ),

              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Movie based on your Recommendation",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              isRecoLoading
                  ? Container(
                      height: 155,
                      width: 155,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ))
                  : Container(
                      height: 175,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 2, bottom: 0),
                            child: Row(
                              children: moviesList
                                  .map(
                                    (e) => Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          child: Container(
                                            child:
                                                MovieContainer(moviesModel: e),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        isMoreLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    )
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}

class _buildbody extends StatefulWidget {
  _buildbody({Key? key}) : super(key: key);

  @override
  __buildbodyState createState() => __buildbodyState();
}

class __buildbodyState extends State<_buildbody> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView();
        // child:
        // constraint;
      },
    );
  }
}

class Moviecarousel extends StatefulWidget {
  Moviecarousel({Key? key}) : super(key: key);

  @override
  _MoviecarouselState createState() => _MoviecarouselState();
}

class _MoviecarouselState extends State<Moviecarousel> {
  List<UpcomingMoviesModel> data = [];
  void getUpcomingMovies() async {
    try {
      data = await API().getUpcomingMovies("2021", "12");
      setState(() {});
    } catch (e) {}
  }

  int currentIndex = 0;

  @override
  void initState() {
    getUpcomingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Upcoming Movies",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 5),
        CarouselSlider(
          // items: [
          //   //1st Image of Slider
          //   Container(
          //     margin: EdgeInsets.all(6.0),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8.0),
          //       image: DecorationImage(
          //         image: NetworkImage(
          //             "https://7wallpapers.net/wp-content/uploads/Venom-2-16.jpg"),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),

          //   //2nd Image of Slider
          //   Container(
          //     margin: EdgeInsets.all(6.0),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8.0),
          //       image: DecorationImage(
          //         image: NetworkImage(
          //             "https://7wallpapers.net/wp-content/uploads/Venom-2-16.jpg"),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),

          //   //3rd Image of Slider
          //   Container(
          //     margin: EdgeInsets.all(6.0),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8.0),
          //       image: DecorationImage(
          //         image: NetworkImage(
          //             "https://7wallpapers.net/wp-content/uploads/Venom-2-16.jpg"),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),

          //   //4th Image of Slider
          //   Container(
          //     margin: EdgeInsets.all(6.0),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8.0),
          //       image: DecorationImage(
          //         image: NetworkImage(
          //             "https://7wallpapers.net/wp-content/uploads/Venom-2-16.jpg"),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),

          //   //5th Image of Slider
          //   Container(
          //     margin: EdgeInsets.all(6.0),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8.0),
          //       image: DecorationImage(
          //         image: NetworkImage(
          //             "https://7wallpapers.net/wp-content/uploads/Venom-2-16.jpg"),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ],
          items: data.length == 0
              ? List.generate(
                  5,
                  (index) => Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://7wallpapers.net/wp-content/uploads/Venom-2-16.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ).toList()
              : data
                  .take(10)
                  .map(
                    (e) => Container(
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(e.poster),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                  .toList(),

          //Slider Container properties
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
        ),
      ],
    );
  }
}
//     Container(
//       height: SizeConfig.screenheight! * 0.3,
//       width: SizeConfig.screenwidth,
//       child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             child: CarouselSlider(
//               options: CarouselOptions(
//                   autoPlay: false,
//                   onPageChanged: (index, reason) {
//                     setState(() {
//                       currentIndex = index;
//                     });
//                   }),
//               items: [
//                 Image.network(
//                     "https://7wallpapers.net/wp-content/uploads/Venom-2-16.jpg" +
//                         "https://7wallpapers.net/wp-content/uploads/Venom-2-16.jpg")
//               ],
//               // items: data
//               //     .take(maxLengthOfUpcomingMovies)
//               //     .map(
//               //       (e) => Image.network(
//               //         e.poster,
//               //         fit: BoxFit.contain,
//               //         // width: double.infinity,
//               //       ),
//               //     )
//               //     .toList(),
//             ),

//             // child: ClipRRect(
//             //     borderRadius: BorderRadius.all(
//             //   Radius.circular(30.0),
//             // )),
//           )),
//     ),
//     // SingleChildScrollView(
//     //   child: Row(
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     children:Container(
//     //               width: data[currentIndex] == e ? 15 : 7,
//     //               height: 7,
//     //               decoration: BoxDecoration(
//     //                   color: data[currentIndex] == e
//     //                       ? kPrimaryColor
//     //                       : Colors.white,
//     //                   borderRadius: BorderRadius.all(Radius.circular(50))),
//     //               margin: EdgeInsets.all(5),
//     //             ))
//     //   ),
//     // ),
//     // TextButton(
//     //     onPressed: () async {
//     //       debugPrint("Printing...");
//     //       data = await API().getUpcomingMovies("2021", "12");
//     //       setState(() {});
//     //     },
//     //     child: Text("")
//     //     ),
//     SizedBox(
//       width: 10,
//     ),
//     Text("${data.length}")

// If the call to the server was successful, parse the JSON

class Recommendation extends StatelessWidget {
  const Recommendation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
        ),
        Text(
          "Recommendation",
          style: TextStyle(color: kPrimaryColor),
        ),
      ],
    );
  }
}

// class selectedGenre extends StatefulWidget {
//   selectedGenre({Key? key}) : super(key: key);

//   @override
//   _selectedGenreState createState() => _selectedGenreState();
// }

// class _selectedGenreState extends State<selectedGenre> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(scrollDirection: Axis.horizontal, children: []);
//   }
// }

// Widget buildCard() => Container(
//       width: 12,
//       height: 10,
//       color: Colors.green,
//     );

//  body: CarouselSlider(
//           options: CarouselOptions(
//             autoPlay: true,
//             enlargeCenterPage: true,
//             scrollDirection: Axis.vertical,
//             onPageChanged: (index, reason) {
//               setState(
//                 () {
//                   _currentIndex = index;
//                 },
//               );
//             },
//           ),
//           items: imagesList
//               .map(
//                 (item) => Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Card(
//                     margin: EdgeInsets.only(
//                       top: 10.0,
//                       bottom: 10.0,
//                     ),
//                     elevation: 6.0,
//                     shadowColor: Colors.redAccent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(30.0),
//                       ),
//                       child: Stack(
//                         children: <Widget>[
//                           Image.network(
//                             item,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
