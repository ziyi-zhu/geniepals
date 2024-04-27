import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:geniepals/src/character/character.dart';
import 'package:geniepals/src/chat/chat_provider.dart';
import 'package:provider/provider.dart';

/// Displays detailed information about a SampleItem.
class CharacterChatScreen extends StatefulWidget {
  const CharacterChatScreen({super.key, required this.character});

  static const routeName = '/character';
  final Character character;

  @override
  State<CharacterChatScreen> createState() => _CharacterChatScreenState();
}

class _CharacterChatScreenState extends State<CharacterChatScreen>
    with AfterLayoutMixin<CharacterChatScreen> {
  double _bottomSheetPosition = -330;
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);

    if (chatProvider.character == null ||
        chatProvider.character != widget.character) {
      chatProvider.character = widget.character;
      chatProvider.startNewChat();
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: "background-${widget.character.id}",
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.character.colors,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTapDown: (details) => _onTapDown(details, chatProvider),
            onTapUp: (details) => _onTapUp(details, chatProvider),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: _isCollapsed ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      Text(
                        chatProvider.isPermissionGranted
                            ? (chatProvider.isListening
                                ? "Listening..."
                                : "Hold and start speaking")
                            : "Enable microphone access",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          chatProvider.isPermissionGranted
                              ? (chatProvider.isListening
                                  ? Icons.mic
                                  : Icons.mic_none)
                              : Icons.mic_off,
                          size: 40,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Hero(
                  tag: "image-${widget.character.id}",
                  child: Image.asset(
                    widget.character.imagePath,
                    height: MediaQuery.of(context).size.height * 0.55,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 48.0, left: 16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                iconSize: 40,
                icon: const Icon(Icons.close),
                color: Colors.white.withOpacity(0.9),
                onPressed: () async {
                  setState(() {
                    _bottomSheetPosition = -330;
                  });
                  await chatProvider.speechToText.stop();
                  await chatProvider.flutterTts.stop();
                  Future.delayed(const Duration(milliseconds: 250), () {
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate,
            bottom: _bottomSheetPosition,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: _isCollapsed
                        ? _expandBottomSheet
                        : _collapseBottomSheet,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      height: 80,
                      child: Text(
                        "Memories",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _memoriesWidget(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memoriesWidget() {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Column(
            children: [
              roundedContainer(Colors.redAccent),
              const SizedBox(
                height: 20,
              ),
              roundedContainer(Colors.greenAccent),
            ],
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            children: [
              roundedContainer(Colors.orangeAccent),
              const SizedBox(
                height: 20,
              ),
              roundedContainer(Colors.purple),
            ],
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            children: [
              roundedContainer(Colors.grey),
              const SizedBox(
                height: 20,
              ),
              roundedContainer(Colors.blueGrey),
            ],
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            children: [
              roundedContainer(Colors.lightGreenAccent),
              const SizedBox(
                height: 20,
              ),
              roundedContainer(Colors.pinkAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget roundedContainer(Color color) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, ChatProvider chatProvider) {
    if (!_isCollapsed) {
      _collapseBottomSheet();
    } else {
      chatProvider.startListening();
    }
  }

  void _onTapUp(TapUpDetails details, ChatProvider chatProvider) {
    if (_isCollapsed) {
      chatProvider.stopListening();
    }
  }

  _collapseBottomSheet() {
    setState(() {
      _bottomSheetPosition = -250;
      _isCollapsed = true;
    });
  }

  _expandBottomSheet() {
    setState(() {
      _bottomSheetPosition = 0;
      _isCollapsed = false;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      _collapseBottomSheet();
    });
  }
}
