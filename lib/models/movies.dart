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
    cover = jsonData['cover'] == ""
        ? "https://media.istockphoto.com/photos/popcorn-and-clapperboard-picture-id1191001701?k=20&m=1191001701&s=612x612&w=0&h=uDszifNzvgeY5QrPwWvocFOUCw8ugViuw-U8LCJ1wu8="
        : jsonData['cover'];
    series = jsonData['series'] == ""
        ? "https://media.istockphoto.com/photos/popcorn-and-clapperboard-picture-id1191001701?k=20&m=1191001701&s=612x612&w=0&h=uDszifNzvgeY5QrPwWvocFOUCw8ugViuw-U8LCJ1wu8="
        : jsonData['series'];
  }
}

class IMDBMoviesModel {
  late String id;
  late String name;
  late String cover;

  IMDBMoviesModel({
    required this.id,
    required this.name,
    required this.cover,
  });

  IMDBMoviesModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    name = jsonData['name'];
    final g = jsonData['genre'] as List;
    List<String> gen = [];
    for (var item in g) {
      gen.add("$item");
    }
    cover = jsonData['cover'] == ""
        ? "https://media.istockphoto.com/photos/popcorn-and-clapperboard-picture-id1191001701?k=20&m=1191001701&s=612x612&w=0&h=uDszifNzvgeY5QrPwWvocFOUCw8ugViuw-U8LCJ1wu8="
        : jsonData['cover'];
  }
}
