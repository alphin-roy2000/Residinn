import 'package:ResidInn/constants.dart';
import 'package:ResidInn/everyconstants/cons.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:ResidInn/src/pages/call.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

TimeOfDay time;
DateTime pickedDate;
String textfor(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date);
}

class MeetingPage extends StatefulWidget {
  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class Meeting {
  String meetid;
  String time;
  String title;
  String description;
  Meeting(this.meetid, this.time, this.title, this.description);
}

List meets = List();

class _MeetingPageState extends State<MeetingPage> {
  bool meetingpageloading = true;

  @override
  void initState() {
    super.initState();
    refreshUsers();
  }

  Future<void> refreshUsers() async {
    var result = await http_get('getmeet/$wholeresid');
    if (result.ok) {
      setState(() {
        meetforpage.clear();
        meetforpage = result.data;
        print(meetforpage);
      });
    }
    setState(() {
      meetingpageloading = false;
    });
  }

  Future<void> deletemeet(String meetid) async {
    print("delete");
    var result = await http_get('delmeet/$meetid');
    if (result.ok) {
      if (result.data['code'] == 200) {
        await refreshUsers();
      }
    }
    setState(() {
      meetingpageloading = false;
    });
  }

  showAlert(BuildContext context, var meet) {
    return AlertDialog(
      title: Text("Delete Meet: ${meet['title']}"),
      content: Text("Do you want to delete the current meet"),
      actions: <Widget>[
        FlatButton(
          child: Text("Delete"),
          onPressed: () async {
            setState(() {
              meetingpageloading = true;
            });
            deletemeet(meet['meetid']);

            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meetings",
          style: TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButton: (wholerole == "admin")
          ? FloatingActionButton(
              child: Icon(Icons.video_call),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateMeet();
                    },
                  ),
                );
                refreshUsers();
              })
          : SizedBox(
              height: 0,
            ),
      body: RefreshIndicator(
          child: (meetingpageloading == false)
              ? Container(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: <Widget>[
                      buildGridView(),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                )
              : loadingWidget,
          onRefresh: refreshUsers),
    );
  }

  String title;
  var meetlist;
  createmeet() async {
    var result = await http_post("createmeet",
        {"resid": wholeresid, "time": '2020-09-27', "title": title});
    print(result.data['code']);
    if (result.data['code'] == 200) {
      setState(() {
        // meetlist.clear();
        meetlist = result.data['rows'];
        print(meetlist);
        meets.add(meetlist);
        // mainuserlist = users;
      });
    }
    Navigator.of(context).pop();
  }

  addmeetdialog(BuildContext context) {
    DateTime pickedDate;
    _pickDate() async {
      DateTime date = await showDatePicker(
        context: context,
        firstDate: pickedDate,
        lastDate: DateTime(DateTime.now().year + 5),
        initialDate: DateTime.now(),
      );
      print(date);
      if (date != null)
        setState(() {
          pickedDate = date;
        });
    }

    TimeOfDay time;
    _pickTime() async {
      TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: time,
      );
      if (t != null)
        setState(() {
          time = t;
        });
    }

    time = TimeOfDay.now();
    pickedDate = DateTime.now();
    return AlertDialog(
      title: Text('Create Meeting'),
      content: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              decoration: InputDecoration(hintText: 'Meet name'),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.green,
              child: Text(
                'Select date: ${pickedDate.toString()}',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () async {
                print(time);
                _pickDate();
              },
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.green,
              child: Text('Select time: ${time.format(context)}'),
              onPressed: () async {
                time = TimeOfDay.now();

                print(time);
                _pickTime();
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Create"),
          onPressed: () async {
            await createmeet();
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

  DateTime selectdate = DateTime.now();

  // showAlert(BuildContext context) {
  //   // time = TimeOfDay.now();
  //   // pickedDate = DateTime.now();
  //   // showDialog(
  //   //   context: context,
  //   //   builder: (BuildContext context) {
  //   //     return StatefulBuilder(builder: (context, setState) {
  //   //       return
  //   //     });
  //   //   },
  //   // );
  // }
  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  meetingTile(
      {var meetforpage,
      String address,
      String date,
      String desc,
      String description}) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Color(0xff29404E), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              width: MediaQuery.of(context).size.width - 100,
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        desc,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/calender.png",
                            height: 12,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            date,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            address,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  FlatButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Container(
                                    width: 300.0,
                                    height: 400,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: const Color(0xFFFFFF),
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(32.0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          // dialog top

                                          new Container(
                                            // padding: new EdgeInsets.all(10.0),
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: new Text(
                                              'Meet : ${meetforpage['title']}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25.0,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          // dialog centre
                                          new Expanded(
                                            child: new Container(
                                                child: ListView(
                                              children: <Widget>[
                                                Text(
                                                  "Description:  ${meetforpage['description']}",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ],
                                            )),
                                            flex: 2,
                                          ),

                                          // dialog bottom
                                          Container(
                                            padding: new EdgeInsets.all(16.0),
                                            decoration: new BoxDecoration(
                                              color: const Color(0xFF33b17c),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: new Text(
                                                'Continue',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  // title: Text("Description"),
                                  // content:
                                  //     Text("${meetforpage['description']}"),
                                  );
                            });
                      },
                      child: Text(
                        "About",
                        style: TextStyle(color: Colors.white),
                      )),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        color: Colors.green,
                        onPressed: () {
                          onJoin(meetforpage['meetid']);
                        },
                        child: new Text("Join"),
                      ),
                      if (wholerole == "admin")
                        RaisedButton(
                          padding: EdgeInsets.all(0),
                          textColor: Colors.white,
                          color: Colors.redAccent,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return showAlert(context, meetforpage);
                                });

                            // deletemeet(meetforpage[i]['meetid']);
                          },
                          child: Text("Delete"),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
          // ClipRRect(
          //     borderRadius: BorderRadius.only(
          //         topRight: Radius.circular(8),
          //         bottomRight: Radius.circular(8)),
          //     child: Image.asset(
          //       imgeAssetPath,
          //       height: 100,
          //       width: 120,
          //       fit: BoxFit.cover,
          //     )),
        ],
      ),
    );
  }

  buildGridView() {
    if (meetforpage.length == 0)
      return Container(height: 500, child: Center(child: Text("No meetings")));
    return ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemCount: meetforpage.length,
        itemBuilder: (context, i) => meetingTile(
            meetforpage: meetforpage[i],
            address: TimeOfDay(
                    hour: int.parse(meetforpage[i]['time'].split(":")[0]),
                    minute: int.parse(
                        meetforpage[i]['time'].split(":")[1].split(" ")[0]))
                .format(context),
            desc: meetforpage[i]['title'],
            date: DateFormat('dd-MM-yyyy').format(
              DateTime.parse(meetforpage[i]['date']),
            )
            //  GestureDetector(
            //       onTap: () {
            //         // print(mainquery);
            //       },
            //       child: Container(
            //         margin:
            //             EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(10),
            //           boxShadow: [
            //             BoxShadow(
            //               offset: Offset(0, 4),
            //               blurRadius: 20,
            //               color: Color(0xFFB0CCE1).withOpacity(0.32),
            //             ),
            //           ],
            //         ),
            //         child: Material(
            //             color: Colors.transparent,
            //             child: Container(
            //               height: 175,
            //               child: Padding(
            //                 padding: const EdgeInsets.all(10.0),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                   children: <Widget>[
            //                     Column(
            //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: <Widget>[
            //                         Text(
            //                           "${meetforpage[i]['title']}",
            //                           style: TextStyle(fontSize: 20),
            //                         ),
            //                         Text(
            //                           "Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(meetforpage[i]['date']))}",
            //                           style: TextStyle(
            //                             fontSize: 21,
            //                             color: Colors.indigoAccent,
            //                             fontFamily: "Cor",
            //                           ),
            //                         ),
            //                         Text(
            //                           "Time: ${TimeOfDay(hour: int.parse(meetforpage[i]['time'].split(":")[0]), minute: int.parse(meetforpage[i]['time'].split(":")[1].split(" ")[0])).format(context)}",
            //                           style: TextStyle(
            //                             fontSize: 21,
            //                             color: Colors.indigoAccent,
            //                             fontFamily: "Cor",
            //                           ),
            //                         ),
            //                         FlatButton(
            //                             onPressed: () {
            //                               showDialog(
            //                                   context: context,
            //                                   builder: (_) {
            //                                     return AlertDialog(
            //                                       title: Text("Description"),
            //                                       content: Text(
            //                                           "${meetforpage[i]['description']}"),
            //                                     );
            //                                   });
            //                             },
            //                             child: Text("About"))
            //                       ],
            //                     ),
            //                     Column(
            //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: <Widget>[
            //                         RaisedButton(
            //                           padding: const EdgeInsets.all(8.0),
            //                           textColor: Colors.white,
            //                           color: Colors.green,
            //                           onPressed: () {
            //                             onJoin(meetforpage[i]['meetid']);
            //                           },
            //                           child: new Text("Join"),
            //                         ),
            //                         if (wholerole == "admin")
            //                           RaisedButton(
            //                             padding: EdgeInsets.all(0),
            //                             textColor: Colors.white,
            //                             color: Colors.redAccent,
            //                             onPressed: () {
            //                               showDialog(
            //                                   context: context,
            //                                   builder: (_) {
            //                                     return showAlert(
            //                                         context, meetforpage[i]);
            //                                   });

            //                               // deletemeet(meetforpage[i]['meetid']);
            //                             },
            //                             child: Text("Delete"),
            //                           )
            //                       ],
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             )),
            //       ),
            //     )

            // separatorBuilder: (context, i) => Divider(),
            ));
  }

  ClientRole _role = ClientRole.Broadcaster;
  Future<void> onJoin(String channelmeetid) async {
    // update input validation
    // setState(() {
    //   _channelController.text.isEmpty
    //       ? _validateError = true
    //       : _validateError = false;
    // });
    if (channelmeetid != null) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      // push video page with given channel name
      if (wholerole == "admin") {
        _role = ClientRole.Broadcaster;
      } else {
        _role = ClientRole.Audience;
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channelmeetid,
            role: _role,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}

class CreateMeet extends StatefulWidget {
  @override
  _CreateMeetState createState() => _CreateMeetState();
}

class _CreateMeetState extends State<CreateMeet> {
  @override
  void initState() {
    super.initState();
    time = TimeOfDay.now();
    pickedDate = DateTime.now();
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    print(date);
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  TimeOfDay time;
  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (t != null)
      setState(() {
        time = t;
      });
  }

  createmeet() async {
    var result = await http_post("createmeet", {
      "resid": wholeresid,
      "date": DateFormat('yyyy-MM-dd').format(pickedDate).toString(),
      "time": "${time.hour}:${time.minute}:00",
      "title": title,
      "description": description
    });
    print(result.data['code']);
    if (result.data['code'] == 200) {
      Navigator.of(context).pop();
    }
  }

  String description;
  String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Meet"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              children: <Widget>[
                new TextFormField(
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.people),
                    // labelText: "Description",
                    hintText: 'Meet name',
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),

                      //fillColor: Colors.green
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
                SizedBox(height: 30),
                OutlineButton(
                  onPressed: () => _pickDate(),
                  child: Text(
                    "Date: ${textfor(pickedDate)}",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 21),
                  ),
                ),
                SizedBox(height: 30),
                OutlineButton(
                  onPressed: () => _pickTime(),
                  child: Text(
                    "Select Time :${time.format(context)}",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 21),
                  ),
                ),
                // SizedBox(height: 30),
                // TextFormField(
                //   maxLines: 10,
                //   onChanged: (value) {
                //     setState(() {
                //       description = value;
                //     });
                //   },
                //   decoration: InputDecoration(
                //       hintText: 'Meet Description.......................'),
                // ),
                SizedBox(height: 30),
                new TextFormField(
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  maxLines: 7,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    // labelText: "Description",
                    hintText: 'Meet Description.......................',
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
                Container(
                  color: Color(0xff29404E),
                  height: 60,
                  width: 250,
                  child: OutlineButton(
                    onPressed: () {
                      createmeet();
                    },
                    child: Text(
                      "Create Meet",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String datetime;
}

class MeetingTile extends StatelessWidget {
  String desc;
  String date;
  String address;
  String description;
  MeetingTile({this.address, this.date, this.desc, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Color(0xff29404E), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              width: MediaQuery.of(context).size.width - 100,
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        desc,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/calender.png",
                            height: 12,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            date,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            address,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        color: Colors.green,
                        onPressed: () {
                          // onJoin(meetforpage[i]['meetid']);
                        },
                        child: new Text("Join"),
                      ),
                      if (wholerole == "admin")
                        RaisedButton(
                          padding: EdgeInsets.all(0),
                          textColor: Colors.white,
                          color: Colors.redAccent,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  // return showAlert(context, meetforpage[i]);
                                });

                            // deletemeet(meetforpage[i]['meetid']);
                          },
                          child: Text("Delete"),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
          // ClipRRect(
          //     borderRadius: BorderRadius.only(
          //         topRight: Radius.circular(8),
          //         bottomRight: Radius.circular(8)),
          //     child: Image.asset(
          //       imgeAssetPath,
          //       height: 100,
          //       width: 120,
          //       fit: BoxFit.cover,
          //     )),
        ],
      ),
    );
  }
}

class ChangeTime extends StatefulWidget {
  @override
  _ChangeTimeState createState() => _ChangeTimeState();
}

class _ChangeTimeState extends State<ChangeTime> {
  @override
  void initState() {
    super.initState();
    time = TimeOfDay.now();
    pickedDate = DateTime.now();
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: pickedDate,
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    print(date);
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  TimeOfDay time;
  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (t != null)
      setState(() {
        time = t;
      });
  }

  var meetlist;

  createmeet() async {
    var result = await http_post("createmeet",
        {"resid": wholeresid, "time": '2020-09-27', "title": title});
    print(result.data['code']);
    if (result.data['code'] == 200) {
      setState(() {
        // meetlist.clear();
        meetlist = result.data['rows'];
        print(meetlist);
        meets.add(meetlist);
        // mainuserlist = users;
      });
    }
    Navigator.of(context).pop();
  }

  String title;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Meeting'),
      content: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              decoration: InputDecoration(hintText: 'Meet name'),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.green,
              child: Text('Select date: ${textfor(pickedDate)}'),
              onPressed: () async {
                print(time);
                _pickDate();
              },
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.green,
              child: Text('Select time: ${time.format(context)}'),
              onPressed: () async {
                time = TimeOfDay.now();

                print(time);
                _pickTime();
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Create"),
          onPressed: () async {
            await createmeet();
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
}

// class ChangeDate extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
