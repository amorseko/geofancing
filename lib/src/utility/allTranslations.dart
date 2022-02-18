import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _storageKey = "MyApplication_";
const List<String> _supportedLanguages = ['en','id'];
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class GlobalTranslations {
  Locale _locale;
  Map<dynamic, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;
  Iterable<Locale> supportedLocales() => _supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));
  String text(String key) {
    // Return the requested string
    return (_localizedValues == null || _localizedValues[key] == null) ? '** $key not found' : _localizedValues[key];
  }
  get currentLanguage => _locale == null ? '' : _locale.languageCode;
  get locale => _locale;
  Future<Null> init([String language]) async {
    if (_locale == null){
      await setNewLanguage(language);
    }
    return null;
  }
  getPreferredLanguage() async {
    return _getApplicationSavedInformation('language');
  }
  setPreferredLanguage(String lang) async {
    return _setApplicationSavedInformation('language', lang);
  }
  Future<Null> setNewLanguage([String newLanguage, bool saveInPrefs = true]) async {
    String language = newLanguage;
    if (language == null){
      language = await getPreferredLanguage();
    }
    // Set the locale
    if (language == ""){
      language = "en";
    }
    _locale = Locale(language, "");
    SharedPreferencesHelper.getLanguage().then((value){
      final data = json.decode(value);
      String jsonContent = locale.languageCode  == "en" ? json.encode(data["english"]) : json.encode(data['indonesia']);
      _localizedValues = json.decode(jsonContent);
    });

    // If we are asked to save the new language in the application preferences
    if (saveInPrefs){
      await setPreferredLanguage(language);
    }

    // If there is a callback to invoke to notify that a language has changed
    if (_onLocaleChangedCallback != null){
      _onLocaleChangedCallback();
    }

    return null;
  }
  set onLocaleChangedCallback(VoidCallback callback){
    _onLocaleChangedCallback = callback;
  }

  Future<String> _getApplicationSavedInformation(String name) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKey + name) ?? '';
  }

  Future<bool> _setApplicationSavedInformation(String name, String value) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKey + name, value);
  }

  static final GlobalTranslations _translations = new GlobalTranslations._internal();
  factory GlobalTranslations() {
    return _translations;
  }

  GlobalTranslations._internal();
}

GlobalTranslations allTranslations = new GlobalTranslations();