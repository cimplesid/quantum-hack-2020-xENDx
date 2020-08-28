import 'package:dism/data/constants.dart';
import 'package:dism/helpers/firebase.dart';
import 'package:dism/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: RaisedButton.icon(
          color: Colors.red[600],
          textColor: Colors.white,
          onPressed: () async {
            var user = await firebase.loginWithGoogle();
            if (user != null)
              Get.to(Home());
            else
              Get.snackbar('Error', 'Something went wrong',
                  backgroundColor: Colors.red, colorText: Colors.red);
          },
          label: Icon(MdiIcons.google),
          icon: Text('Gogin with google'),
        ),
      ),
    );
  }
}
