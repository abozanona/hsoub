import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsoub/screens/widgets/widgets.dart';
import 'package:hsoub/themes/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class Utils {
  static Future<Null> saveString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static Future<String> getString(String key, {String defaultValue = ''}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key) == null ? defaultValue : preferences.get(key).toString();
  }

  static Future<String> getJson(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key) == null ? '{}' : preferences.get(key).toString();
  }

  static Future removeString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }

  static showToast(text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(AppTheme.primary),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showLoadingIndicator(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              backgroundColor: Colors.black87,
              content: LoadingIndicator(text: text),
            ));
      },
    );
  }

  static String formatDateAgo(String date) {
    try {
      return timeago.format(DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(date));
    } catch (ex) {
      return '-';
    }
  }
}
