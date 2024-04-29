import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class ElevenLabsClient {
  final String apiKey;
  final String voiceId;

  ElevenLabsClient({required this.apiKey, required this.voiceId});

  Future speak(String text) async {
    try {
      final player = AudioPlayer();
      final bytes = await _fetch(text);
      player.setAudioSource(AudioBytesSource(bytes));
      player.play();
    } catch (ex) {
      print('Error: $ex');
    }
  }

  Future<Uint8List> _fetch(String text) async {
    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceId';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'xi-api-key': apiKey,
        'Content-Type': 'application/json',
        'accept': 'audio/mpeg',
      },
      body: convert.json.encode({
        "text": text,
        "voice_settings": {
          "stability": 0.3,
          "similarity_boost": 0.5,
        },
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Eleven Labs API Failed.');
    }
    return response.bodyBytes;
  }
}

class AudioBytesSource extends StreamAudioSource {
  final List<int> bytes;

  AudioBytesSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
