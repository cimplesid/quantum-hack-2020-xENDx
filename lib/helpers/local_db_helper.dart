import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:snowm_scanner/snowm_scanner.dart';

class _DBhelper {
  SharedPreferences _sharedPreferences;
  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  setLocaldata(Map<String, dynamic> data) {
    var use = getHistory() ?? {};
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

  getHistoryInBeacon() {
    var use = getHistory();
    var usek = use.keys.toList();
    var usev = use.values.toList();
    Map<String, SnowMBeacon> newd = {};
    for (var i = 0; i < use.length; i++) {
      newd.addAll({usek[i]: _fromMap(usev[i])});
    }
    return newd;
  }
}

SnowMBeacon _fromMap(data) {
  return SnowMBeacon()
    ..uuid = data["uuid"]
    ..major = data["major"]
    ..minor = data["minor"]
    ..txPower = data["txPower"]
    ..detectedTime = data['detectedTime'];
}

final dbHelper = _DBhelper();
