import 'package:flutter/material.dart';
import 'package:gamerev/models/game.dart';
import 'package:gamerev/services/auth_services.dart';
import 'package:gamerev/services/game_service.dart';
import 'package:gamerev/utils/rating_utils.dart';
import 'package:gamerev/views/home.dart';
import 'package:gamerev/views/review_form.dart';
import 'package:gamerev/widgets/game_deatails_page_image.dart';
import 'package:gamerev/widgets/game_details_page_review_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../widgets/game_details_page_review_heading.dart';

class GameDetails extends StatefulWidget {
  GameDetails({Key? key}) : super(key: key);

  @override
  _GameDetailsState createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  Game? game;

  final _gameService = GameService();
  bool _isLoading = true;

  String _updatedTitle = '';
  String _updatedDescription = '';
  String _name = '';
  bool _isUserAdmin = false;


  final _authService = AuthService();

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


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadGame();
    _isAdmin();
    _getName();
  }

  Future<void> _loadGame() async {
    _isLoading = true;
    final gameId = ModalRoute.of(context)?.settings.arguments as String?;
    try {
      final loadedGame = await _gameService.getGameById(gameId);
      if (mounted) {
        setState(() {
          game = loadedGame;
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            color: const Color.fromARGB(255, 21, 21, 21),
            child: Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Colors.deepOrange,
                size: 40,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 21, 21, 21),
            appBar: AppBar(
              backgroundColor: Colors.deepOrange,
              title: Text(game!.gameName),
            ),
            floatingActionButton: _isUserAdmin
                ? FloatingActionButton(
                    backgroundColor: Colors.deepOrange,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          _updatedTitle = game!.gameName;
                          _updatedDescription = game!.description;

                          return AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: const Text(
                              'Edit Game',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  onChanged: (value) {
                                    _updatedTitle = value;
                                  },
                                  controller: TextEditingController(
                                      text: _updatedTitle),
                                  decoration: const InputDecoration(
                                    labelText: 'Title',
                                    labelStyle:
                                        TextStyle(color: Colors.deepOrange),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.deepOrange),
                                    ),
                                  ),
                                  cursorColor: Colors.deepOrange,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextField(
                                  onChanged: (value) {
                                    _updatedDescription = value;
                                  },
                                  controller: TextEditingController(
                                      text: _updatedDescription),
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                    labelStyle:
                                        TextStyle(color: Colors.deepOrange),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.deepOrange),
                                    ),
                                  ),
                                  cursorColor: Colors.deepOrange,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await _gameService.updateGame(game!.id,
                                        _updatedTitle, _updatedDescription);

                                    Navigator.of(context)
                                        .pop(); // Close the dialog

                                    setState(() {
                                      _isLoading = true;
                                    });

                                    // Reload the game details
                                    await _loadGame();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Game updated!",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        backgroundColor:
                                            Color.fromARGB(255, 254, 216, 0),
                                      ),
                                    );
                                  } catch (e) {
                                    print("Request Field: $e");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Request failed!"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.edit),
                  )
                : const SizedBox(),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GameDetailsPageImage(
                      image: game!.imageUrl,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewForm(),
                              settings: RouteSettings(arguments: game!.id),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          textStyle: const TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(150, 50),
                        ),
                        child: const Text('Add Review'),
                      ),
                    ),
                    GameDetailsPageReviewHeading(
                      gameTitle: game!.gameName,
                      reviewCount: calculateAverageRating(game!.reviews),
                      description: game!.description,
                    ),
                    game!.reviews.isEmpty
                        ? const Column(
                            children: [
                              SizedBox(height: 16),
                              Text(
                                "There is no any reviews yet!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ],
                          )
                        : GridView.count(
                            crossAxisCount: 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            padding: const EdgeInsets.all(16),
                            shrinkWrap: true,
                            childAspectRatio:
                                MediaQuery.of(context).size.width > 600
                                    ? 6.0
                                    : 3.5,
                            physics: const NeverScrollableScrollPhysics(),
                            children: game!.reviews
                                .map(
                                  (review) => GameReviewPageReviewCard(
                                    name: review.userName,
                                    rating: review.userRating.toInt(),
                                    description: review.review,
                                    gameId: game!.id,
                                    reviewId: review.reviewId,
                                    reloadGame: _loadGame,
                                  ),
                                )
                                .toList()
                              ..sort((a, b) {
                                if (a.name == _name) {
                                  return -1; // Move a to the top
                                } else if (b.name == _name) {
                                  return 1; // Move b to the top
                                } else {
                                  return 0; // Keep the order unchanged
                                }
                              }),
                          ),
                    const SizedBox(height: 20.0),
                    _isUserAdmin
                        ? Column(
                            children: [
                              const Center(
                                child: Text(
                                  '---- Danger Zone ----',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: () async {
                                  bool confirm = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors
                                            .grey[900], // Set background color
                                        title: const Text('Confirmation',
                                            style: TextStyle(
                                                color: Colors
                                                    .white)), // Set title text color
                                        content: const Text(
                                          'Are you sure you want to delete this game?',
                                          style: TextStyle(color: Colors.white),
                                        ), // Set content text color
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  false); // Return false to indicate cancel
                                            },
                                            child: const Text('Cancel',
                                                style: TextStyle(
                                                    color: Colors
                                                        .white)), // Set button text color
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  true); // Return true to indicate confirm
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .deepOrange, // Set button background color
                                            ),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    try {
                                      await _gameService.deleteGame(game!.id);

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Home()),
                                        ModalRoute.withName('/home'),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Game deleted!",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          backgroundColor:
                                              Color.fromARGB(255, 254, 216, 0),
                                        ),
                                      );
                                    } catch (e) {
                                      print("Request Field: $e");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Request failed!"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  textStyle: const TextStyle(fontSize: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Delete Game'),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          );
  }
}
