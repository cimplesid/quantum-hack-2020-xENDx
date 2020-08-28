import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snowm_scanner/snowm_scanner.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SnowMBeacon> detectedBeacons;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar;
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
        if (snackbar != null) snackbar.close();
        subs.add(snowmScanner
            .scanBeacons(uuids: ids, scanAllBeacons: true)
            .listen(setBeacons));
      } else if (state == BluetoothState.OFF) {
        showSnackbar("Please turn on bluetooth.");
      }
    });
  }

  showSnackbar(String message) {
    Get.snackbar(
      'Turn on Bluetooth',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 60),
    );
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
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
