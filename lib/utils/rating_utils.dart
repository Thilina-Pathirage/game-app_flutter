
import 'package:gamerev/models/review.dart';

double calculateAverageRating(List<Review> reviews) {
  if (reviews.isEmpty) {
    return 0;
  }
  double sum = 0;
  for (Review review in reviews) {
    sum += review.userRating;
  }
  return sum / reviews.length;
}
