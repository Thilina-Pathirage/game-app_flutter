import 'package:gamerev/models/review.dart';

class Game {
  final String id;
  final String gameName;
  final String description;
  final String imageUrl;
  final double rating;
  final List<Review> reviews;

  Game({
    required this.id,
    required this.gameName,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
  });

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameName': gameName,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }
}
