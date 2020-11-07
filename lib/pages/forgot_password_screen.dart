import 'dart:async';

import 'package:ResidInn/components/custom_surfix_icon.dart';
import 'package:ResidInn/components/default_button.dart';
import 'package:ResidInn/components/form_error.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text("Forgot Password"),
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .1),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  // checkUser() async {
  //   // if (_formKey.currentState.validate()) {
  //   // _formKey.currentState.save();
  //   print("hello inece");
  //   var result = await http_post("forgot", {"email": emailcontroller.text});
  //   print(result.data['code']);
  //   if (result.data['code'] == 200) {
  //     setState(() {});
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => new HomeScreen()),
  //         (Route<dynamic> route) => false);
  //   } else if (result.data['code'] == 204) {}
  // }
  sendmail() async {
    var result = await http_post("forgot", {"email": emailcontroller.text});
    print(result.data['code']);
    if (result.data['code'] == 400) print(result.data['value']);
    if (result.data['code'] == 200) {
      SnackBar snackBar =
          SnackBar(content: Text("Email send for resetting password"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 4), () {
        Navigator.pop(context);
      });
    } else if (result.data['code'] == 206) {
      SnackBar snackBar = SnackBar(content: Text("Email is not registered"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  TextEditingController emailcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String email;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailcontroller,
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              return null;
            },
            validator: (value) {
              if (value.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
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
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .3),
          FormError(errors: errors),
          SizedBox(height: 30),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                sendmail();
              }
            },
          ),
          // Spacer(),
          // NoAccountText(),
        ],
      ),
    );
  }
}
