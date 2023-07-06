import 'package:flutter/material.dart';
import 'package:gamerev/views/add_game.dart';
import 'package:gamerev/views/add_news.dart';
import 'package:gamerev/views/game_details.dart';
import 'package:gamerev/views/game_news.dart';
import 'package:gamerev/views/home.dart';
import 'package:gamerev/views/login_page.dart';
import 'package:gamerev/views/review_form.dart';
import 'package:gamerev/views/sign_up.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/gameDetails':
        return MaterialPageRoute(builder: (_) => GameDetails());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupPage());
      case '/reviewForm':
        return MaterialPageRoute(builder: (_) => ReviewForm());
      case '/addGame':
        return MaterialPageRoute(builder: (_) => AddGame());
      case '/gameNews':
        return MaterialPageRoute(builder: (_) => GameNewsPage());
      case '/addNews':
        return MaterialPageRoute(builder: (_) => AddNews());
      default:
        return MaterialPageRoute(builder: (_) => const Home());
    }
  }
}
