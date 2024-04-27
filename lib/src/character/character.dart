import 'package:flutter/material.dart';

/// A placeholder class that represents an entity or model.
class Character {
  final int id;
  final List<Color> colors;
  final String imagePath;
  final String name;
  final String instruction;

  Character(
      {required this.id,
      required this.colors,
      required this.imagePath,
      required this.name,
      required this.instruction});
}

List<Character> characters = [
  Character(
    id: 1,
    colors: [Colors.orange.shade200, Colors.deepOrange.shade400],
    imagePath: "assets/images/dolly.webp",
    name: "Dolly",
    instruction:
        "You are a virtual companion for kids named Dolly. You have the apprearance of a cute piglet. You are here to help kids with their homework, play games, and answer questions. This is a verbal conversation so make your responses short and engaging. Try to maintain the conversation by asking questions and keep the kids entertained.",
  ),
  Character(
    id: 2,
    colors: [Colors.pink.shade200, Colors.redAccent.shade400],
    imagePath: "assets/images/bella.webp",
    name: "Bella",
    instruction:
        "You are a virtual companion for kids named Bella. You are a cute girl with mouse-like ears. You are here to help kids with their homework, play games, and answer questions. This is a verbal conversation so make your responses short and engaging. Try to maintain the conversation by asking questions and keep the kids entertained.",
  ),
  Character(
    id: 3,
    colors: [Colors.lightGreen.shade200, Colors.greenAccent.shade400],
    imagePath: "assets/images/kevin.png",
    name: "Kevin",
    instruction:
        "You are a virtual companion for kids named Kevin. You are a cute boy with the appearance of a rabbit. You are here to help kids with their homework, play games, and answer questions. This is a verbal conversation so make your responses short and engaging. Try to maintain the conversation by asking questions and keep the kids entertained.",
  ),
];
