import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _keyUser = 'user';

  static const myUser = User(
    imagePath: '',
    name: 'Ali Valiyev',
    email: 'ali@example.com',
    phone: '+998 90 123 45 67',
    about: 'Flutter dasturchi. Yangi narsalarni o‘rganishni yaxshi ko‘raman.',
    birthday: '15.05.1995',
  );

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());
    await _preferences.setString(_keyUser, json);
  }

  static User getUser() {
    final json = _preferences.getString(_keyUser);
    if (json == null) return myUser;
    return User.fromJson(jsonDecode(json));
  }
}