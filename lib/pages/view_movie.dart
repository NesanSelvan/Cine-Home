import 'package:basics/constants/constants.dart';
import 'package:basics/models/movies.dart';
import 'package:basics/models/ratings.dart';
import 'package:basics/pages/movies_screen.dart';
import 'package:basics/services/api.dart';
import 'package:flutter/material.dart';

class ViewMovie extends StatefulWidget {
  final MoviesModel moviesModel;

  const ViewMovie({Key? key, required this.moviesModel}) : super(key: key);

  @override
  State<ViewMovie> createState() => _ViewMovieState();
}

class _ViewMovieState extends State<ViewMovie> {
  List<MoviesModel> favMoviesList = [];
  String movieName = "";
  String year = "";
  List<RatingsModel> ratings = [];
  bool isLoading = true, isRatingLoading = true;

  getRatingForMovie() async {
    ratings = await API().getRatingsByMovieId(widget.moviesModel.id, "20000");
    isRatingLoading = false;
    setState(() {});
    favMoviesList =
        await API().getSimilarMoviesByMovieId(widget.moviesModel.id);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    movieName = widget.moviesModel.name;
    getRatingForMovie();
    if (widget.moviesModel.name.contains("(")) {
      movieName = widget.moviesModel.name.split("(").first;
      year = widget.moviesModel.name.split("(")[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Stack(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.45,
                        color: Colors.red,
                        child: Image.network(
                          widget.moviesModel.cover,
                          fit: BoxFit.cover,
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: CustomPaint(
                          foregroundPainter: FadingEffect(),
                        )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 24,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            movieName,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                year.replaceAll(")", ""),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[400]),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CircleContainer(),
                              SizedBox(
                                width: 10,
                              ),
                              Text(widget.moviesModel.genre.take(2).join(", ")),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          isRatingLoading
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: List.generate(
                                          getRatingsFromListOfSameMovies(
                                              ratings),
                                          (index) => Icon(
                                                Icons.star_outlined,
                                                color: Colors.yellow,
                                              )),
                                    ),
                                    Row(
                                      children: List.generate(
                                          5 -
                                              getRatingsFromListOfSameMovies(
                                                  ratings),
                                          (index) => Icon(
                                                Icons.star_border,
                                                color: Colors.grey,
                                              )),
                                    )
                                  ],
                                )
                        ],
                      ),
                    )
                  ],
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.7,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Labore Lorem cupidatat magna enim duis elit nostrud. Elit adipisicing sint aliquip ex duis aute tempor mollit consequat culpa deserunt. Pariatur aliqua adipisicing exercitation aliqua elit fugiat culpa et veniam incididunt sint. Qui nostrud ullamco qui exercitation commodo excepteur officia. Consequat ut consectetur officia eu dolor reprehenderit dolor aliquip deserunt incididunt ipsum.",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Cast",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.7,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: getRandomCast()
                          .map((e) => Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              decoration: BoxDecoration(
                                  // color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(e.userPhoto),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    e.name.capitalize(),
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )))
                          .toList(),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Recommanded  ",
                        style: TextStyle(
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(
                        "Movies ",
                        style: TextStyle(
                            letterSpacing: 0.7,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Container(
                                                child: MovieContainer(
                                                    moviesModel: e),
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
            )
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class CircleContainer extends StatelessWidget {
  const CircleContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(10)),
    );
  }
}

class FadingEffect extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height));
    LinearGradient lg = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          //create 2 white colors, one transparent
          Color.fromARGB(0, 0, 0, 0),
          Color.fromARGB(255, 0, 0, 0)
        ]);
    Paint paint = Paint()..shader = lg.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(FadingEffect linePainter) => false;
}
