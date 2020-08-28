import 'package:meta/meta.dart';

class AppUser {
  String uid;
  String name;
  String email, img;
  num lat, long;

  AppUser({this.uid, this.name, this.email, this.lat, this.long, this.img});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['uid'] = uid;
    map['name'] = name;
    map['email'] = email;
    map['lat'] = lat;
    map['long'] = long;
    map['img'] = img;
    return map;
  }

  static AppUser fromMap(var user) {
    return AppUser(
        name: user['name'] ?? "sid",
        email: user['email'] ?? "sid@sdism.com",
        uid: user['uid'] ?? "dfgyhuighfhjkl",
        lat: user['lat'] ?? 0,
        long: user['long'] ?? 0,
        img: user['img']);
  }
}
