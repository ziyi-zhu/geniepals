import 'package:flutter/material.dart';
import 'package:geniepals/src/character/character_widget.dart';

import '../settings/settings_view.dart';
import 'character.dart';

/// Displays a list of SampleItems.
class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key, required this.characters});

  static const routeName = '/';

  final List<Character> characters;

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: currentPage,
      keepPage: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),

        // To work with lists that may contain a large number of items, it’s best
        // to use the ListView.builder constructor.
        //
        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "GeniePals",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const TextSpan(text: "\n"),
                      TextSpan(
                          text: "Characters",
                          style: Theme.of(context).textTheme.displayMedium)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  // Providing a restorationId allows the ListView to restore the
                  // scroll position when a user leaves and returns to the app after it
                  // has been killed while running in the background.
                  restorationId: "characterListView",
                  controller: _pageController,
                  children: [
                    for (var i = 0; i < characters.length; i++)
                      CharacterWidget(
                        character: widget.characters[i],
                        pageController: _pageController,
                        currentPage: i,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
