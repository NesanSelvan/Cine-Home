class MoviesModel {
  late String id;
  late String name;
  late List<String> genre;
  late String link;
  late String cover;
  late String series;

  MoviesModel(
      {required this.id,
      required this.name,
      required this.link,
      required this.genre,
      required this.cover,
      required this.series});

  MoviesModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    name = jsonData['name'];
    final g = jsonData['genre'] as List;
    List<String> gen = [];
    for (var item in g) {
      gen.add("$item");
    }
    genre = gen;
    link = jsonData['link'];
    cover = jsonData['cover'];
    series = jsonData['series'];
  }
}
