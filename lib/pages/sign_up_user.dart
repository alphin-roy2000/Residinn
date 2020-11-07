import 'dart:async';

import 'package:ResidInn/constants.dart';
import 'package:ResidInn/geolocator/model.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/home-screen.dart';
import 'package:ResidInn/pages/location.dart';
import 'package:ResidInn/pages/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ResidInn/animation/fadeanimation.dart';

class SignUpUserScreen extends StatefulWidget {
  @override
  _SignUpUserScreenState createState() => _SignUpUserScreenState();
}

class _SignUpUserScreenState extends State<SignUpUserScreen> {
  String email;
  String password;
  String conpassword;
  String reshousename;
  String phonenumber;
  String codeforcheck;
  String latitude = "0";
  String longitude = "0";
  bool codeok = false;
  String codeaftercheck = "Code is invalid";
  bool loading = false;
  String test;
  Map<String, double> currentLocation = Map();
  Address address;

  final _formKey = GlobalKey<FormState>();
  @override
  initState() {
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    super.initState();
  }

  int gotfromloc = 0;

  Future<void> signupUser() async {
    var result = await http_post("registeruser", {
      "email": email,
      "password": password,
      "phonenumber": phonenumber,
      "housename": reshousename,
      "ownername": ownername,
      "code": codeforcheck,
      "latitude": latitude,
      "longitude": longitude
    });
    print(result.data['code']);
    // print(result.data['role']);

    if (result.data['code'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        wholerole = result.data['role'];
        wholeuseremail = email;
        wholeid = result.data['id'];
        wholeresid = result.data['resid'];
        print(wholeid);
        preferences.setString("email", wholeuseremail);
        preferences.setString("role", wholerole);
        preferences.setString("id", wholeid);
        preferences.setString("resid", wholeresid);
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => new HomeScreen()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> codefornode() async {
    var result = await http_post("codecheck", {"code": codeforcheck});
    print(result.data['code']);

    if (result.data['code'] == 200) {
      setState(() {
        codeaftercheck = result.data['nametext'];
        codeok = true;
      });
    } else {
      setState(() {
        codeaftercheck = "Code is invalid";
        codeok = false;
      });
    }
  }

  Location location = Location();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController locationcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Create an resident account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      textfieldcustom(
                          "Residential name", false, TextInputType.text, 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: (MediaQuery.of(context).size.width / 1.4),
                            child: ListTile(
                                leading: IconButton(
                                  icon: Icon(Icons.person_pin_circle),
                                  iconSize: 26,
                                  color: gotfromloc == 2
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  onPressed: () async {
                                    setState(() {
                                      gotfromloc = 1;
                                    });
                                    await location.getCurrentLocation();
                                    setState(() {
                                      gotfromloc = 2;
                                      latitude = location.latitude.toString();
                                      longitude = location.longitude.toString();
                                    });
                                  },
                                ),
                                title: (gotfromloc == 1)
                                    ? loadingWidget
                                    : Text("Get location")),
                          ),
                        ],
                      ),
                      textfieldcustom(
                          "Ownername", false, TextInputType.text, 5),
                      textfieldcustom(
                          "Email", false, TextInputType.emailAddress, 1),
                      textfieldcustom(
                          "Password", true, TextInputType.visiblePassword, 2),
                      textfieldcustom("Confirm Password", true,
                          TextInputType.visiblePassword, 3),
                      Container(
                        child: ListTile(
                            trailing: codeok == false
                                ? RaisedButton(
                                    onPressed: () {
                                      codefornode();
                                    },
                                    child: new Text("Check code"),
                                  )
                                : RaisedButton(
                                    onPressed: () {
                                      changecode();
                                    },
                                    child: new Text("Change Code"),
                                  ),
                            title: codeok == false
                                ? textfieldcustom(
                                    "Code Check", false, TextInputType.text, 4)
                                : Text("$codeforcheck")),
                      ),
                      checkfunction(),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        if (true) {
                          if (_formKey.currentState.validate()) {
                            if (codeok) {
                              signupUser();
                            } else {}
                          }

                          // SnackBar snackBar = SnackBar(
                          //     content: Text(
                          //         "Check for the residence using code"));
                          // _scaffoldKey.currentState.showSnackBar(snackBar);
                          // Timer(Duration(seconds: 4), () {});

                        }
                      },
                      color: Colors.greenAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  changecode() {
    setState(() {
      codeok = false;
    });
  }

  checkfunction() {
    return Text("Residence name: $codeaftercheck");
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatepassword(String value) {
    if (value.isEmpty) return 'Password Cannot be empty';
    if (value.length <= 8) return 'password length should greater than 8';
    return null;
  }

  String confirmpassword(String value) {
    print("cong $conpassword pass $password");
    if (value.isEmpty) return 'Empty';
    if (value.length <= 8) return 'password length should greater than 8';

    if (value != password) return 'Not Match';
    return null;
  }

  String confirmcode(String value) {
    if (value.isEmpty) return 'Empty';
    if (!codeok) return 'Invalid Code';
    return null;
  }

  String others(String value) {
    if (value.isEmpty) return 'Empty field';

    return null;
  }

  String ownername;
  textfieldcustom(String label, bool obscure, TextInputType type, int t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          onChanged: (newValue) {
            if (t == 0) reshousename = newValue;

            if (t == 1) email = newValue;
            if (t == 2) password = newValue;
            if (t == 3) conpassword = newValue;
            if (t == 4) codeforcheck = newValue;
            if (t == 5) ownername = newValue;
          },
          obscureText: obscure,
          validator: (val) {
            if (t == 0) return others(val);
            if (t == 1) return validateEmail(val);
            if (t == 2) return validatepassword(val);
            if (t == 3) return confirmpassword(val);
            if (t == 4) return confirmcode(val);
            if (t == 5) return others(val);
          },
          keyboardType: type,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
