import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class TranslationService extends Translations {
  static final Map<String, Map<String, String>> _localizedStrings = {};

  @override
  Map<String, Map<String, String>> get keys => _localizedStrings;

  static Future<void> loadTranslations() async {
    // Load JSON
    String jsonString =
        await rootBundle.loadString('assets/chichewa_english_dataset.json');
    List<dynamic> jsonList = json.decode(jsonString);

    // Parse JSON and set up localized strings
    for (var item in jsonList) {
      String chichewa = item['Chichewa Phrase'];
      String english = item['English Meaning'];

      _localizedStrings['en'] ??= {};
      _localizedStrings['ny'] ??= {};

      _localizedStrings['en']![english] = english; // Self-translate English
      _localizedStrings['ny']![english] = chichewa; // Translate to Chichewa
    }
  }

  static String? translateToChichewa(String englishText) {
    // Remove punctuation and convert to lowercase for comparison
    String sanitizedInput = _removePunctuation(englishText).toLowerCase();

    for (var entry in _localizedStrings['ny']!.entries) {
      String sanitizedKey = _removePunctuation(entry.key).toLowerCase();
      if (sanitizedKey == sanitizedInput) {
        return entry.value;
      }
    }
    return null;
  }

  static String? translateToEnglish(String chichewaText) {
    // Remove punctuation and convert to lowercase for comparison
    String sanitizedInput = _removePunctuation(chichewaText).toLowerCase();

    for (var entry in _localizedStrings['ny']!.entries) {
      String sanitizedValue = _removePunctuation(entry.value).toLowerCase();
      if (sanitizedValue == sanitizedInput) {
        return entry.key;
      }
    }
    return null;
  }

  static String _removePunctuation(String text) {
    // Remove common punctuation marks
    return text.replaceAll(RegExp(r'[^\w\s]'), '');
  }
}
