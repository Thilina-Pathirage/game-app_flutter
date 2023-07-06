import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gamerev/services/auth_services.dart';
import 'package:gamerev/services/review_service.dart';
import 'package:gamerev/views/game_details.dart';
import 'package:gamerev/views/home.dart';
import 'package:geolocator/geolocator.dart';

class ReviewForm extends StatefulWidget {
  ReviewForm({super.key});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _reviewController = TextEditingController();

  final _reviewFocusNode = FocusNode();

  final _authService = AuthService();

  final _reviewService = ReviewService();

  String _userName = '';

  int _userRating = 3;

  String? _gameId = '';

  late Position position;

  String lat = '';

  String long = '';

  bool locationAccess = false;

  bool _validateReview(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _reviewFocusNode.addListener(() {
      if (!_reviewFocusNode.hasFocus) {
        _reviewController.clear();
      }
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _reviewFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getUser() async {
    try {
      final userName = await _authService.getUserName();

      setState(() {
        _userName = userName;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      try {
        Position position = await Geolocator.getCurrentPosition();
        lat = position.latitude.toString();
        long = position.longitude.toString();
        setState(() {
          locationAccess = true;
        });
        print(position);
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_reviewFocusNode.hasFocus) {
          _reviewFocusNode.unfocus();
          return false;
        }

        Navigator.of(context, rootNavigator: true).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 21, 21, 21),
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: const Text('Add review'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Rate here!',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Center(
                    child: RatingBar.builder(
                      unratedColor: const Color.fromARGB(255, 80, 80, 80),
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return const Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.red,
                            );
                          case 1:
                            return const Icon(
                              Icons.sentiment_dissatisfied,
                              color: Colors.redAccent,
                            );
                          case 2:
                            return const Icon(
                              Icons.sentiment_neutral,
                              color: Colors.amber,
                            );
                          case 3:
                            return const Icon(
                              Icons.sentiment_satisfied,
                              color: Colors.lightGreen,
                            );
                          case 4:
                            return const Icon(
                              Icons.sentiment_very_satisfied,
                              color: Color.fromARGB(255, 139, 214, 0),
                            );
                          default:
                            return Container();
                        }
                      },
                      onRatingUpdate: (rating) {
                        setState(() {
                          _userRating = rating.toInt();
                        });
                      },
                      updateOnDrag: true,
                    ),
                  ),
                  const SizedBox(height: 46),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextFormField(
                      controller: _reviewController,
                      decoration: const InputDecoration(
                        labelText: 'Describe your experience!',
                        labelStyle: TextStyle(color: Colors.deepOrange),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrange),
                        ),
                      ),
                      cursorColor: Colors.deepOrange,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton(
                    onPressed: () async {
                      await _getLocation();

                      if (_validateReview(_reviewController.text)) {
                        if (locationAccess) {
                          try {
                            _gameId = ModalRoute.of(context)?.settings.arguments
                                as String?;
                            await _reviewService.addReview(
                                _gameId!,
                                _userName,
                                _userRating,
                                _reviewController.text);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                              ModalRoute.withName('/'),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Review added successful!",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor:
                                    Color.fromARGB(255, 254, 216, 0),
                              ),
                            );
                          } catch (e) {
                            // Signup failed, show error message or handle the error
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Review failed!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Location services are disabled."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("All fields are required!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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
                    child: const Text('POST'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
