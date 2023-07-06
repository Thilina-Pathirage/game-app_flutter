import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gamerev/models/game.dart';
import 'package:gamerev/services/auth_services.dart';
import 'package:gamerev/services/news_service.dart';
import 'package:gamerev/utils/rating_utils.dart';
import 'package:gamerev/views/game_details.dart';

import '../models/news.dart';

class NewsCard extends StatefulWidget {
  final BuildContext context;
  final News news;
  const NewsCard({super.key, required this.context, required this.news});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
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

  @override
  void initState() {
    super.initState();
    _isAdmin();
  }

  @override
  Widget build(BuildContext context) {
    final NewsService _newsService = NewsService();

    String newTitle = '';
    String newDesc = '';

    return Card(
      color: const Color.fromARGB(255, 39, 39, 39),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = constraints.maxWidth;
          final double imageHeight = MediaQuery.of(context).size.width > 600
              ? cardWidth / 2.2
              : cardWidth / 2;
          final double ratingFontSize =
              MediaQuery.of(context).size.width > 600 ? 25 : 20;
          final double titleFontSize =
              MediaQuery.of(context).size.width > 600 ? 20 : 16;
          final double subtitleFontSize =
              MediaQuery.of(context).size.width > 600 ? 14 : 12;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                    width: double.infinity,
                    child: Image.asset('./images/Game-News-Background.jpg')),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          widget.news.title,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          widget.news.description,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: subtitleFontSize,
                            color: Colors.white,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "${widget.news.date.day}/${widget.news.date.month}/${widget.news.date.year}",
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _isUserAdmin
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                                          newTitle = widget.news.title;
                                          newDesc = widget.news.description;

                                          return AlertDialog(
                                            backgroundColor: Colors.grey[900],
                                            title: const Text(
                                              'Edit News',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  onChanged: (value) {
                                                    newTitle = value;
                                                  },
                                                  controller:
                                                      TextEditingController(
                                                          text: widget
                                                              .news.title),
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Title',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Colors.deepOrange),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .deepOrange),
                                                    ),
                                                  ),
                                                  cursorColor:
                                                      Colors.deepOrange,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                TextField(
                                                  onChanged: (value) {
                                                    newDesc = value;
                                                  },
                                                  controller:
                                                      TextEditingController(
                                                          text: widget.news
                                                              .description),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Description',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Colors.deepOrange),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .deepOrange),
                                                    ),
                                                  ),
                                                  cursorColor:
                                                      Colors.deepOrange,
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
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  try {
                                                    await _newsService
                                                        .updateNews(
                                                            widget.news.id,
                                                            newTitle,
                                                            newDesc);

                                                    Navigator.of(context).pop();
                                                    Navigator.of(context)
                                                        .pushReplacementNamed(
                                                            '/gameNews');

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Review updated!",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                254, 216, 0),
                                                      ),
                                                    );
                                                  } catch (e) {
                                                    print("Request Field: $e");
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Request failed!"),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.deepOrange,
                                                ),
                                                child: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
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
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 34, 34, 34),
                                                title: const Text(
                                                    'Delete Confirmation',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                content: const Text(
                                                    'Are you sure you want to delete?',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Cancel',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .deepOrange)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                      child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .deepOrange)),
                                                      onPressed: () async {
                                                        try {
                                                          await _newsService
                                                              .deleteNews(widget
                                                                  .news.id);
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog box
                                                          Navigator.of(context)
                                                              .pushReplacementNamed(
                                                                  '/gameNews');

                                                          // Refresh the screen
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  "News deleted!",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black)),
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          254,
                                                                          216,
                                                                          0),
                                                            ),
                                                          );
                                                        } catch (e) {
                                                          // Handle the error appropriately
                                                          print(e);
                                                          ScaffoldMessenger.of(
                                                                  context)
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

                                                          Navigator.of(context)
                                                              .pop();
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
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
