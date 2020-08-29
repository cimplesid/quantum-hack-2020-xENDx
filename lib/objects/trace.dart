import 'package:dism/objects/app_user.dart';

class Trace {
  Trace({
    this.user,
    this.uuid,
    this.id,
    this.date,
  });

  AppUser user;
  String uuid;
  String id;
  int date;

  static Trace fromMap(Map<String, dynamic> json) => Trace(
        user: json["user"] != null ? AppUser.fromMap(json["user"]) : null,
        uuid: json["uuid"],
        id: json["id"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "user": user.toMap(),
        "uuid": uuid,
        "id": id,
        "date": date,
      };
 
}
