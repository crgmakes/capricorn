import 'package:capricorn/src/log/app_logger.dart';
import 'package:flutter/material.dart';

import 'src/capricorn_app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final logger = AppLogger.getLogger();

  logger.i("BEGIN");

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(CapricornApp(settingsController: settingsController));

  logger.i("END");
}
