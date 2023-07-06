import 'package:flutter/material.dart';
import 'package:gamerev/services/auth_services.dart';
import 'package:givestarreviews/givestarreviews.dart';
import 'package:gamerev/services/review_service.dart';

class GameReviewPageReviewCard extends StatefulWidget {
  String name;
  int rating;
  String description;
  String gameId;
  String reviewId;
  final VoidCallback reloadGame;

  GameReviewPageReviewCard(
      {super.key,
      required this.name,
      required this.rating,
      required this.description,
      required this.gameId,
      required this.reviewId,
      required this.reloadGame});

  @override
  State<GameReviewPageReviewCard> createState() =>
      _GameReviewPageReviewCardState();
}

class _GameReviewPageReviewCardState extends State<GameReviewPageReviewCard> {
  final ReviewService _reviewService = ReviewService();

  final _authService = AuthService();

  bool _isUserAdmin = false;

  String _updatedReview = '';

  int _updatedRating = 0;

  String _name = '';

  @override
  void initState() {
    super.initState();
    _isAdmin();
    _getName();
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
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 31, 31, 31),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/user.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  StarRating(
                    value: widget.rating,
                    activeStarColor: Colors.orange,
                    inactiveStarColor: Colors.white,
                  ),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            _isUserAdmin || _name == widget.name
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  _updatedReview = widget.description;
                                  _updatedRating = widget.rating;

                                  return AlertDialog(
                                    backgroundColor: Colors.grey[900],
                                    title: const Text(
                                      'Edit Review',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          onChanged: (value) {
                                            _updatedReview = value;
                                          },
                                          controller: TextEditingController(
                                              text: widget.description),
                                          decoration: const InputDecoration(
                                            labelText: 'Review',
                                            labelStyle: TextStyle(
                                                color: Colors.deepOrange),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.deepOrange),
                                            ),
                                          ),
                                          cursorColor: Colors.deepOrange,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        TextField(
                                          onChanged: (value) {
                                            _updatedRating = int.parse(value);
                                          },
                                          controller: TextEditingController(
                                              text: widget.rating.toString()),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: 'Rating',
                                            labelStyle: TextStyle(
                                                color: Colors.deepOrange),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.deepOrange),
                                            ),
                                          ),
                                          cursorColor: Colors.deepOrange,
                                          style: const TextStyle(
                                              color: Colors.white),
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
                                            await _reviewService.updateReview(
                                                widget.gameId,
                                                widget.reviewId,
                                                _updatedRating,
                                                _updatedReview);

                                            Navigator.of(context)
                                                .pop(); // Close the dialog

                                            widget.reloadGame();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Review updated!",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                backgroundColor: Color.fromARGB(
                                                    255, 254, 216, 0),
                                              ),
                                            );
                                          } catch (e) {
                                            print("Request Field: $e");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text("Request failed!"),
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
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 16,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return AlertDialog(
                                        backgroundColor: const Color.fromARGB(
                                            255, 34, 34, 34),
                                        title: const Text('Delete Confirmation',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        content: const Text(
                                            'Are you sure you want to delete?',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel',
                                                style: TextStyle(
                                                    color: Colors.deepOrange)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                              child: const Text('Delete',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.deepOrange)),
                                              onPressed: () async {
                                                final ReviewService
                                                    reviewService =
                                                    ReviewService();
                                                try {
                                                  await reviewService
                                                      .deleteReview(
                                                          widget.gameId,
                                                          widget.reviewId);
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog box
                                                  widget.reloadGame();
                                                  // Refresh the screen
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Review deleted!",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 254, 216, 0),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  // Handle the error appropriately
                                                  print(e);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            "Deletetion faild!",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        backgroundColor:
                                                            Colors.red),
                                                  );

                                                  Navigator.of(context).pop();
                                                }
                                              }),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
