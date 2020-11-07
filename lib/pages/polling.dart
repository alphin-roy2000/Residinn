import 'package:ResidInn/constants.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PollingAdmin extends StatefulWidget {
  @override
  _PollingAdminState createState() => _PollingAdminState();
}

class _PollingAdminState extends State<PollingAdmin> {
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    getpolllist();
  }

  List polllist = [];
  Future<void> getpolllist() async {
    var result = await http_get("getpolllist/$wholeresid");
    if (result.data['code'] == 200) {
      setState(() {
        polllist = result.data['list'];
        print(polllist);
      });
    }
    setState(() {
      loading = false;
    });
  }

  List polloption = [];
  insertpoll(BuildContext context) async {
    var result = await http_post("insertpoll", {
      "pollname": pollname,
      "polldescription": polldes,
      "lastdate": DateFormat('dd-MM-yyyy').format(pickedDate).toString(),
      "resid": wholeresid
    });
    if (result.data['code'] == 200) {
      getpolllist();
      Navigator.pop(context);
    }
    setState(() {
      loading = false;
    });
  }

  int temp = 0;
  getpolloption(BuildContext context, String pollid, var setState) async {
    var result = await http_get("getpolloption/$pollid");
    print(result.data);
    if (result.data['code'] == 200) {
      setState(() {
        polloption = result.data['list'];
      });

      if (polloption.isEmpty) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
    setState(() {
      dialogbool = false;
    });
  }

  deletepolllist(BuildContext context, String pollid) async {
    var result = await http_get("deletepoll/$pollid");
    if (result.data['code'] == 200) {
      getpolllist();
      Navigator.pop(context);
    }
    setState(() {
      loading = false;
    });
  }

  publishdeactivate(String pollid, int value, String pollname) async {
    var result = await http_post("changepollresult", {
      "result": value,
      "pollid": pollid,
      "resid": wholeresid,
      "pollname": pollname
    });
    if (result.data['code'] == 200) {
      getpolllist();
    }
    setState(() {
      loading = false;
    });
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        PopupMenuItem(
          child: GestureDetector(child: Text("add")),
        ),
        PopupMenuItem(
          child: Text("remove"),
        ),
      ],
      elevation: 8.0,
    );
  }

  bool dialogbool = false;
  buildListView() {
    if (polllist.isEmpty) {
      return Container(
        height: 500,
        child: Center(child: Text("No polls for now")),
      );
    }
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemCount: polllist.length,
        itemBuilder: (context, index) {
          // List polloption = ['asfasf', 'asfasff'];
          // getpolloption1() async {
          //   print("asfsaf");
          //   setState(() {
          //     polloption = ['asfaf', 'asasfasfsa'];
          //   });
          //   // if (result.data['code'] == 200) {
          //   // }
          // }

          // getpolloption1();

          return Stack(children: <Widget>[
            Card(
              color: Colors.blueGrey,
              child: InkWell(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(15.0)),
                            ),
                            title: Text("Do you want to delete this poll: "),
                            content: Container(
                              constraints: BoxConstraints(maxHeight: 100),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "PollName: ${polllist[index]['pollname']}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Container(
                                      color: Color(0xff29404E),
                                      height: 40,
                                      width: 250,
                                      child: OutlineButton(
                                        onPressed: () {
                                          setState(() {
                                            loading = true;
                                          });
                                          deletepolllist(context,
                                              polllist[index]['pollid']);
                                        },
                                        child: Text(
                                          "Delete Poll",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: polllist[index]['result'] != 2
                      ? Container(
                          padding: EdgeInsets.all(20),
                          constraints: BoxConstraints(minHeight: 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("POLL: ${polllist[index]['pollname']}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              Text("${polllist[index]['polldescription']}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                              Text("${polllist[index]['lastdate']}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                              // Container(
                              //   child: ListView.builder(
                              //       shrinkWrap: true,
                              //       itemCount: polloption.length,
                              //       itemBuilder: (context, i) {
                              //         return Text(polloption[i]);
                              //       }),
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                              FlatButton.icon(
                                  onPressed: () async {
                                    temp = 0;
                                    setState(() {
                                      dialogbool = true;
                                    });
                                    calloption(var setState) {
                                      if (temp == 0) {
                                        getpolloption(
                                            context,
                                            polllist[index]['pollid'],
                                            setState);
                                      }
                                      temp++;
                                    }

                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            calloption(setState);
                                            return Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                          new Radius.circular(
                                                              15.0)),
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 30),
                                                  constraints: BoxConstraints(
                                                      maxHeight: 300),
                                                  child: !dialogbool
                                                      ? Column(
                                                          children: <Widget>[
                                                            Text(
                                                              "Preview",
                                                              style: TextStyle(
                                                                  fontSize: 23),
                                                            ),
                                                            Divider(),
                                                            Expanded(
                                                              child: ListView
                                                                  .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount:
                                                                          polloption
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              i) {
                                                                        return Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(bottom: 20),
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.radio_button_checked,
                                                                                color: Colors.green,
                                                                              ),
                                                                              Text("Option ${i + 1}: ${polloption[i]['optionname']}", style: TextStyle(fontSize: 25))
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }),
                                                            )
                                                          ],
                                                        )
                                                      : Container(
                                                          height: 200,
                                                          child: loadingWidget),
                                                ));
                                          });
                                        });
                                  },
                                  icon: Icon(Icons.slideshow),
                                  label: Text(
                                    "Show Option",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              (wholerole == "admin" &&
                                      polllist[index]['result'] != 1)
                                  ? polllist[index]['result'] != 2
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            RaisedButton(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              textColor: Colors.black,
                                              color: Colors.white,
                                              onPressed: () {
                                                insertoption(
                                                    BuildContext context,
                                                    String pollid,
                                                    String option) async {
                                                  var result = await http_post(
                                                      "insertpolloption", {
                                                    "pollid": pollid,
                                                    "option": option
                                                  });
                                                  if (result.data['code'] ==
                                                      200) {
                                                    Navigator.pop(context);
                                                  }
                                                }

                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                        return Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .all(new Radius
                                                                        .circular(
                                                                    15.0)),
                                                          ),
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        20),
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxHeight:
                                                                        200),
                                                            child: ListView(
                                                              children: <
                                                                  Widget>[
                                                                // Text(
                                                                //   allusers[index]['housename'],
                                                                //   style: TextStyle(fontSize: 27),
                                                                // ),
                                                                // SizedBox(
                                                                //   height: 20,
                                                                // ),

                                                                new TextFormField(
                                                                  onChanged:
                                                                      (val) {
                                                                    option1 =
                                                                        val;
                                                                  },
                                                                  decoration:
                                                                      new InputDecoration(
                                                                          labelText:
                                                                              "Option ",
                                                                          fillColor: Colors
                                                                              .white,
                                                                          border:
                                                                              new OutlineInputBorder(),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(0),
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(0),

                                                                            //fillColor: Colors.green
                                                                          ),
                                                                          prefixIcon:
                                                                              Icon(Icons.radio_button_checked)),
                                                                  validator:
                                                                      (val) {},
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  style:
                                                                      new TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                  ),
                                                                ),

                                                                SizedBox(
                                                                  height: 20,
                                                                ),

                                                                Center(
                                                                  child:
                                                                      Container(
                                                                    color: Color(
                                                                        0xff29404E),
                                                                    height: 30,
                                                                    width: 250,
                                                                    child:
                                                                        OutlineButton(
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            "sdsdg");
                                                                        insertoption(
                                                                            context,
                                                                            polllist[index]['pollid'],
                                                                            option1);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "Add Now",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                22,
                                                                            fontWeight:
                                                                                FontWeight.w800),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                    });
                                              },
                                              child: new Text("Add Option"),
                                            ),
                                            // RaisedButton(
                                            //   padding:
                                            //       const EdgeInsets.all(8.0),
                                            //   textColor: Colors.white,
                                            //   color: (polllist[index]
                                            //               ['result'] ==
                                            //           0)
                                            //       ? Colors.green
                                            //       : Colors.red,
                                            //   onPressed: () {
                                            //     if (polllist[index]['result'] ==
                                            //         0)
                                            //       publishdeactivate(
                                            //           polllist[index]['pollid'],
                                            //           1);
                                            //     else {
                                            //       publishdeactivate(
                                            //           polllist[index]['pollid'],
                                            //           0);
                                            //     }
                                            //   },
                                            //   child: (polllist[index]
                                            //               ['result'] ==
                                            //           0)
                                            //       ? new Text("Activate")
                                            //       : Text("Deactivate"),
                                            // ),
                                            // RaisedButton(
                                            //   padding:
                                            //       const EdgeInsets.all(8.0),
                                            //   textColor: Colors.red,
                                            //   color: Colors.yellow,
                                            //   onPressed: () {
                                            //     showDialog(
                                            //         context: context,
                                            //         builder:
                                            //             (BuildContext context) {
                                            //           return AlertDialog(
                                            //             shape:
                                            //                 RoundedRectangleBorder(
                                            //               borderRadius:
                                            //                   new BorderRadius
                                            //                       .all(new Radius
                                            //                           .circular(
                                            //                       15.0)),
                                            //             ),
                                            //             title: Text(
                                            //                 "Do you want to publish the result now?"),
                                            //             actions: <Widget>[
                                            //               FlatButton(
                                            //                 child: Text(
                                            //                     "Publish Now"),
                                            //                 onPressed: () {
                                            //                   publishdeactivate(
                                            //                       polllist[
                                            //                               index]
                                            //                           [
                                            //                           'pollid'],
                                            //                       2);
                                            //                   Navigator.pop(
                                            //                       context);
                                            //                 },
                                            //               ),
                                            //               FlatButton(
                                            //                 child:
                                            //                     Text("Cancel"),
                                            //                 onPressed: () {
                                            //                   Navigator.pop(
                                            //                       context);
                                            //                 },
                                            //               )
                                            //             ],
                                            //           );
                                            //         });
                                            //   },
                                            //   child: new Text("Publish Result"),
                                            // ),
                                          ],
                                        )
                                      : SizedBox(width: double.maxFinite)
                                  : Row(
                                      children: <Widget>[],
                                    )
                            ],
                          ),
                        )
                      : Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.all(20),
                          constraints: BoxConstraints(minHeight: 100),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("POLL: ${polllist[index]['pollname']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                Text("${polllist[index]['polldescription']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                                Text("${polllist[index]['lastdate']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15)),
                                // Container(
                                //   child: ListView.builder(
                                //       shrinkWrap: true,
                                //       itemCount: polloption.length,
                                //       itemBuilder: (context, i) {
                                //         return Text(polloption[i]);
                                //       }),
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                                FlatButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PollListPage(
                                                    pollid: polllist[index]
                                                        ['pollid'],
                                                  )));
                                    },
                                    icon: Icon(Icons.adjust),
                                    label: Text(
                                      "Show Result",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                              ]))),
            ),
            wholerole == "admin"
                ? Positioned(
                    right: 0,
                    child: new PopupMenuButton(
                      onSelected: (value) {
                        if (value == 0) {
                          if (polllist[index]['result'] == 0)
                            publishdeactivate(polllist[index]['pollid'], 1,
                                polllist[index]['pollname']);
                          else {
                            publishdeactivate(polllist[index]['pollid'], 0,
                                polllist[index]['pollname']);
                          }
                        }
                        if (value == 1) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(15.0)),
                                  ),
                                  title: Text(
                                      "Do you want to publish the result now?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Publish Now"),
                                      onPressed: () {
                                        publishdeactivate(
                                            polllist[index]['pollid'],
                                            2,
                                            polllist[index]['pollname']);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                        if (value == 2) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(15.0)),
                                  ),
                                  title:
                                      Text("Do you want to delete this poll: "),
                                  content: Container(
                                    constraints: BoxConstraints(maxHeight: 100),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "PollName: ${polllist[index]['pollname']}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            color: Color(0xff29404E),
                                            height: 40,
                                            width: 250,
                                            child: OutlineButton(
                                              onPressed: () {
                                                setState(() {
                                                  loading = true;
                                                });
                                                deletepolllist(context,
                                                    polllist[index]['pollid']);
                                              },
                                              child: Text(
                                                "Delete Poll",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                      icon: Icon(Icons.arrow_drop_down_circle,
                          size: 35, color: Colors.white),
                      itemBuilder: (_) => <PopupMenuItem<int>>[
                        if (polllist[index]['result'] != 2)
                          new PopupMenuItem<int>(
                              child: (polllist[index]['result'] == 0)
                                  ? new Text(
                                      "Activate",
                                      style: TextStyle(color: Colors.green),
                                    )
                                  : Text(
                                      "Deactivate",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                              value: 0),
                        if (polllist[index]['result'] != 2)
                          new PopupMenuItem<int>(
                              child: const Text(
                                "Publish Result",
                                style: TextStyle(color: Colors.indigo),
                              ),
                              value: 1),
                        new PopupMenuItem<int>(
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                            value: 2),
                      ],
                    ),
                  )
                : SizedBox(),
          ]);
        });
  }

  DateTime pickedDate;
  _pickDate(var setState) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: pickedDate,
    );
    print(date);
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  String option1;
  String option2;
  String pollname;
  String polldes;

  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 5,
          title: Text(
            "Start a Poll",
            style: TextStyle(
                color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(15.0)),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          constraints:
                              BoxConstraints(minHeight: 200, maxHeight: 370),
                          child: ListView(
                            children: <Widget>[
                              // Text(
                              //   allusers[index]['housename'],
                              //   style: TextStyle(fontSize: 27),
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              new TextFormField(
                                onChanged: (val) {
                                  pollname = val;
                                },
                                decoration: new InputDecoration(
                                    labelText: "Poll Name",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),

                                      //fillColor: Colors.green
                                    ),
                                    prefixIcon: Icon(Icons.poll)),
                                validator: (val) {},
                                keyboardType: TextInputType.text,
                                style: new TextStyle(
                                  fontFamily: "Poppins",
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),

                              new TextFormField(
                                onChanged: (val) {
                                  polldes = val;
                                },
                                maxLines: 4,
                                decoration: new InputDecoration(
                                    labelText: "About the Poll",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),

                                      //fillColor: Colors.green
                                    ),
                                    prefixIcon: Icon(Icons.description)),
                                validator: (val) {},
                                keyboardType: TextInputType.text,
                                style: new TextStyle(
                                  fontFamily: "Poppins",
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Text("Options"),
                              // new TextFormField(
                              //   onChanged: (val) {
                              //     option1 = val;
                              //   },
                              //   decoration: new InputDecoration(
                              //       labelText: "Option 1",
                              //       fillColor: Colors.white,
                              //       border: new OutlineInputBorder(),
                              //       focusedBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(0),
                              //       ),
                              //       enabledBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(0),

                              //         //fillColor: Colors.green
                              //       ),
                              //       prefixIcon:
                              //           Icon(Icons.radio_button_checked)),
                              //   validator: (val) {},
                              //   keyboardType: TextInputType.text,
                              //   style: new TextStyle(
                              //     fontFamily: "Poppins",
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              // new TextFormField(
                              //   onChanged: (val) {
                              //     option2 = val;
                              //   },
                              //   decoration: new InputDecoration(
                              //       labelText: "Option 2",
                              //       fillColor: Colors.white,
                              //       border: new OutlineInputBorder(),
                              //       focusedBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(0),
                              //       ),
                              //       enabledBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(0),

                              //         //fillColor: Colors.green
                              //       ),
                              //       prefixIcon:
                              //           Icon(Icons.radio_button_checked)),
                              //   validator: (val) {},
                              //   keyboardType: TextInputType.emailAddress,
                              //   style: new TextStyle(
                              //     fontFamily: "Poppins",
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),

                              OutlineButton(
                                onPressed: () => _pickDate(setState),
                                child: Text(
                                  "Last Date: ${DateFormat('dd-MM-yyyy').format(pickedDate)}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 21),
                                ),
                              ),
                              Center(
                                child: Container(
                                  color: Color(0xff29404E),
                                  height: 60,
                                  width: 250,
                                  child: OutlineButton(
                                    onPressed: () {
                                      setState(() {
                                        loading = true;
                                      });
                                      insertpoll(context);
                                    },
                                    child: Text(
                                      "Create Poll",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
                  });
            }),
        body: RefreshIndicator(
            child: ListView(
              children: <Widget>[
                !loading
                    ? Container(
                        child: buildListView(),
                      )
                    : Container(height: 500, child: loadingWidget)
              ],
            ),
            onRefresh: getpolllist));
  }
}

class PollListPage extends StatefulWidget {
  final String pollid;
  PollListPage({this.pollid});
  @override
  _PollListPageState createState() => _PollListPageState();
}

class _PollListPageState extends State<PollListPage> {
  void initState() {
    super.initState();
    getpolllist();
  }

  Color colorback(int per) {
    var temp = per / total;
    print(temp);
    if (temp == 1) {
      return Colors.green[600];
    } else if (temp > 0.9) {
      return Colors.green[300];
    } else if (temp > 0.8) {
      return Colors.green[100];
    } else if (temp > 0.7) {
      return Colors.orange[300];
    } else if (temp > 0.6) {
      return Colors.orange[600];
    } else if (temp > 0.5) {
      return Colors.orange[900];
    } else if (temp > 0.4) {
      return Colors.redAccent;
    } else if (temp > 0.3) {
      return Colors.red;
    } else if (temp > 0) {
      return Colors.red;
    } else if (temp == 0) {
      return Colors.white;
    }
  }

  designforpercentage(String option, int per, int i) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 25),
      constraints: BoxConstraints(minHeight: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Option $i: $option",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              child: Center(
                child: per != 0
                    ? Text(
                        "${(per / total) * 100}%",
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        "0%",
                        style: TextStyle(color: Colors.black),
                      ),
              ),
              color: colorback(per),
              height: 30,
              width: per == 0
                  ? 20
                  : (per / total) * (MediaQuery.of(context).size.width - 50)),
        ],
      ),
    );
  }

  buildListView() {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: pollresult.length,
        itemBuilder: (context, index) {
          return designforpercentage(pollresult[index]['optionname'],
              pollresult[index]['count'], index + 1);
        });
  }

  var winner = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Result",
            style: TextStyle(
                color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
        body: RefreshIndicator(
            child: Column(
              children: <Widget>[
                Container(
                  child: Text("Final: $winner",
                      style: TextStyle(
                          fontSize: 22,
                          color: winner == "Tie" ? Colors.red : Colors.green)),
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                !loading
                    ? Container(
                        child: Expanded(
                          child: buildListView(),
                        ),
                      )
                    : Container(height: 500, child: loadingWidget)
              ],
            ),
            onRefresh: getpolllist));
  }

  int total = 0;
  List pollresult = [];
  bool loading = true;
  Future<void> getpolllist() async {
    var result = await http_get("getpollresult/${widget.pollid}");
    if (result.data['code'] == 200) {
      setState(() {
        total = result.data['total'];
        winner = result.data['final'];
        pollresult = result.data['list'];
        print(pollresult);
      });
    }
    setState(() {
      loading = false;
    });
  }
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class PollingUser extends StatefulWidget {
  @override
  _PollingUserState createState() => _PollingUserState();
}

class _PollingUserState extends State<PollingUser> {
  bool loading = true;
  Future<void> getpolllist() async {
    var result = await http_get("getpolllistforuser/$wholeresid");
    if (result.data['code'] == 200) {
      setState(() {
        polllist = result.data['list'];
      });
    }
    setState(() {
      loading = false;
    });
  }

  void initState() {
    super.initState();
    getpolllist();
    print("object");
  }

  List polllist = [];
  List option = [];

  buildListView() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemCount: polllist.length,
        itemBuilder: (context, index) {
          return Card(
              color: Colors.blueGrey,
              child: InkWell(
                  child: Container(
                      padding: EdgeInsets.all(20),
                      constraints: BoxConstraints(minHeight: 100),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("POLL: ${polllist[index]['pollname']}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            Text("${polllist[index]['polldescription']}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            Text("${polllist[index]['lastdate']}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            // Container(
                            //   child: ListView.builder(
                            //       shrinkWrap: true,
                            //       itemCount: polloption.length,
                            //       itemBuilder: (context, i) {
                            //         return Text(polloption[i]);
                            //       }),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            polllist[index]['result'] != 2
                                ? FlatButton.icon(
                                    onPressed: () {
                                      int temp = 0;
                                      selectedRadio = 0;
                                      setState(() {
                                        dialogbool = true;
                                      });
                                      calloption(var setState) {
                                        if (temp == 0) {
                                          getpolloption(
                                              context,
                                              polllist[index]['pollid'],
                                              setState);
                                        }
                                        temp++;
                                      }

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              calloption(setState);
                                              return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius.all(
                                                            new Radius.circular(
                                                                15.0)),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 30),
                                                    constraints: BoxConstraints(
                                                        maxHeight: 300),
                                                    child: !dialogbool
                                                        ? Column(
                                                            children: <Widget>[
                                                              Text(
                                                                "Choose",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        23),
                                                              ),
                                                              Divider(),
                                                              Container(
                                                                child: Expanded(
                                                                    child:
                                                                        ListView(
                                                                  // mainAxisSize:
                                                                  //     MainAxisSize
                                                                  //         .min,
                                                                  children: List<
                                                                          Widget>.generate(
                                                                      option
                                                                          .length,
                                                                      (int
                                                                          index) {
                                                                    return ListTile(
                                                                        title: Text(option[index]
                                                                            [
                                                                            'optionname']),
                                                                        leading:
                                                                            Radio<int>(
                                                                          value:
                                                                              index,
                                                                          groupValue:
                                                                              selectedRadio,
                                                                          onChanged:
                                                                              (int value) {
                                                                            setState(() =>
                                                                                selectedRadio = value);
                                                                          },
                                                                        ));
                                                                  }),
                                                                )),
                                                              ),
                                                              Divider(
                                                                height: 0,
                                                              ),
                                                              RaisedButton(
                                                                child: Text(
                                                                    "Vote"),
                                                                onPressed: () {
                                                                  // print(option[
                                                                  //         selectedRadio]
                                                                  //     [
                                                                  //     'polloption']);
                                                                  checkvote(
                                                                      context,
                                                                      polllist[
                                                                              index]
                                                                          [
                                                                          'pollid'],
                                                                      option[selectedRadio]
                                                                          [
                                                                          'polloption']);

                                                                  print(
                                                                      selectedRadio);
                                                                },
                                                              )
                                                            ],
                                                          )
                                                        : Container(
                                                            height: 200,
                                                            child:
                                                                loadingWidget),
                                                  ));
                                            });
                                          });
                                    },
                                    label: Text(
                                      "Vote Now",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    icon: Icon(Icons.thumbs_up_down))
                                : FlatButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PollListPage(
                                                    pollid: polllist[index]
                                                        ['pollid'],
                                                  )));
                                    },
                                    icon: Icon(Icons.adjust),
                                    label: Text(
                                      "Show Result",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                          ]))));
        });
  }

  checkvote(BuildContext context, String pollid, String option) async {
    var result = await http_get("checkvote/$pollid&$option&$wholeid");
    if (result.data['code'] == 200) {
      sendVote(context, option);
    } else {
      Navigator.pop(context);
      SnackBar snackBar = SnackBar(
          duration: const Duration(milliseconds: 800),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text("Already Voted"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  sendVote(BuildContext context, String optionid) async {
    var result = await http_post(
        "insertpollvote", {"userid": wholeid, "optionid": optionid});
    if (result.data['code'] == 200) {
      print("successfully voted");
      SnackBar snackBar = SnackBar(
          duration: const Duration(milliseconds: 800),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Text(" Voted"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  var selectedRadio = 0;
  getpolloption(BuildContext context, var pollid, setState) async {
    var result = await http_get("getpolloption/$pollid");
    print(result.data);
    if (result.data['code'] == 200) {
      setState(() {
        option = result.data['list'];
      });

      if (option.isEmpty) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
    setState(() {
      dialogbool = false;
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool dialogbool = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 5,
          title: Text(
            "Vote",
            style: TextStyle(
                color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
        body: RefreshIndicator(
            child: ListView(
              children: <Widget>[
                !loading
                    ? Container(
                        child: buildListView(),
                      )
                    : Container(height: 500, child: loadingWidget)
              ],
            ),
            onRefresh: getpolllist));
  }
}
