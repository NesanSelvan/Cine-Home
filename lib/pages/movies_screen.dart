import 'package:basics/constants/SizeConfig.dart';
import 'package:basics/constants/constants.dart';
import 'package:basics/models/movies.dart';
import 'package:basics/pages/view_movie.dart';
import 'package:flutter/material.dart';

class MoviesScreen extends StatelessWidget {
  final String screenTitle;
  final List<MoviesModel> moviesList;

  const MoviesScreen(
      {Key? key, required this.screenTitle, required this.moviesList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: BuildMovieContainer(moviesList: moviesList),
      ),
    );
  }
}

class BuildMovieContainer extends StatelessWidget {
  const BuildMovieContainer({
    Key? key,
    required this.moviesList,
  }) : super(key: key);

  final List<MoviesModel> moviesList;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: moviesList
          .map((e) => MovieContainer(
                moviesModel: e,
              ))
          .toList(),
    );
  }
}

class MovieContainer extends StatelessWidget {
  final MoviesModel moviesModel;
  const MovieContainer({
    Key? key,
    required this.moviesModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewMovie(moviesModel: moviesModel)));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: SizedBox(
              width: SizeConfig.screenwidth! * 0.4,
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          getRandomthumbnail(),
                          // moviesModel.cover
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${moviesModel.name}",
                  style: TextStyle(
                      color: Colors.grey[350], fontWeight: FontWeight.bold),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
