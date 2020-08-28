import 'dart:async';

import 'package:dism/data/constants.dart';
import 'package:dism/helpers/firebase.dart';
import 'package:dism/widgets/home_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:snowm_scanner/snowm_scanner.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SnowMBeacon> detectedBeacons;
  BluetoothState state;
  List<StreamSubscription> subs = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      startListening();
    });
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

  showSnackbar(String message) {
    Get.snackbar('Turn on Bluetooth', message,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }
  

  setBeacons(List<SnowMBeacon> allDetectedBeacons) async {
    if (mounted)
      setState(() {
        detectedBeacons = allDetectedBeacons;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(firebase.currentUser?.img ?? ""),
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
          ),
          HomeCard(
            color: Colors.green,
            text: 'Distance',
            textStyle: textStyle.copyWith(fontSize: 30),
            iconData: MdiIcons.divingScubaTank,
          )
        ],
      ),
    );
  }
}
