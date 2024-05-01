import 'dart:convert';

import 'package:geniepals/src/chat/chat_provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

List<Content> chatHistory = [
  Content.text(
      "Hey, can you help me understand multiplication? We started it in school, and it's confusing."),
  Content.model([
    TextPart(
      jsonEncode(
        ChatResponse(
          speech:
              "Absolutely! Think of multiplication as a way to add the same number several times quickly. For example, what if you have 3 packs of stickers, and each pack has 4 stickers. How many stickers do you have in total?",
          sentiment: "positive",
          text: "3 x 4 = ?",
        ).toJson(),
      ),
    ),
  ]),
  Content.text("Do I have 7 stickers?"),
  Content.model([
    TextPart(
      jsonEncode(
        ChatResponse(
          speech:
              "Oh no, that's not quite right! Think of 4 stickers plus 4 stickers plus 4 stickers. Can you try adding them up?",
          sentiment: "negative",
          text: "4 + 4 + 4 = ?",
        ).toJson(),
      ),
    ),
  ]),
  Content.text(
    "That's 12 stickers!",
  ),
  Content.model([
    TextPart(
      jsonEncode(
        ChatResponse(
          speech: "Perfect! So, 3 times 4 is 12. You just multiplied!",
          sentiment: "positive",
          text: "3 x 4 = 12",
        ).toJson(),
      ),
    ),
  ]),
];
