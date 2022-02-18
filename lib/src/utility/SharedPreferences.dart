import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String _feature = 'feature';
  static final String _language = 'lang';

  static final String _year = 'year';
  static final String _month = 'month';
  static final String _day = 'day';
  static final String _login = 'login';


  static final String _token = 'token';
  static final String _iduser = 'id_user';
  static final String _id_dealer = 'id_dealer';
  static final String _username = 'username';

  static Future<bool> clearPreference(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getString(key);
    return preferences.remove(key);
  }

  static Future<bool> clearAllPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getString(_token);
    preferences.getString(_year);
    preferences.getString(_month);
    preferences.getString(_day);
    preferences.getString(_login);
    preferences.getString(_iduser);
    preferences.getString(_id_dealer);
    return preferences.clear();
  }

  /// ------------------------------------------------------------
  /// Set Get Token Preference
  /// ------------------------------------------------------------

  static Future<bool> setToken(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_token, "Bearer " + value);
  }

  static Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_token) ?? '';
  }

  /// ------------------------------------------------------------
  /// Set Get Login Json Data Preference
  /// ------------------------------------------------------------

  static Future<bool> setDoLogin(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_login, value);
  }

  static Future<String> getDoLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_login) ?? '';
  }

  /// ------------------------------------------------------------
  /// Set Get Application Language Json Data Preference
  /// ------------------------------------------------------------
  static Future<bool> setLanguage(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_language, value);
  }

  static Future<String> getLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_language) ?? '';
  }

  static Future<bool> setPosition(int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt("position", value);
  }

  static Future<int> getPosition() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt("position") ??  -1;
  }

  static Future<bool> setUsername(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_username, value);
  }

  static Future<String> getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_username) ?? '';
  }

  /// ------------------------------------------------------------
  /// Set Get Feature Preference
  /// ------------------------------------------------------------

  static Future<bool> setFeature(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_feature, value);
  }

  static Future<String> getFeature() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_feature) ?? '';
  }


}