class RatingsModel {
  late String userId;
  late String movieId;
  late double rating;
  late String timestamp;

  RatingsModel(
      {required this.userId,
      required this.movieId,
      required this.rating,
      required this.timestamp});

  RatingsModel.fromJson(Map<String, dynamic> jsonData) {
    userId = jsonData['userId'];
    movieId = jsonData['movieId'];
    rating = double.tryParse("${jsonData['rating']}") ?? 0;
    timestamp = jsonData['timestamp'];
  }
}
