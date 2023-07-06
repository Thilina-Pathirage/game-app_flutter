import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class GameDetailsPageImage extends StatelessWidget {

  String image;
  
  GameDetailsPageImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    
    List<int> bytes = base64.decode(image);
    Uint8List uint8List = Uint8List.fromList(bytes);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Image.memory(
        uint8List,
        fit: BoxFit.cover,
      ),
    );
  }
}
