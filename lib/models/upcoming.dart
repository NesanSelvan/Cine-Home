class UpcomingMoviesModel {
  late String title;
  late String link;
  late String poster;

  UpcomingMoviesModel(
      {required this.title, required this.link, required this.poster});

  UpcomingMoviesModel.fromJson(Map<String, dynamic> jsonData) {
    title = jsonData['title'];
    link = jsonData['link'];
    poster = jsonData['poster'];
  }
}
