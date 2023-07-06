import 'dart:convert';
import 'package:gamerev/models/constants/constants.dart';
import 'package:gamerev/models/game.dart';
import 'package:gamerev/models/review.dart';
import 'package:gamerev/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class GameService {
  final _authSrtvice = AuthService();

  Future<List<Game>> getAllGames() async {
    // final String token = await _authSrtvice.getTokenFromPrefs();

    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(Uri.parse('$baseUrl/games/getAllGames'),
        headers: headers);
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List<dynamic>;
      final games = jsonList.map((e) => _fromJson(e)).toList();
      print(games);

      return games;
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<Game> getGameById(gameId) async {
    // final String token = await _authSrtvice.getTokenFromPrefs();

    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $token'
    };
    final response = await http
        .get(Uri.parse('$baseUrl/games/getGameById/$gameId'), headers: headers);
    if (response.statusCode == 200) {
      final jsonObject = json.decode(response.body) as Map<String, dynamic>;
      final game = _fromJson(jsonObject);
      return game;
    } else {
      throw Exception('Failed to load game');
    }
  }

  Future<Map<String, dynamic>> addGame(
      String gameName, String description, XFile pickedImage) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/games/addGame'));

    // Add game data as JSON
    Map<String, dynamic> gameData = {
      'gameName': gameName,
      'description': description,
      'rating': 5,
      'reviews': []
    };
    request.fields['game'] = jsonEncode(gameData);

    // Add image file if available
    String fileName = pickedImage.path.split('/').last;
    request.files.add(await http.MultipartFile.fromPath(
        'image', pickedImage.path,
        filename: fileName));

    var response = await request.send();
    if (response.statusCode == 200) {
      // Request succeeded
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      if (responseData == 'Game is inserted') {
        // Handle successful response without JSON
        return {'message': responseData};
      } else {
        try {
          return jsonDecode(responseData);
        } catch (e) {
          // Handle JSON decoding error
          throw Exception('Failed to parse response JSON: $responseData');
        }
      }
    } else {
      // Request failed
      throw Exception('Failed to add game: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> deleteGame(String gameId) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/games/deleteGame/$gameId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Request succeeded
      String responseData = response.body;
      if (responseData == 'Game is deleted') {
        // Handle successful response without JSON
        return {'message': responseData};
      } else {
        try {
          return jsonDecode(responseData);
        } catch (e) {
          // Handle JSON decoding error
          throw Exception('Failed to parse response JSON: $responseData');
        }
      }
    } else {
      // Request failed
      throw Exception('Failed to delete game: ${response.reasonPhrase}');
    }
  }

Future<String> updateGame(String gameId, String updatedGameName, String updatedDescription) async {
  final headers = {
    'Content-Type': 'application/json',
  };

  final gameData = {
    'gameName': updatedGameName,
    'description': updatedDescription,
  };

  final response = await http.put(
    Uri.parse('$baseUrl/games/updateGame/$gameId'),
    headers: headers,
    body: jsonEncode(gameData),
  );

  if (response.statusCode == 200) {
    return 'Game updated!';
  } else if (response.statusCode == 404) {
    return 'Game not found';
  } else {
    throw Exception('Failed to update game: ${response.reasonPhrase}');
  }
}


  Game _fromJson(dynamic json) {
    final reviewsList = json['reviews'] as List<dynamic>;
    final reviews = reviewsList.map((e) => _fromReviewJson(e)).toList();
    return Game(
      id: json['id'] as String,
      gameName: json['gameName'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: reviews,
    );
  }

  Review _fromReviewJson(dynamic json) {
    return Review(
      reviewId: json['reviewId'] as String,
      userName: json['userName'] as String,
      userRating: (json['userRating'] as int).toDouble(),
      review: json['review'] as String,
    );
  }
}
