import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:ResidInn/pages/complaint.dart';
import 'package:bubble/bubble.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';

class Chatbot extends StatefulWidget {
  Chatbot({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/service.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
    if (aiResponse.getListMessage()[0]["text"]["text"][0].toString() ==
        "How long are you facing this issue") {
      messagewhole = temp1;
    }
    if (aiResponse.getListMessage()[0]["text"]["text"][0].toString() ==
        "Okk noted...U will ne contacted soon") {
      messagewhole = messagewhole + " " + temp1;
      print(messagewhole);
      giveComplaint();
    }
    print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton.icon(
              color: Colors.green[100],
              label: Text("Your Complaints"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ComplaintShow();
                    },
                  ),
                );
              },
              icon: Icon(Icons.add_to_home_screen))
        ],
        title: Text(
          "Chat with admin",
          style: TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Center(
                child: Text(
                  "Today, ${DateFormat("Hm").format(DateTime.now())}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 5.0,
              color: Colors.greenAccent,
            ),
            Container(
              child: ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1),
                  ),
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    maxLines: null,
                    controller: messageInsert,
                    decoration: InputDecoration(
                      hintText: "Enter a Message...",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: (value) {},
                  ),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 30.0,
                      color: Colors.greenAccent,
                    ),
                    onPressed: () {
                      if (messageInsert.text.isEmpty) {
                        print("empty message");
                      } else {
                        setState(() {
                          temp1 = messageInsert.text;
                          messsages.insert(
                              0, {"data": 1, "message": messageInsert.text});
                        });
                        response(messageInsert.text);
                        messageInsert.clear();
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    }),
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  String messagewhole;
  String temp1;
  String temp2;
  giveComplaint() async {
    print("hi");
    var mess;
    var time = DateTime.now().toString();
    var result = await http_post("complaint", {
      "residence_id": wholeresid,
      "userid": wholeid,
      "text": messagewhole,
      "time": time
    });
    if (result.data['code'] == 200) {
      mess = "Complaint registered";
    } else {
      setState(() {
        mess = "Complaint registration with error";
      });
    }
    SnackBar snackBar = SnackBar(
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        content: Text(mess));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  //for better one i have use the bubble package check out the pubspec.yaml
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 35,
                  width: 35,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/robot.jpg"),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Bubble(
                radius: Radius.circular(15.0),
                color: data == 0
                    ? Color.fromRGBO(23, 157, 139, 1)
                    : Colors.orangeAccent,
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                          child: Container(
                        constraints: BoxConstraints(maxWidth: 150),
                        child: Text(
                          message,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          Container(),
        ],
      ),
    );
  }
}
