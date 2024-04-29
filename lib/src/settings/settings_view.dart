import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('General'),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: const Text('English'),
                onPressed: (context) => null,
              ),
            ],
          ),
          SettingsSection(
            title: const Text('App'),
            tiles: [
              SettingsTile.switchTile(
                leading: const Icon(Icons.settings_brightness),
                initialValue: controller.themeMode == ThemeMode.dark,
                title: const Text('Dark Mode'),
                onToggle: (value) => controller
                    .updateThemeMode(value ? ThemeMode.dark : ThemeMode.light),
              ),
            ],
          ),
        ],
      ),

      // Padding(
      //   padding: const EdgeInsets.all(16),
      //   // Glue the SettingsController to the theme selection DropdownButton.
      //   //
      //   // When a user selects a theme from the dropdown list, the
      //   // SettingsController is updated, which rebuilds the MaterialApp.
      //   child: DropdownButton<ThemeMode>(
      //     // Read the selected themeMode from the controller
      //     value: controller.themeMode,
      //     // Call the updateThemeMode method any time the user selects a theme.
      //     onChanged: controller.updateThemeMode,
      //     items: const [
      //       DropdownMenuItem(
      //         value: ThemeMode.system,
      //         child: Text('System Theme'),
      //       ),
      //       DropdownMenuItem(
      //         value: ThemeMode.light,
      //         child: Text('Light Theme'),
      //       ),
      //       DropdownMenuItem(
      //         value: ThemeMode.dark,
      //         child: Text('Dark Theme'),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
