import 'package:flutter/material.dart';

class GameDetailsPageReviewHeading extends StatelessWidget {
  final String gameTitle;
  final double reviewCount;
  final String description;

  GameDetailsPageReviewHeading(
      {super.key, required this.gameTitle, required this.reviewCount, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              gameTitle,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),

          ListTile(
            title: Text(
              reviewCount.toStringAsFixed(1).toString(),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              description,
              style: const TextStyle(
                height: 1.5,
                fontSize: 14,
                color: Colors.white,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
