import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:flutter/material.dart';

class Alert extends StatefulWidget {
  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  void initState() {
    super.initState();
    getalertcount();
  }

  var time;
  sendalert(String atitle, String category, TimeOfDay time) async {
    var result = await http_post("sendalert", {
      "alert": atitle,
      "category": category,
      "time": "${time.hour}:${time.minute}",
      "resid": wholeresid,
      "uid": wholeid,
      "role": wholerole
    });
    if (result.ok) {
      if (result.data['code'] == 200) {
        getalertcount();
        title.clear();
        SnackBar snackBar = SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text("Alert has been send"));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  getalertcount() async {
    var result = await http_get(
      "getalertcount/$wholeresid",
    );
    if (result.ok) {
      if (result.data['code'] == 200) {
        print(countal);
        setState(() {
          countal = result.data['count'][0]['count'];
        });
      }
    }
  }

  int countal = 0;
  header() {
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.5, 0.9],
                colors: [
                  Color(0xffE0AFA0),
                  Color(0xffDA2C38),
                  Color(0xffE0AFA0),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Text(
                "Alert",
                style: TextStyle(
                    fontFamily: "Cor",
                    fontSize: 73,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String category = "Other";
  TextEditingController title = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Alert",
            style: TextStyle(
                color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
          ),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            FlatButton.icon(
                color: Colors.blueAccent[100],
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AlertList();
                      },
                    ),
                  );
                  getalertcount();
                },
                icon: countal == 0
                    ? Icon(Icons.dashboard)
                    : Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.redAccent[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: new Text(
                          '$countal',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                label: Text("Alert")),
            FlatButton.icon(
                color: Colors.redAccent,
                onPressed: () {
                  time = TimeOfDay.now();
                  sendalert("There is a Theft", "Burglar", time);
                },
                icon: Icon(Icons.warning),
                label: Text("Quick")),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new TextFormField(
                    controller: title,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "No empty alerts allowed";
                      }
                      return null;
                    },
                    maxLines: 7,
                    decoration: new InputDecoration(
                      hintText: 'Alert Message.............',
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      color: Colors.grey,
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                        dropdownColor: Color(0xff29404E),
                        value: category,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 30,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: new TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            category = newValue;
                          });
                        },
                        items: <String>[
                          if (wholerole == "admin") "Circular",
                          if (wholerole == "admin") "Notice",
                          "Annual",
                          "Burglar",
                          "Other",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          );
                        }).toList(),
                      ))),
                  SizedBox(height: 40),
                  Center(
                    child: Container(
                      color: Color(0xff29404E),
                      height: 60,
                      width: 250,
                      child: OutlineButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            time = TimeOfDay.now();

                            sendalert(title.text, category, time);
                          }
                        },
                        child: Text(
                          'Alert Everyone',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  )
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Padding(
                  //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  //     child: SizedBox(
                  //       width: double.maxFinite,
                  //       height: 60.0,
                  //       child: RaisedButton(
                  //         onPressed: () {
                  //           time = TimeOfDay.now();

                  //           sendalert(title.text, category, time);
                  //         },
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(18.0),
                  //             side: BorderSide(color: Colors.greenAccent)),
                  //         child: const Text('Alert Everyone',
                  //             style: TextStyle(fontSize: 20)),
                  //         color: Colors.red,
                  //         textColor: Colors.white,
                  //         elevation: 5,
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}

class AlertList extends StatefulWidget {
  @override
  _AlertListState createState() => _AlertListState();
}

class _AlertListState extends State<AlertList> {
  void initState() {
    super.initState();
    refreshAlert();
  }

  int mainquery;
  List mainquerylist = [];
  Future<void> refreshAlert() async {
    mainquery = 0;
    var result = await http_get('getalerts/$wholeresid');
    if (result.ok) {
      setState(() {
        print(result.data);
        mainquerylist = result.data['list'];
      });
    }
  }

  Future<void> deleteAlert(String alertid) async {
    mainquery = 0;
    var result = await http_get('delalert/$alertid');
    if (result.ok) {
      if (result.data['code'] == 200) {
        refreshAlert();
        print("alert");
      }
    }
  }

  showAlert(BuildContext context, String message, String alertid) {
    return AlertDialog(
      title: Text("Delete Alert !!"),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              deleteAlert(alertid);
              Navigator.pop(context);
            },
            child: Text("Delete"))
      ],
    );
  }

  // buildGridView() {
  //   if (mainquerylist.isEmpty) {
  //     return Container(
  //       height: 500,
  //       child: Center(child: Text("No Alerts")),
  //     );
  //   }
  //   return ListView.separated(
  //     padding: EdgeInsets.all(0),
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: mainquerylist.length,
  //     itemBuilder: (context, i) => GestureDetector(
  //       onTap: () {},
  //       // Card Which Holds Layout Of ListView Item
  //       child: Card(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: <Widget>[
  //             Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Text(
  //                     "${mainquerylist[i]['message']}",
  //                     style: TextStyle(
  //                       fontSize: 25,
  //                       color: Colors.grey,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Container(
  //                     width: 100,
  //                     child: Text(
  //                       "..........................",
  //                       maxLines: 3,
  //                       style: TextStyle(fontSize: 15, color: Colors.grey[500]),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             if (mainquerylist[i]['userid'] == wholeid)
  //               FlatButton(
  //                 onPressed: () {
  //                   showDialog(
  //                       context: context,
  //                       builder: (_) {
  //                         return showAlert(context, mainquerylist[i]['message'],
  //                             mainquerylist[i]['alertid']);
  //                       });
  //                 },
  //                 child: Icon(Icons.delete),
  //               )
  //           ],
  //         ),
  //       ),
  //     ),
  //     separatorBuilder: (context, i) => Divider(),
  //   );
  // }
  buildGridView() {
    if (mainquerylist.isEmpty) {
      return Container(
        height: 500,
        child: Center(child: Text("No Alerts")),
      );
    }
    return ListView.builder(
      primary: false,
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: mainquerylist.length,
      itemBuilder: (context, i) {
        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
              color: Color(0xff29404E), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16),
                  width: MediaQuery.of(context).size.width - 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${mainquerylist[i]['message']}",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        mainquerylist[i]['usertype'] == "admin"
                            ? "By: The Admin"
                            : "By: ${mainquerylist[i]['housename']}",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.category,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "${mainquerylist[i]['category']}",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
              ),
              if (mainquerylist[i]['userid'] == wholeid)
                FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return showAlert(context, mainquerylist[i]['message'],
                              mainquerylist[i]['alertid']);
                        });
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                )
            ],
          ),
        );
      },
      // separatorBuilder: (context, i) => Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alert from Others"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshAlert,
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[buildGridView()],
          ),
        ),
      ),
    );
  }
}
