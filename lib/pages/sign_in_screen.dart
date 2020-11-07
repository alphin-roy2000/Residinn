import 'dart:io';

import 'package:ResidInn/components/custom_surfix_icon.dart';
import 'package:ResidInn/components/default_button.dart';
import 'package:ResidInn/components/form_error.dart';
import 'package:ResidInn/components/no_account_text.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/forgot_password_screen.dart';
import 'package:ResidInn/pages/home-screen.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "Resid",
                style: TextStyle(color: ksecondaryColor1),
              ),
              TextSpan(
                text: "Inn",
                style: TextStyle(color: kPrimaryColor),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sign in with your email and password",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  SignForm(),
                  SizedBox(
                    height: 10,
                  ),
                  NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool wait = false;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  savePref(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("hdshfgshdkfgakhsfgkg");
    setState(() {
      preferences.setString("id", id);
      preferences.setString("email", emailcontroller.text);
      preferences.setString("role", role);
      preferences.commit();
    });
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  var value;
  configureRealTimePushNotification(String id) async {
    if (Platform.isIOS) {
      getIOSPermission();
    }
    _firebaseMessaging.getToken().then((token) async {
      var result = await http_post(
          "androidtoken", {"userid": id, "androidtoken": token});
      if (result.data['code'] == 200) {
        print("notification set");
      }
      print(token);
    });
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> msg) async {
      final String recipientId = msg["data"]["recipient"];
      final String body = msg["notifications"]["body"];
      print("asfasfasf:$body");
      // if (recipientId == gUser.id) {
      //   SnackBar snackBar = SnackBar(
      //     content: Text(
      //       body,
      //       style: TextStyle(color: Colors.black),
      //       overflow: TextOverflow.ellipsis,
      //     ),
      //     backgroundColor: Colors.grey,
      //   );
      //   _scaffoldKey.currentState.showSnackBar(snackBar);
      // }
    });
  }

  getIOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(alert: true, badge: true, sound: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      print("Setting Registered: $settings");
    });
  }

  String passwordresponse;
  String response;
  String role;
  bool loading = false;

  checkUser() async {
    // if (_formKey.currentState.validate()) {
    // _formKey.currentState.save();
    print("hello inece");
    setState(() {
      loading = true;
    });
    removeError(error: "Not Corrext credentials");

    removeError(error: "Not correct password");
    removeError(error: "Server Error");

    try {
      var result = await http_post("login",
          {"email": emailcontroller.text, "password": passwordcontroller.text});
      print(result.data['code']);
      if (result.data['code'] == 400) {
        print(result.data['failed']);
      }
      if (result.data['code'] == 200) {
        setState(() {
          wholerole = result.data['role'];
          wholeuseremail = emailcontroller.text;
          wholeid = result.data['id'];
          wholeresid = result.data['resid'];
          if (wholerole == "user")
            configureRealTimePushNotification(wholeid);
          else {
            configureRealTimePushNotification(wholeresid);
          }
        });
        if (remember) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          setState(() {
            print(wholeid);
            preferences.setString("email", wholeuseremail);
            preferences.setString("role", wholerole);
            preferences.setString("id", wholeid);
            preferences.setString("resid", wholeresid);
            // preferences.commit();
          });
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => new HomeScreen()),
            (Route<dynamic> route) => false);
      } else if (result.data['code'] == 204) {
        addError(error: "Not correct password");
      } else if (result.data['code'] == 206) {
        addError(error: "Not Corrext credentials");
      } else {
        addError(error: "Server Error");
      }
    } catch (err) {
      addError(error: "Server Error");
    }
    setState(() {
      loading = false;
    });
    print(loading);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: 30),
          buildPasswordFormField(),
          SizedBox(height: 30),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ForgotPasswordScreen();
                    },
                  ),
                ),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.redAccent),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          loading == false
              ? DefaultButton(
                  text: "Login",
                  press: () {
                    checkUser();
                    // savePref("1");
                    // if (_formKey.currentState.validate()) {
                    //   _formKey.currentState.save();
                    //   // if all are valid then go to success screen
                    //   Navigator.of(context).pushAndRemoveUntil(
                    //       MaterialPageRoute(builder: (context) => new HomePage()),
                    //       (Route<dynamic> route) => false);
                    // }
                  },
                )
              : SpinKitWave(
                  size: 24, color: Colors.green, type: SpinKitWaveType.start),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordcontroller,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  String val;
  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailcontroller,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        // val = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
