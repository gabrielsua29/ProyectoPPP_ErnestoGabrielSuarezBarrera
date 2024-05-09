import 'dart:convert';
import 'package:flutter/material.dart';

Future<String> getTranslatedString(BuildContext context, String key) async {
  try {
    // Get the language code of the current locale
    String languageCode = Localizations.localeOf(context).languageCode;

    // Load the appropriate JSON file based on the language code
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('lib/assets/i18n/locale/$languageCode.json');

    // Parse JSON
    Map<String, dynamic> translations = json.decode(jsonString);

    // Return translation if key exists
    if (translations.containsKey(key)) {
      return translations[key];
    } else {
      // If key does not exist, return an error message
      return 'Translation not found for key: $key';
    }
  } catch (error) {
    // Handle any errors that occur during the process
    print('Error loading translation: $error');
    return 'Error loading translation';
  }
}
