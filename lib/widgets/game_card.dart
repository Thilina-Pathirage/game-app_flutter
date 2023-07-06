import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gamerev/models/game.dart';
import 'package:gamerev/utils/rating_utils.dart';
import 'package:gamerev/views/game_details.dart';

class GameCard extends StatelessWidget {
  final BuildContext context;
  final Game game;
  const GameCard({super.key, required this.context, required this.game});

  @override
  Widget build(BuildContext context) {

    List<int> bytes = base64.decode(game.imageUrl);
    Uint8List uint8List = Uint8List.fromList(bytes);

    return Card(
      color: const Color.fromARGB(255, 39, 39, 39),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.deepOrange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameDetails(),
              settings: RouteSettings(arguments: game.id),
            ),
          );

          // Navigator.pushNamed(context, '/gameDetails', arguments: game);
        },
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
                SizedBox(
                  width: double.infinity,
                  height: imageHeight,
                  child: Image.memory(
                    uint8List,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.star,
                            color: Colors.white,
                          ),
                          title: Text(
                            calculateAverageRating(game.reviews).toStringAsFixed(1).toString(),
                            style: TextStyle(
                              fontSize: ratingFontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            game.gameName,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            game.description,
                            style: TextStyle(
                              height: 1.5,
                              fontSize: subtitleFontSize,
                              color: Colors.white,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
