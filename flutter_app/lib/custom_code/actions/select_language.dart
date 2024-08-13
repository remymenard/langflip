// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import "package:world_countries/world_countries.dart";

Future<LanguageStruct?> selectLanguage(BuildContext context) async {
  final languagesList = [
    NaturalLanguage.fromName("French"),
    NaturalLanguage.fromName("English"),
    NaturalLanguage.fromName("Spanish"),
    NaturalLanguage.fromName("German"),
    NaturalLanguage.fromName("Italian"),
    NaturalLanguage.fromName("Portuguese"),
  ];

  Map<String, String> countryCodeMapping = <String, String>{
    "FRA": "fr-FR",
    "ENG": "en-US",
    "SPA": "es-ES",
    "DEU": "de-DE",
    "ITA": "it-IT",
    "POR": "pt-PT"
  };

  NaturalLanguage? selectedLanguage;

  print("open picker");
  final picker = LanguagePicker(languages: languagesList).copyWith(
    onSelect: (language) {
      selectedLanguage = language;
    },
  );
  await picker.showInDialog(context);
  if (selectedLanguage == null) return null;
  String country3DigitsCode = selectedLanguage!.code;
  String country4DigitsCode = countryCodeMapping[country3DigitsCode]!;
  String languageName = selectedLanguage!.name;

  return LanguageStruct(
      fourDigitsCode: country4DigitsCode,
      threeDigitsCode: country3DigitsCode,
      name: languageName);
}
