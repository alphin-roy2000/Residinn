import 'dart:math';

import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/codepage.dart';
import 'package:ResidInn/pages/phonenumber.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> sendchangepasswordmail() async {
    print("delete");
    var result = await http_get('changepassword/$wholeuseremail');
    print(result.data['code']);
    if (result.ok) {
      if (result.data['code'] == 200) {
        SnackBar snackBar = SnackBar(
            backgroundColor: Colors.blueAccent,
            behavior: SnackBarBehavior.floating,
            content: Text("Email has been send to change password"));
        _scaffoldKey.currentState.showSnackBar(snackBar);
        print("Chang padsedsfsf");
      }
      print("asfsa");
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  showChangePassword(BuildContext context) {
    return AlertDialog(
      title:
          ListTile(leading: Icon(Icons.lock), title: Text("Change Password")),
      content: Text("Do you want to change your password"),
      actions: <Widget>[
        FlatButton(
          child: Text("Send Mail"),
          onPressed: () async {
            sendchangepasswordmail();
            //Put your code here which you want to execute on Yes button click.
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            //Put your code here which you want to execute on Cancel button click.
            Navigator.of(context).pop();
          },
        ),
      ],
    );
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
    var results = await http_post("updatecode", {"code": codenow});
    if (results.data['code'] == 200) {}
  }

  var _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  textcodeproducer() {
    return getRandomString(8);
  }

  var codeforres = "Wait";
  showChangeCode(BuildContext context) {
    showcode();
    return AlertDialog(
      title: Text("Change Residence code $codeforres"),
      content: Text("Your residence code : $codeforres"),
      actions: <Widget>[
        FlatButton(
          child: Text("Change"),
          onPressed: () async {
            // updatecode();
            setState(() {
              codeforres = "flse";
            });
            //Put your code here which you want to execute on Yes button click.
          },
        ),
        FlatButton(
          child: Text("Continue"),
          onPressed: () {
            //Put your code here which you want to execute on Cancel button click.
            Navigator.of(context).pop();
            print("$codeforres dfsdgsgdg");
          },
        ),
      ],
    );
  }

  bool lockInBackground = true;
  bool notificationsEnabled = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
              color: Colors.orange, fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: SettingsList(
        // backgroundColor: Colors.orange,
        sections: [
          // SettingsSection(
          //   title: 'Admin Privacy',
          //   // titleTextStyle: TextStyle(fontSize: 30),
          //   tiles: [
          //     SettingsTile(
          //       title: 'Change Account privacy',
          //       subtitle: (wholerole == "admin")
          //           ? 'Admin Change'
          //           : 'Change user settings',
          //       leading: Icon(Icons.perm_identity),
          //       onTap: () {
          //         print("sdsdgsdgdsg");
          //       },
          //     ),
          //   ],
          // ),

          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(
                title: 'Change password',
                leading: Icon(Icons.lock),
                onTap: () => showDialog(
                    context: context,
                    builder: (_) {
                      return showChangePassword(context);
                    }),
              ),
              if (wholerole == "user")
                SettingsTile(
                    title: 'Phone number',
                    leading: Icon(Icons.phone),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Phonenumbers();
                          },
                        ),
                      );
                    }),
              if (wholerole == "admin")
                SettingsTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CodeChange();
                          },
                        ),
                      );
                    },
                    title: 'Change Code',
                    leading: Icon(Icons.sort_by_alpha)),
            ],
          ),
          // SettingsSection(
          //   title: 'Security',
          //   tiles: [
          //     SettingsTile.switchTile(
          //       title: 'Lock app in background',
          //       leading: Icon(Icons.phonelink_lock),
          //       switchValue: lockInBackground,
          //       onToggle: (bool value) {
          //         setState(() {
          //           lockInBackground = value;
          //           notificationsEnabled = value;
          //         });
          //       },
          //     ),
          //     SettingsTile.switchTile(
          //         title: 'Use fingerprint',
          //         leading: Icon(Icons.fingerprint),
          //         onToggle: (bool value) {},
          //         switchValue: false),
          //     SettingsTile.switchTile(
          //       title: 'Change password',
          //       leading: Icon(Icons.lock),
          //       switchValue: true,
          //       onToggle: (bool value) {},
          //     ),
          //     SettingsTile.switchTile(
          //       title: 'Enable Notifications',
          //       enabled: notificationsEnabled,
          //       leading: Icon(Icons.notifications_active),
          //       switchValue: true,
          //       onToggle: (value) {},
          //     ),
          //   ],
          // ),
          SettingsSection(
            title: 'Common',
            // titleTextStyle: TextStyle(fontSize: 30),
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onTap: () {
                  SnackBar snackBar = SnackBar(
                      backgroundColor: Colors.blueAccent,
                      behavior: SnackBarBehavior.floating,
                      content: Text("English"));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Misc',
            tiles: [
              SettingsTile(
                  title: 'Terms of Service', leading: Icon(Icons.description)),
              // SettingsTile(
              //     title: 'Open source licenses',
              //     leading: Icon(Icons.collections_bookmark)),
            ],
          ),
          CustomSection(
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 22, bottom: 8),
                //   child: Image.asset(
                //     'assets/icons/settings.svg',
                //     height: 50,
                //     width: 50,
                //     color: Color(0xFF777777),
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'from',
                  style: TextStyle(color: Color(0xFF777777), fontSize: 18),
                ),
                Text(
                  'A.G.J',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'version 1.0.0',
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
