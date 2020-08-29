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
            style: TextStyle(fontSize: 55, color: Colors.white),
          ),
          Center(
            child: _loading
                ? CircularProgressIndicator(
                    strokeWidth: 3.0,
                  )
                : RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: Colors.red[600],
                    textColor: Colors.white,
                    onPressed: () async {
                      setState(() => _loading = true);
                      var user = await firebase.loginWithGoogle();
                      if (user != null) {
                        Get.offAll(Home());
                      } else {
                        setState(() => _loading = false);
                        Get.snackbar('Error', 'Something went wrong',
                            backgroundColor: Colors.red, colorText: Colors.red);
                      }
                    },
                    icon: Icon(MdiIcons.google),
                    label: Text('Login with google'),
                  ),
          ),
        ],
      ),
    );
  }
}
