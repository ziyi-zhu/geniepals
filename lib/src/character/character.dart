import 'package:flutter/material.dart';

/// A placeholder class that represents an entity or model.
class Character {
  final int id;
  final List<Color> colors;
  final String imagePath;
  final String name;

  Character(
      {required this.id,
      required this.colors,
      required this.imagePath,
      required this.name});
}

List<Character> characters = [
  Character(
    id: 1,
    colors: [Colors.orange.shade200, Colors.deepOrange.shade400],
    imagePath: "assets/images/Kevin_minions.png",
    name: "Kevin",
  ),
  Character(
    id: 2,
    colors: [Colors.pink.shade200, Colors.redAccent.shade400],
    imagePath: "assets/images/Agnes_gru.png",
    name: "Agnes",
  ),
];
