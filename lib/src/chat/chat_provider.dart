import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geniepals/src/character/character.dart';
import 'package:geniepals/src/chat/eleven_labs_client.dart';
import 'package:geniepals/src/chat/prompt.dart';
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
    apiKey: dotenv.env['GOOGLE_API_KEY']!,
  );

  late ChatSession chat;
  Character? character;
  ElevenLabsClient? elevenLabsClient;

  FlutterTts flutterTts = FlutterTts();

  String _lastWords = '';
  bool isProcessing = false;

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

  void changeCharacter(Character newCharacter) {
    character = newCharacter;
    elevenLabsClient = ElevenLabsClient(
      apiKey: dotenv.env['ELEVEN_LABS_API_KEY']!,
      voiceId: newCharacter.voiceId,
    );
    startNewChat();
  }

  void startNewChat() {
    print(character!.instruction);
    chat = model.startChat(history: [
      Content.text(character!.instruction),
      Content.model([
        TextPart(
          jsonEncode(
            ChatResponse(
              speech:
                  "Hello! I am ${character!.name}, your virtual companion. How can I help you today?",
              sentiment: "positive",
            ).toJson(),
          ),
        )
      ]),
      ...chatHistory,
    ]);
  }

  Future<void> requestPermissions() async {
    _permissionStatuses = await _requiredPermissions.request();
    isPermissionGranted = _permissionStatuses.values.every(
      (status) => status.isGranted,
    );
    notifyListeners();
  }

  Future<void> startListening(
      {Function(ChatResponse)? onSpeechStart, Function? onSpeechEnd}) async {
    if (!isListening) {
      flutterTts.stop();
      await speechToText.listen(
        onResult: (result) async {
          if (result.finalResult) {
            _lastWords = result.recognizedWords;
            isProcessing = true;
            notifyListeners();

            final response = await processLastWords();
            ChatResponse chatResponse = ChatResponse.fromJson(response);

            // flutterTts.speak(test);
            elevenLabsClient!.speak(
              text: chatResponse.speech,
              onSpeechStart: () {
                isProcessing = true;
                notifyListeners();
                onSpeechStart?.call(chatResponse);
              },
              onSpeechEnd: () {
                isProcessing = false;
                notifyListeners();
                onSpeechEnd?.call();
              },
            );
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
  }

  Future<Map<String, dynamic>> processLastWords() async {
    print(_lastWords);
    final content = Content.text(_lastWords);
    final response = await chat.sendMessage(content);
    print(response.text);
    return jsonDecode(response.text!) as Map<String, dynamic>;
  }
}

class ChatResponse {
  late String speech;
  late String sentiment;
  String? text;

  ChatResponse({required this.speech, required this.sentiment, this.text});

  ChatResponse.fromJson(Map<String, dynamic> json) {
    speech = json["speech"] ?? "Oops! I didn't catch that.";
    sentiment = json["sentiment"] ?? "positive";
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['speech'] = speech;
    data['sentiment'] = sentiment;
    if (text != null) data['text'] = text;
    return data;
  }
}
