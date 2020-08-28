import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class _DBhelper {
  SharedPreferences _sharedPreferences;
  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  setLocaldata(Map<String, dynamic> data) {
    var use = getHistory();
    use.addAll(data);
    _sharedPreferences.setString("history", json.encode(use));
  }

  Map<String, dynamic> getHistory() {
    var sData = _sharedPreferences.getString("history");
    if (sData != null) {
      var d = json.decode(sData);
      print(d);
      return d;
    }
    return null;
  }
}

final dbHelper = _DBhelper();
