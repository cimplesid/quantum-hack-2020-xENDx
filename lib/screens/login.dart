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
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'DISM',
            style: textStyle..copyWith(fontSize: 55),
          ),
          Center(
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.red[600],
              textColor: Colors.white,
              onPressed: () async {
                var user = await firebase.loginWithGoogle();
                if (user != null) {
                  setState(() => _loading = true);
                  Get.offAll(Home());
                } else {
                  setState(() => _loading = false);
                  Get.snackbar('Error', 'Something went wrong',
                      backgroundColor: Colors.red, colorText: Colors.red);
                }
              },
              icon: _loading
                  ? CircularProgressIndicator(
                      strokeWidth: 3.0,
                    )
                  : Icon(MdiIcons.google),
              label: Text('Gogin with google'),
            ),
          ),
        ],
      ),
    );
  }
}
