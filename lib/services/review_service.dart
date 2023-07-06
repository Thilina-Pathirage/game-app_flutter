import 'dart:convert';
import 'package:gamerev/models/constants/constants.dart';
import 'package:gamerev/services/auth_services.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  final _authSrtvice = AuthService();

  Future<void> deleteReview(String gameId, String reviewId) async {
    // final String token = await _authSrtvice.getTokenFromPrefs();

    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $token'
    };

    final url = Uri.parse('$baseUrl/reviews/deleteReview/$gameId/$reviewId');
    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete review: ${response.statusCode}');
    }
  }

  Future<String> addReview(
      String gameId, String name, int rating, String review) async {
    final url = Uri.parse('$baseUrl/reviews/addReview/$gameId');

    // final String token = await _authSrtvice.getTokenFromPrefs();

    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $token'
    };

    final body = jsonEncode(
        {'userName': name, 'userRating': rating, 'review': review});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to add review: ${response.statusCode}');
    }
  }

  Future<String> updateReview(
      String gameId, String reviewId, int rating, String review) async {
    final url = Uri.parse('$baseUrl/reviews/updateReview/$gameId/$reviewId');

    // final String token = await _authSrtvice.getTokenFromPrefs();

    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $token'
    };

    final body = jsonEncode({'userRating': rating, 'review': review});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to update review: ${response.statusCode}');
    }
  }
}
