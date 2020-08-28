import 'package:dism/data/constants.dart';
import 'package:dism/helpers/firebase.dart';
import 'package:dism/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSM',
      theme: ThemeData(primaryColor: primaryColor),
      home: isLoggedIn ? Home() : LoginScreen(),
    );
  }

  bool isLoggedIn = false;
  init() async {
    var user = await firebase.init();
    if (user != null) {
      setState(() {
        isLoggedIn = true;
      });
    } else
      setState(() {
        isLoggedIn = false;
      });
  }
}
