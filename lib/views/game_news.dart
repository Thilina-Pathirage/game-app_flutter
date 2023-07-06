import 'package:flutter/material.dart';
import 'package:gamerev/models/game.dart';
import 'package:gamerev/models/news.dart';
import 'package:gamerev/services/auth_services.dart';
import 'package:gamerev/services/game_service.dart';
import 'package:gamerev/services/news_service.dart';
import 'package:gamerev/widgets/game_card.dart';
import 'package:gamerev/widgets/news_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GameNewsPage extends StatefulWidget {
  const GameNewsPage({super.key});

  @override
  State<GameNewsPage> createState() => _GameNewsPageState();
}

class _GameNewsPageState extends State<GameNewsPage> {
  int _currentIndex = 0;

  List<News> _news = [];
  bool _isLoading = true;

  String _name = '';

  bool _isUserAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadNews();
    _getName();
    _isAdmin();
  }

  final _newsService = NewsService();

  Future<void> _loadNews() async {
    try {
      final news = await _newsService.getAllNews();
      if (mounted) {
        setState(() {
          _news = news;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  final _authService = AuthService();

  Future<void> _getName() async {
    try {
      final name = await _authService.getUserName();
      if (mounted) {
        setState(() {
          _name = name;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _isAdmin() async {
    try {
      final isAdmin = await _authService.isAdmin();
      setState(() {
        _isUserAdmin = isAdmin;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isLoading
          ? null
          :  _isUserAdmin
          ? FloatingActionButton(
              backgroundColor: Colors.deepOrange,
              onPressed: () {
                Navigator.pushNamed(context, '/addNews');
              },
              child: const Icon(Icons.add),
            )
          : null,
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),
      appBar: _isLoading
          ? null
          : AppBar(
              backgroundColor: Colors.deepOrange,
              title: const Text('News & Updates'),
            ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Colors.deepOrange,
                size: 40,
              ),
            )
          : RefreshIndicator(
              backgroundColor: const Color.fromARGB(255, 21, 21, 21),
              color: Colors.deepOrange,
              onRefresh: _loadNews,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: GlowingOverscrollIndicator(
                    color: Colors
                        .deepOrange, // Set the color of the over-scroll indicator
                    axisDirection: AxisDirection
                        .down, // Specify the direction of the scroll view
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _news.isEmpty
                            ? const Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "There is no any News found!",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ],
                              )
                            : GridView.count(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 600
                                        ? 4
                                        : 1,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                // mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                children: _news.map(
                                  (news) {
                                    print("----$news.id");
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: NewsCard(
                                        context: context,
                                        news: news,
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
