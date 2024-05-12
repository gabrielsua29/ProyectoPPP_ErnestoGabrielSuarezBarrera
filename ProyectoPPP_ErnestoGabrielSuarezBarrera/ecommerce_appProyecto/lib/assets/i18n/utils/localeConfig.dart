import 'dart:convert';
import 'package:flutter/material.dart';

Future<String> getTranslatedString(BuildContext context, String key) async {
  try {
    String languageCode = Localizations.localeOf(context).languageCode;

    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('lib/assets/i18n/locale/$languageCode.json');

    Map<String, dynamic> translations = json.decode(jsonString);

    if (translations.containsKey(key)) {
      return translations[key];
    } else {
      return 'Translation not found for key: $key';
    }
  } catch (error) {
    print('Error loading translation: $error');
    return 'Error loading translation';
  }
}
