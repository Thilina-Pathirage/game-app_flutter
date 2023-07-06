import 'dart:convert';
import 'package:gamerev/models/constants/constants.dart';
import 'package:gamerev/models/news.dart';
import 'package:gamerev/services/auth_services.dart';
import 'package:http/http.dart' as http;

class NewsService {
  final _authService = AuthService();

  Future<String> addNews(String title, String description) async {
    final url = Uri.parse('$baseUrl/news/addNews');

    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
    };

    var date = DateTime.now();

    final body = jsonEncode({'title': title, 'description': description, 'date': date.toIso8601String()});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to add news: ${response.statusCode}');
    }
  }

  Future<List<News>> getAllNews() async {
    final url = Uri.parse('$baseUrl/news/getAllNews');

    final headers = {
      'Access-Control-Allow-Origin': '*',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => News.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }

  Future<void> deleteNews(String id) async {
    final url = Uri.parse('$baseUrl/news/deleteNews/$id');

    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete news: ${response.statusCode}');
    }
  }

  Future<String> updateNews(String id, String title, String description) async {
    final url = Uri.parse('$baseUrl/news/updateNews/$id');

    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({'title': title, 'description': description});

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to update news: ${response.statusCode}');
    }
  }
}
