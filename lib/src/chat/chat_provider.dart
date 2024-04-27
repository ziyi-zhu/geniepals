import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geniepals/src/character/character.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatProvider with ChangeNotifier {
  bool isPermissionGranted = false;
  bool isListening = false;

  final player = AudioPlayer();
  final speechToText = SpeechToText();
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-1.0-pro',
    apiKey: 'AIzaSyCFx3gEeGaDPHU0P2cjTuC7sswvkf3uBSA',
  );

  late ChatSession chat;
  Character? character;

  FlutterTts flutterTts = FlutterTts();

  String _lastWords = '';

  final List<Permission> _requiredPermissions = [
    Permission.microphone,
    Permission.speech
  ];

  Map<Permission, PermissionStatus> _permissionStatuses = {};

  Future<void> initialize() async {
    await requestPermissions();
    if (isPermissionGranted) {
      speechToText.initialize();
    }
  }

  void startNewChat() {
    chat = model.startChat(history: [
      Content.text(character!.instruction),
      Content.model([
        TextPart(
            'Hello! I am ${character!.name}, your virtual companion. How can I help you today?')
      ])
    ]);
  }

  Future<void> requestPermissions() async {
    _permissionStatuses = await _requiredPermissions.request();
    isPermissionGranted = _permissionStatuses.values.every(
      (status) => status.isGranted,
    );
    notifyListeners();
  }

  Future{void startListening() async {
    if (!isListening) {
      flutterTts.stop();
      await speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            _lastWords = result.recognizedWords;
            processLastWords();
          }
        },
      );
      isListening = true;
      player.play(AssetSource('audio/happy-pop.mp3'));
    }
    notifyListeners();
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    if (isListening) {
      isListening = false;
      player.play(AssetSource('audio/multi-pop.mp3'));
    }
    notifyListeners();
    return null;
  }

  void processLastWords() async {
    print(_lastWords);
    final content = Content.text(_lastWords);
    final response = await chat.sendMessage(content);

    print(response.text);
    flutterTts.speak(response.text!);
  }
}
