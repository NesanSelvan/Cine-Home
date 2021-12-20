import 'package:basics/models/ratings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingsFirestore {
  static final ratingsCollection =
      FirebaseFirestore.instance.collection("ratings");

  static addRatings(String userId, String movieId, double ratings) {
    // final ratingModel = RatingsModel(userId: userId, movieId: movieId, rating: ratings, timestamp: DateTime.now());
    // ratingsCollection.add(ratingModel.)
  }
}
