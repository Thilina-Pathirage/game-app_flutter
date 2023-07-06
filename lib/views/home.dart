import 'package:flutter/material.dart';
import 'package:gamerev/models/game.dart';
import 'package:gamerev/services/auth_services.dart';
import 'package:gamerev/services/game_service.dart';
import 'package:gamerev/widgets/game_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _imageList = [
    'images/marvel.jpeg',
    'images/warzone.jpg',
    'images/qDkJBu.jpeg'
  ];

  int _currentIndex = 0;

  List<Game> _games = [];
  bool _isLoading = true;

  String _name = '';

  bool _isUserAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadGames();
    _getName();
    _isAdmin();
  }

  final _gameService = GameService();

  Future<void> _loadGames() async {
    try {
      final games = await _gameService.getAllGames();
      if (mounted) {
        setState(() {
          _games = games;
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
          :
          //  FloatingActionButton(
          //     child: Icon(Icons.add),
          //     backgroundColor: Colors.deepOrange,
          //     onPressed: () {
          //       Navigator.pushNamed(context, '/addGame');
          //     },
          //   ),
      _isUserAdmin
          ? FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.deepOrange,
              onPressed: () {
                Navigator.pushNamed(context, '/addGame');
              },
            )
          : null,
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),
      appBar: _isLoading
          ? null
          : AppBar(
              title: Text('Welcome $_name!'),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.deepOrange,
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.account_circle, color: Colors.white),
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Logout'),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        _authService.logout(context);
                    }
                  },
                ),
              ],
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
              onRefresh: _loadGames,
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
                        Visibility(
                            visible: MediaQuery.of(context).size.width <
                                600, // show only on mobile
                            child: CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                height: MediaQuery.of(context).size.width > 600
                                    ? 400
                                    : 200,
                                viewportFraction: 1,
                              ),
                              items: _imageList.map((imageUrl) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        Positioned(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context, '/gameNews');
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red),
                                            ),
                                            child: const Text('News & Updates'),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }).toList(),
                            )),
                        const SizedBox(height: 16),
                        _games.isEmpty
                            ? Column(
                                children: const [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "There is no any games found!",
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
                                children: _games.map((game) {
                                  print(game.id);
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GameCard(
                                      context: context,
                                      game: game,
                                    ),
                                  );
                                }).toList(),
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
