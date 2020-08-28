import 'package:meta/meta.dart';

class AppUser {
  String uid;
  String name;
  String email;
  num lat, long;

  AppUser({this.uid, @required this.name, this.email, this.lat, this.long});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['uid'] = uid;
    map['name'] = name;
    map['email'] = email;
    map['lat'] = lat;
    map['long'] = long;
    return map;
  }

  static AppUser fromMap(var user) {
    return AppUser(
        name: user['name'],
        email: user['email'],
        uid: user['uid'],
        lat: user['lat'],
        long: user['long']);
  }
}
