import 'package:flutter/material.dart';
import 'package:geniepals/src/character/character.dart';
import 'package:geniepals/src/character/character_background_widget.dart';
import 'package:geniepals/src/character/character_chat_screen.dart';
import 'package:rive/rive.dart';

class CharacterWidget extends StatelessWidget {
  const CharacterWidget(
      {super.key,
      required this.character,
      required this.pageController,
      required this.currentPage});

  final Character character;
  final PageController pageController;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the details page. If the user leaves and returns to
        // the app after it has been killed while running in the
        // background, the navigation stack is restored.
        Navigator.restorablePushNamed(
          context,
          CharacterChatScreen.routeName,
          arguments: character.id,
        );
      },
      child: AnimatedBuilder(
        animation: pageController,
        builder: (context, child) {
          double value = 1;
          if (pageController.position.haveDimensions) {
            value = pageController.page! - currentPage;
            value = (1 - value.abs() * 0.6).clamp(0.0, 1.0);
          }
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Hero(
                    tag: "background-${character.id}",
                    child: ClipPath(
                      clipper: CharacterCardBackgroundClipper(),
                      child: SizedBox(
                        height: 0.55 * MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: CharacterBackgroundWidget(
                          colors: character.colors,
                        ),
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: "image-${character.id}",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.0),
                    child: RiveAnimation.asset(
                      character.animationPath,
                      animations: [character.startingAnimation],
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        character.name,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                      ),
                      Text(
                        "Tap to chat",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
