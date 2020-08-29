import 'dart:async';

import 'package:dism/data/constants.dart';
import 'package:dism/helpers/firebase.dart';
import 'package:dism/helpers/local_db_helper.dart';
import 'package:dism/widgets/home_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:snowm_scanner/snowm_scanner.dart';
import 'package:firebase/firebase.dart';
import 'package:dism/objects/trace.dart' as t;
import 'package:timeago/timeago.dart' as timeago;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SnowMBeacon> detectedBeacons = [];
  BluetoothState state;
  List<StreamSubscription> subs = [];
  Map<String, SnowMBeacon> beacons = {};
  @override
  void initState() {
    super.initState();
    startListening();
    getBc();
  }

  getBc() async {
    ///TODO: add following line in beacon librarys lib/models/beacons.dart toMap method
    ///"detectedTime": detectedTime,
    beacons = dbHelper.getHistoryInBeacon();
    traces = await firebase.getLocationData();
    setState(() {});
  }

  startListening() async {
    var ids = [
      "F5407F30-F5F8-466E-AFF9-25556B57FE6D",
      "E1F54E02-1E23-44E0-9C3D-512EB56ADEC9"
    ];
    snowmScanner.getBluetoothStateStream().listen((state) async {
      if (this.mounted)
        setState(() {
          this.state = state;
        });
      if (state == BluetoothState.ON) {
        subs.add(snowmScanner
            .scanBeacons(uuids: ids, scanAllBeacons: true)
            .listen(setBeacons));
      } else if (state == BluetoothState.OFF) {
        showSnackbar("Please turn on bluetooth.");
      }
    });
  }

  @override
  void dispose() {
    for (var i = 0; i < subs.length; i++) {
      subs[i].cancel();
    }
    super.dispose();
  }

  showSnackbar(String message) {
    Get.snackbar('Turn on Bluetooth', message,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }

  setBeacons(List<SnowMBeacon> allDetectedBeacons) async {
    if (mounted) {
      setState(() {
        detectedBeacons = allDetectedBeacons;
      });
      var bc = beacons.values.toList();
      detectedBeacons.forEach((element) async {
        if (bc.length == 0) {
          dbHelper.setLocaldata({element.uuid: element.toMap()});
          await firebase.addUserLocationData(element.uuid);
        } else
          for (var i = 0; i < bc.length; i++) {
            if ((element.detectedTime - bc[i].detectedTime) > 3600000) {
              dbHelper.setLocaldata({element.uuid: element.toMap()});
              await firebase.addUserLocationData(element.uuid);
            }
          }
      });
      getBc();
    }
  }

  PageController pageControlle = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
        ),
        body: PageView.builder(
          controller: pageControlle,
          itemBuilder: (_, t) {
            if (t == 0)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: firebase.currentUser.img != null
                            ? NetworkImage(firebase.currentUser.img)
                            : null,
                        child: Text(
                          firebase.currentUser.name[0],
                          style: textStyle,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    firebase.currentUser.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 46),
                  ),
                  Text(
                    firebase.currentUser.email,
                    style: TextStyle(fontSize: 23),
                  ),
                  HomeCard(
                    color: Colors.red,
                    text: 'Contact Trace',
                    textStyle: textStyle.copyWith(fontSize: 30),
                    iconData: MdiIcons.locationEnter,
                    onTap: () {
                      pageControlle.jumpToPage(1);
                    },
                  ),
                  HomeCard(
                    onTap: () {
                      pageControlle.jumpToPage(2);
                    },
                    color: Colors.green,
                    text: 'Distance',
                    textStyle: textStyle.copyWith(fontSize: 30),
                    iconData: MdiIcons.divingScubaTank,
                  )
                ],
              );
            if (t == 1) return getTraceList();
            if (t == 2) return getBeaconList();
          },
          itemCount: 3,
        ));
  }

  var traces = [];
  getTraceList() {
    if (traces.isEmpty)
      return Center(
        child: Text('No Traces found'),
      );
    else
      return ListView.builder(
          itemCount: traces.length,
          itemBuilder: (context, i) {
            var data = traces[i] as t.Trace;
            return ListView.builder(itemBuilder: (context, snapshot) {
              return ListTile(
                title: Text(data.user.name),
                subtitle: Text(timeago
                    .format(DateTime.fromMillisecondsSinceEpoch(data.date))),
              );
            });
          });
  }

  getBeaconList() {
    if (detectedBeacons.isEmpty)
      return Center(
        child: Text('No Beacons found'),
      );
    else
      return ListView.builder(
        itemBuilder: (_, j) {
          return ListTile(
            title: Text(
              'Distance',
              style: TextStyle(fontSize: 30),
            ),
            subtitle: Text(detectedBeacons[j].uuid),
            trailing: Text(
              detectedBeacons[j].distance.toStringAsFixed(3) + "m",
              style: TextStyle(color: Colors.grey, fontSize: 30),
            ),
          );
        },
        itemCount: detectedBeacons.length,
      );
  }
}
