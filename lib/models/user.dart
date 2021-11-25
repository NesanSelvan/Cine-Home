class UserModel {
  late String email;
  late String userPhoto;
  late String name;
  late List<String> favourites;

  UserModel(
      {required this.email,
      required this.userPhoto,
      required this.name,
      required this.favourites});

  UserModel.fromJson(Map<String, dynamic> jsonData) {
    email = jsonData['email'];
    name = jsonData['name'];
    userPhoto = jsonData['userPhoto'];
    final g = jsonData['favourites'] as List;
    List<String> gen = [];
    for (var item in g) {
      gen.add("$item");
    }
    favourites = gen;
  }
}
