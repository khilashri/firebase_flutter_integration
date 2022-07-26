

import 'package:shared_preferences/shared_preferences.dart';
import 'package:userform/constant.dart';

class SharedPref {
  static Future<String?> uidGetter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(uidShared);
  }

  static storageset(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(uidShared, uid);
  }

  static Future<bool?> getbool(bool nameGetter) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getBool(nameShared);
    return null;
  }

  static Future setBool() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(nameShared, true);
  }

  static Future<int?> dateGetter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(dateShared);
  }

  static Future setInt(int date) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(dateShared,date);
  }
}
