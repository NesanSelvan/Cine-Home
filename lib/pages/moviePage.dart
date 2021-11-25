import 'package:basics/constants/SizeConfig.dart';
import 'package:basics/constants/constants.dart';
import 'package:basics/models/movies.dart';
import 'package:basics/pages/Drawer.dart';
import 'package:basics/pages/movies_screen.dart';
import 'package:basics/pages/search.dart';
import 'package:basics/services/api.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            categories(),
            movies(),
          ],
        ),
      ),

      // crossAxisAlignment: CrossAxisAlignment.start,
      // children: <Widget>[
      //   Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      //       child: Image.network(
      //         'https://image.shutterstock.com/image-vector/retro-poster-movie-show-time-600w-1891692937.jpg',
      //         scale: 25,
      //       ))
      // ]);
    );
  }
}

class categories extends StatefulWidget {
  categories({Key? key}) : super(key: key);

  @override
  _categoriesState createState() => _categoriesState();
}

class _categoriesState extends State<categories> {
  List<String> categories = [
    "All",
    "Action",
    "Sci Fi",
    "Thriller",
    "Adventure",
    "Horror",
    "Romance",
    "Comedy",
  ];
  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SizedBox(
      height: SizeConfig.screenheight! * 0.06,
      width: SizeConfig.screenwidth,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildCategoryItem(index),
      ),
    );
  }

  Widget buildCategoryItem(int index) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: SizeConfig.screenwidth! * 0.012),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenwidth! * 0.05,
            vertical: SizeConfig.screenheight! * 0.018),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
          color: selectedIndex == index ? kPrimaryColor : Colors.transparent,
        ),
        child: Text(
          categories[index],
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selectedIndex == index ? Colors.grey[850] : Colors.yellow,
              fontSize: SizeConfig.screenheight! * 0.02),
        ),
      ),
    );
  }
}

class movies extends StatefulWidget {
  movies({Key? key}) : super(key: key);

  @override
  _moviesState createState() => _moviesState();
}

class _moviesState extends State<movies> {
  bool isLoading = true;

  List<MoviesModel> moviesApi = [];
  void getMovies() async {
    moviesApi = await API().getMovies(50);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: 155,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          )
        : Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                direction: Axis.horizontal,
                children: moviesApi
                    .map((e) => MovieContainer(moviesModel: e))
                    .toList(),
              ),
            ),
          );
  }
}
