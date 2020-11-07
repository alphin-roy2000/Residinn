import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CodeChange extends StatefulWidget {
  @override
  _CodeChangeState createState() => _CodeChangeState();
}

class _CodeChangeState extends State<CodeChange> {
  void initState() {
    super.initState();
    showcode();
  }

  showcode() async {
    // if (_formKey.currentState.validate()) {
    // _formKey.currentState.save();
    print("hello inece");

    var result = await http_get("showcodeforresidence/$wholeresid");
    setState(() {
      if (result.data['code'] == 200) {
        codeforres = result.data['codegen'];
        print(codeforres);
      } else {
        codeforres = "Server problem";
      }
    });
    // showChangeCode(code: code);
  }

  updatecode() async {
    var codenow = textcodeproducer();
    var results =
        await http_post("updatecode", {"code": codenow, "resid": wholeresid});
    if (results.data['code'] == 200) {
      showcode();
    }
  }

  var _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  textcodeproducer() {
    return getRandomString(8);
  }

  var codeforres = "Wait.................";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$codeforres"),
        ),
        body: Container(
            child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Text(
                "$codeforres",
                style: TextStyle(fontSize: 40),
              ),
              RaisedButton(
                onPressed: () {
                  updatecode();
                },
                child: Text("Update Code"),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        )));
  }
}
