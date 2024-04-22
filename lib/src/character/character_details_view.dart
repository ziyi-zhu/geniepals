import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:geniepals/src/character/character.dart';

/// Displays detailed information about a SampleItem.
class CharacterDetailsView extends StatefulWidget {
  const CharacterDetailsView({super.key, required this.character});

  static const routeName = '/character';
  final Character character;

  @override
  State<CharacterDetailsView> createState() => _CharacterDetailsViewState();
}

class _CharacterDetailsViewState extends State<CharacterDetailsView>
    with AfterLayoutMixin<CharacterDetailsView> {
  double _bottomSheetPosition = -330;
  bool isCollapsed = true;

  @override
  Widget build(BuildContext context) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.close),
                  color: Colors.white.withOpacity(0.9),
                  onPressed: () {
                    setState(() {
                      _bottomSheetPosition = -330;
                    });
                    Future.delayed(const Duration(milliseconds: 250), () {
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              Hero(
                tag: "image-${widget.character.id}",
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    widget.character.imagePath,
                    height: 0.55 * MediaQuery.of(context).size.height,
                  ),
                ),
              ),
            ],
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
                    onTap: _onTap,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      height: 80,
                      child: Text(
                        "Messages",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 250,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onTap() {
    setState(() {
      _bottomSheetPosition = isCollapsed ? 0 : -250;
      isCollapsed = !isCollapsed;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _bottomSheetPosition = -250;
        isCollapsed = true;
      });
    });
  }
}
