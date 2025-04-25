// lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('pt');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) async {
    _locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
    notifyListeners();
  }

  static Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'pt';
    return Locale(languageCode);
  }
}