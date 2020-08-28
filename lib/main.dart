import 'package:dism/data/constants.dart';
import 'package:dism/helpers/firebase.dart';
import 'package:dism/helpers/permission.dart';
import 'package:dism/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snowm_scanner/snowm_scanner.dart';

import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  snowmScanner.configure(enableMqtt: false);
  var user = await firebase.init();
  await mPermission.checkPermission();
  await mPermission.requestPermission();
  // await firebase.manageUser(local: false);
  runApp(GetMaterialApp(
    home: user != null ? Home() : LoginScreen(),
    theme: ThemeData(
        textTheme: GoogleFonts.montagaTextTheme(), primaryColor: primaryColor),
    debugShowCheckedModeBanner: false,
    title: 'DISM',
  ));
}
