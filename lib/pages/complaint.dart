import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintSec extends StatefulWidget {
  final String id;
  ComplaintSec({this.id});
  @override
  _ComplaintSecState createState() => _ComplaintSecState();
}

class _ComplaintSecState extends State<ComplaintSec> {
  void initState() {
    super.initState();
    getStart();
    print("hello");
  }

  getStart() {
    if (widget.id == null)
      getcomplaints();
    else
      getcomplaintsaid();
  }

  Future<void> getcomplaintsaid() async {
    print("object");
    var result = await http_get("getcomplaintadminbyid/${widget.id}");
    setState(() {
      complaintList = result.data['list'];
    });
  }

  List complaintList = [];
  // buildGridView() {
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       physics: NeverScrollableScrollPhysics(),
  //       itemCount: complaintList.length,
  //       itemBuilder: (context, i) {
  //         String temp1 = "Waiting...";
  //         Color temp;
  //         if (complaintList[i]['verify'] == 0) {
  //           temp1 = "Complaint was not Noted";
  //           temp = Colors.redAccent;
  //         } else {
  //           temp1 = "Complaint was registered";
  //           temp = Colors.green;
  //         }

  //         return GestureDetector(
  //           onTap: () {
  //             // print(mainquery);
  //           },
  //           child: Container(
  //             padding: EdgeInsets.only(bottom: 20, top: 20),
  //             margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(10),
  //               boxShadow: [
  //                 BoxShadow(
  //                   offset: Offset(0, 4),
  //                   blurRadius: 20,
  //                   color: Color(0xFFB0CCE1).withOpacity(0.32),
  //                 ),
  //               ],
  //             ),
  //             child: Material(
  //                 color: Colors.transparent,
  //                 child: Container(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(10.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: <Widget>[
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           children: <Widget>[
  //                             Container(
  //                               width: MediaQuery.of(context).size.width / 2,
  //                               child: Text(
  //                                 "Issue: ${complaintList[i]['comp_text']}",
  //                                 style: TextStyle(fontSize: 20),
  //                               ),
  //                             ),
  //                             Text(
  //                               "Action: $temp1",
  //                               style: TextStyle(
  //                                 fontSize: 21,
  //                                 color: temp,
  //                                 fontFamily: "Cor",
  //                               ),
  //                             ),
  //                             Text(
  //                               "By : ${complaintList[i]['housename']}",
  //                               style: TextStyle(
  //                                 color: Colors.indigoAccent,
  //                                 fontSize: 21,
  //                                 fontFamily: "Cor",
  //                               ),
  //                             ),
  //                             Text(
  //                               "Registration: ${DateFormat('dd-mm-yyyy').format(DateTime.parse(complaintList[i]['time']))}",
  //                               style: TextStyle(
  //                                 fontSize: 21,
  //                                 color: Colors.indigoAccent,
  //                                 fontFamily: "Cor",
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           children: <Widget>[
  //                             IconButton(
  //                               icon: complaintList[i]['verify'] == 0
  //                                   ? Icon(Icons.check)
  //                                   : Icon(Icons.close),
  //                               onPressed: () async {
  //                                 verify(complaintList[i]['complaint_id'],
  //                                     complaintList[i]['verify']);
  //                                 // delete(complaintList[i]['complaint_id']);
  //                               },
  //                             )
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 )),
  //           ),
  //         );
  //       }
  //       // separatorBuilder: (context, i) => Divider(),
  //       );
  // }
  bool loading = false;
  showAlert(BuildContext context, var complaint) {
    return AlertDialog(
      title: Container(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Container(
              width: 200,
              child: Text(
                "Delete Issue: ${complaint['comp_text']}",
              ),
            )
          ],
        ),
      ),
      content: Text("Do you want to delete the current complaint"),
      actions: <Widget>[
        FlatButton(
          child: Text("Delete"),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            delete(complaint['complaint_id']);

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

  buildGridView() {
    if (complaintList.isEmpty) {
      return Container(
        height: 500,
        child: Center(
          child: Text("No Complaints registered"),
        ),
      );
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: complaintList.length,
        itemBuilder: (context, i) {
          String temp1 = "Waiting...";
          Color temp;
          if (complaintList[i]['verify'] == 0) {
            temp1 = "Complaint was not Noted";
            temp = Colors.redAccent;
          } else {
            temp1 = "Complaint was registered";
            temp = Colors.green;
          }
          return InkWell(
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return showAlert(context, complaintList[i]);
                  });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  color: Color(0xff29404E),
                  borderRadius: BorderRadius.circular(0)),
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
                            "Issue: ${complaintList[i]['comp_text']}",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: <Widget>[
                              Image.asset(
                                "assets/calender.png",
                                height: 15,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Action: $temp1",
                                style: TextStyle(color: temp, fontSize: 18),
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
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Registration: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(complaintList[i]['time']))}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.home,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "By : ${complaintList[i]['housename']}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: complaintList[i]['verify'] == 0
                            ? Icon(Icons.check)
                            : Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () async {
                          verify(
                            complaintList[i]['complaint_id'],
                            complaintList[i]['verify'],
                            complaintList[i]['residence_id'],
                            complaintList[i]['userid'],
                          );
                          // delete(complaintList[i]['complaint_id']);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  delete(String complaint) async {
    var result = await http_get("deletecomplaintuser/$complaint");
    if (result.data['code'] == 200) {
      getStart();
    }
  }

  verify(String id, int verify, String user, String from) async {
    if (verify == 0) {
      verify = 1;
    } else {
      verify = 0;
    }
    print("user$user");
    var result = await http_get("verifycomplaint/$id&$verify&$user&$from");
    if (result.data['code'] == 200) {
      if (widget.id == null)
        getcomplaints();
      else
        getcomplaintsaid();
    }
  }

  Future<void> getcomplaints() async {
    print("object");
    var result = await http_get("getcomplaintadmin/$wholeresid");
    setState(() {
      complaintList = result.data['list'];
    });
    print(complaintList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Complaints Registered",
            style: TextStyle(
                color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
        body: RefreshIndicator(
            child: ListView(
              children: <Widget>[
                Container(
                  child: buildGridView(),
                )
              ],
            ),
            onRefresh: (widget.id == null) ? getcomplaints : getcomplaintsaid));
  }
}

class ComplaintShow extends StatefulWidget {
  @override
  _ComplaintShowState createState() => _ComplaintShowState();
}

class _ComplaintShowState extends State<ComplaintShow> {
  void initState() {
    super.initState();
    refreshpage();
  }

  List complaintList = [];
  buildGridView() {
    if (complaintList.isEmpty) {
      return Container(
        height: 500,
        child: Center(
          child: Text("No complaints"),
        ),
      );
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: complaintList.length,
        itemBuilder: (context, i) {
          String temp1 = "Waiting...";
          Color temp;
          if (complaintList[i]['verify'] == 0) {
            temp1 = "Action not Taken";
            temp = Colors.redAccent;
          } else {
            temp1 = "Your complaint was Noted";
            temp = Colors.greenAccent;
          }
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                color: Color(0xff29404E),
                borderRadius: BorderRadius.circular(0)),
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
                          "Issue: ${complaintList[i]['comp_text']}",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/calender.png",
                              height: 15,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Action: $temp1",
                              style: TextStyle(color: temp, fontSize: 18),
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
                              size: 18,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Registration: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(complaintList[i]['time']))}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return showAlert(context, complaintList[i]);
                            });
                        // delete(complaintList[i]['complaint_id']);
                      },
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  bool loading = false;
  showAlert(BuildContext context, var complaint) {
    return AlertDialog(
      title: Text("Delete ${complaint['comp_text']}"),
      content: Text("Do you want to delete the current complaint"),
      actions: <Widget>[
        FlatButton(
          child: Text("Delete"),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            delete(complaint['complaint_id']);

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
  // buildGridView() {
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       physics: NeverScrollableScrollPhysics(),
  //       itemCount: complaintList.length,
  //       itemBuilder: (context, i) {
  //         String temp1 = "Waiting...";
  //         Color temp;
  //         if (complaintList[i]['verify'] == 0) {
  //           temp1 = "Action not Taken";
  //           temp = Colors.redAccent;
  //         } else {
  //           temp1 = "Your complaint was Noted";
  //           temp = Colors.greenAccent;
  //         }

  //         return GestureDetector(
  //           onTap: () {
  //             // print(mainquery);
  //           },
  //           child: Container(
  //             padding: EdgeInsets.only(bottom: 20, top: 20),
  //             margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(10),
  //               boxShadow: [
  //                 BoxShadow(
  //                   offset: Offset(0, 4),
  //                   blurRadius: 20,
  //                   color: Color(0xFFB0CCE1).withOpacity(0.32),
  //                 ),
  //               ],
  //             ),
  //             child: Material(
  //                 color: Colors.transparent,
  //                 child: Container(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(10.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: <Widget>[
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           children: <Widget>[
  //                             Container(
  //                               width: MediaQuery.of(context).size.width / 2,
  //                               child: Text(
  //                                 "Issue: ${complaintList[i]['comp_text']}",
  //                                 style: TextStyle(fontSize: 20),
  //                               ),
  //                             ),
  //                             Text(
  //                               "Action: $temp1",
  //                               style: TextStyle(
  //                                 fontSize: 21,
  //                                 color: temp,
  //                                 fontFamily: "Cor",
  //                               ),
  //                             ),
  //                             Text(
  //                               "Registration: ${DateFormat('dd-mm-yyyy').format(DateTime.parse(complaintList[i]['time']))}",
  //                               style: TextStyle(
  //                                 fontSize: 21,
  //                                 color: Colors.indigoAccent,
  //                                 fontFamily: "Cor",
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           children: <Widget>[
  //                             IconButton(
  //                               icon: Icon(Icons.delete),
  //                               onPressed: () async {
  //                                 delete(complaintList[i]['complaint_id']);
  //                               },
  //                             )
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 )),
  //           ),
  //         );
  //       }
  //       // separatorBuilder: (context, i) => Divider(),
  //       );
  // }

  delete(String complaint) async {
    var result = await http_get("deletecomplaintuser/$complaint");
    if (result.data['code'] == 200) {
      refreshpage();
    }
  }

  Future<void> refreshpage() async {
    var result = await http_get("getcomplaintuser/$wholeid");
    setState(() {
      complaintList = result.data['list'];
    });
    print(complaintList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Complaints"),
      ),
      body: RefreshIndicator(
          onRefresh: refreshpage,
          child: ListView(
            children: <Widget>[
              Container(
                child: buildGridView(),
              ),
            ],
          )),
    );
  }
}

// class ComplaintTile extends StatelessWidget {
//   String user;
//   String date;
//   String issue;
//   String time;

//   /// later can be changed with imgUrl
//   ComplaintTile({this.issue, this.date, this.user, this.time});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 150,
//       margin: EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//           color: Color(0xff29404E), borderRadius: BorderRadius.circular(8)),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.only(left: 16),
//               width: MediaQuery.of(context).size.width - 100,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     desc,
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Image.asset(
//                         "assets/calender.png",
//                         height: 15,
//                       ),
//                       SizedBox(
//                         width: 8,
//                       ),
//                       Text(
//                         DateFormat('dd-MM-yyyy').format(DateTime.parse(date)),
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Icon(
//                         Icons.timer,
//                         size: 18,
//                         color: Colors.white,
//                       ),
//                       SizedBox(
//                         width: 8,
//                       ),
//                       Text(
//                         TimeOfDay(
//                                 hour: int.parse(time.split(":")[0]),
//                                 minute: int.parse(time.split(":")[1]))
//                             .format(context),
//                         style: TextStyle(color: Colors.white, fontSize: 15),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Image.asset(
//                         "assets/location.png",
//                         height: 15,
//                       ),
//                       SizedBox(
//                         width: 8,
//                       ),
//                       Text(
//                         address,
//                         style: TextStyle(color: Colors.white, fontSize: 15),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
