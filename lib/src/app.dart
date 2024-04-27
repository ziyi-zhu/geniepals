import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geniepals/src/character/character.dart';
import 'package:geniepals/src/chat/chat_provider.dart';
import 'package:provider/provider.dart';

import 'character/character_chat_screen.dart';
import 'character/character_list_screen.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class GeniePalsApp extends StatefulWidget {
  const GeniePalsApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<GeniePalsApp> createState() => _GeniePalsAppState();
}

class _GeniePalsAppState extends State<GeniePalsApp> {
  ChatProvider chatProvider = ChatProvider();

  @override
  void initState() {
    super.initState();
    chatProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => chatProvider),
      ],
      child: ListenableBuilder(
        listenable: widget.settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: ThemeData(
                primaryColor: const Color(0xFF2D2D44),
                brightness: Brightness.light,
                fontFamily: "WorkSans"),
            darkTheme: ThemeData(
                primaryColor: const Color(0xFF1E1E2C),
                brightness: Brightness.dark,
                fontFamily: "WorkSans"),
            themeMode: widget.settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(
                          controller: widget.settingsController);
                    case CharacterChatScreen.routeName:
                      final characterId =
                          ModalRoute.of(context)!.settings.arguments as int;
                      return CharacterChatScreen(
                        character: characters.firstWhere(
                            (character) => character.id == characterId),
                      );
                    case CharacterListScreen.routeName:
                    default:
                      return CharacterListScreen(
                        characters: characters,
                      );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
