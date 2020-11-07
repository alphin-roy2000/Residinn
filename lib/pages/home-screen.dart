import 'package:ResidInn/chat/chat.dart';
import 'package:ResidInn/chat/chatroom.dart';
import 'package:ResidInn/chatbot/chabot.dart';
import 'package:ResidInn/constants.dart';
import 'package:ResidInn/everyconstants/cons.dart';
import 'package:ResidInn/home.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/alertpage.dart';
import 'package:ResidInn/pages/billreminder.dart';
import 'package:ResidInn/pages/event.dart';
import 'package:ResidInn/pages/complaint.dart';
import 'package:ResidInn/pages/directory.dart';
import 'package:ResidInn/pages/eventgallery1.dart';
import 'package:ResidInn/pages/meeting.dart';
import 'package:ResidInn/pages/profilepage.dart';
import 'package:ResidInn/pages/settings.dart';
import 'package:ResidInn/pages/sign_in_screen.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'polling.dart';
import 'package:ResidInn/pages/test.dart';

import 'package:ResidInn/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class NotificationPage extends StatefulWidget {
//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   void initState() {
//     print(notcounter);
//     setState(() {
//       notcounter = 0;
//     });
//     // refreshUsers();
//     print("dhgdhfd");
//     super.initState();
//   }

//   buildGridView() {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: 6,
//       itemBuilder: (context, i) => GestureDetector(
//         onTap: () {},
//         child: ListTile(
//           leading: Icon(Icons.person),
//           title: Text("data"),
//         ),
//       ),
//       separatorBuilder: (context, i) => Divider(),
//     );
//   }

//   // List<User> users = [];
//   // List<User> mainuserlist = [];
//   Future<void> refreshUsers() async {
//     setState(() {
//       notcounter = 0;
//     });
//     print(notcounter);
//     // mainquery = 0;
//     // textEditingController.clear();
//     // var result = await http_get('getdirectory/$wholeresid');
//     // if (result.ok) {
//     //   setState(() {
//     //     users.clear();
//     //     var in_users = result.data as List<dynamic>;
//     //     in_users.forEach((in_user) {
//     //       users.add(User(in_user['id'].toString(), in_user['housename']));
//     //     });
//     //     mainuserlist = users;
//     //   });
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Notification"),
//       ),
//       body: RefreshIndicator(
//           onRefresh: refreshUsers,
//           child: ListView(
//             children: <Widget>[
//               Container(
//                 child: buildGridView(),
//               ),
//               // ListView.separated(
//               //   itemCount: users.length,
//               //   itemBuilder: (context, i) => ListTile(
//               //     leading: Icon(Icons.person),
//               //     title: Text(users[i].name),
//               //   ),
//               //   separatorBuilder: (context, i) => Divider(),
//               // ),
//             ],
//           )),
//     );
//   }
// }
class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  void initState() {
    print(notcounter);
    setState(() {
      notcounter = 0;
    });
    // refreshUsers();
    refreshnot();
    print("dhgdhfd");
    super.initState();
  }

  bool loading = false;

  showdeletealert(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Icon(
            Icons.warning,
            color: Colors.red,
          ),
          Text("Clear old notification"),
        ],
      ),
      content: Text("Notification older than 2 days before will be deleted"),
      actions: <Widget>[
        FlatButton(
          child: Text("Delete"),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            deleteoldnot();

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
    if (notificationList.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Text("No Notification"),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: notificationList.length,
      itemBuilder: (context, i) {
        if (notificationList[i]['type'] == "chat") {
          return InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.person),
              trailing: notificationList[i]['look'] == 0
                  ? Icon(
                      Icons.new_releases,
                      color: Colors.red,
                    )
                  : SizedBox(),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Text("Chat"), Text("data")],
              ),
            ),
          );
        }
        if (notificationList[i]['type'] == "meet") {
          return InkWell(
            onTap: () async {
              changenotlook(notificationList[i]['notid']);
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MeetingPage()));
              refreshnot();
            },
            child: Container(
              constraints: BoxConstraints(
                minHeight: 80,
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.assignment_ind,
                    size: 30,
                    color: Colors.green[200],
                  ),
                  trailing: notificationList[i]['look'] == 0
                      ? Icon(
                          Icons.new_releases,
                          color: Colors.red,
                        )
                      : SizedBox(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text(notificationList[i]['text'])],
                  ),
                ),
              ),
            ),
          );
        }
        if (notificationList[i]['type'] == "alert") {
          return InkWell(
            onTap: () async {
              print(notificationList[i]['time']);
              changenotlook(notificationList[i]['notid']);
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AlertList()));
              refreshnot();
            },
            child: Container(
              constraints: BoxConstraints(
                minHeight: 80,
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.announcement,
                    size: 30,
                    color: Colors.redAccent[100],
                  ),
                  trailing: notificationList[i]['look'] == 0
                      ? Icon(
                          Icons.new_releases,
                          color: Colors.red,
                        )
                      : SizedBox(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text(notificationList[i]['text'])],
                  ),
                ),
              ),
            ),
          );
        }
        if (notificationList[i]['type'] == "event") {
          return InkWell(
            onTap: () async {
              changenotlook(notificationList[i]['notid']);
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScheduleList()));
              refreshnot();
            },
            child: Container(
              constraints: BoxConstraints(
                minHeight: 80,
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.event_note,
                    size: 30,
                    color: Colors.orangeAccent[100],
                  ),
                  trailing: notificationList[i]['look'] == 0
                      ? Icon(
                          Icons.new_releases,
                          color: Colors.red,
                        )
                      : SizedBox(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text(notificationList[i]['text'])],
                  ),
                ),
              ),
            ),
          );
        }
        if (notificationList[i]['type'] == "new user") {
          return InkWell(
            onTap: () async {
              changenotlook(notificationList[i]['notid']);
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Directory()));
              refreshnot();
            },
            child: Container(
              constraints: BoxConstraints(
                minHeight: 80,
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.supervised_user_circle,
                    size: 30,
                    color: Colors.greenAccent[100],
                  ),
                  trailing: notificationList[i]['look'] == 0
                      ? Icon(
                          Icons.new_releases,
                          color: Colors.red,
                        )
                      : SizedBox(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text(notificationList[i]['text'])],
                  ),
                ),
              ),
            ),
          );
        }
        if (notificationList[i]['type'] == "complaint") {
          return InkWell(
            onTap: () async {
              changenotlook(notificationList[i]['notid']);
              wholerole == "admin"
                  ? await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ComplaintSec(
                                id: notificationList[i]['fromid'],
                              )))
                  : await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ComplaintShow()));
              refreshnot();
            },
            child: Container(
              constraints: BoxConstraints(
                minHeight: 80,
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.comment,
                    size: 30,
                    color: Colors.grey[400],
                  ),
                  trailing: notificationList[i]['look'] == 0
                      ? Icon(
                          Icons.new_releases,
                          color: Colors.red,
                        )
                      : SizedBox(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Complaint"),
                      Text("${notificationList[i]['text']}")
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (notificationList[i]['type'] == "gallery") {
          return InkWell(
            onTap: () async {
              changenotlook(notificationList[i]['notid']);
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CarouselDemo(
                            eventid: notificationList[i]['additional'],
                          )));
              refreshnot();
            },
            child: Container(
              constraints: BoxConstraints(
                minHeight: 80,
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.photo_album,
                    size: 30,
                    color: Colors.indigo[400],
                  ),
                  trailing: notificationList[i]['look'] == 0
                      ? Icon(
                          Icons.new_releases,
                          color: Colors.red,
                        )
                      : SizedBox(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text("${notificationList[i]['text']}")],
                  ),
                ),
              ),
            ),
          );
        }
        ;
        if (notificationList[i]['type'] == "poll") {
          return InkWell(
            onTap: () async {
              changenotlook(notificationList[i]['notid']);
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PollingUser()));
              refreshnot();
            },
            child: Container(
              constraints: BoxConstraints(
                minHeight: 80,
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.photo_album,
                    size: 30,
                    color: Colors.indigo[400],
                  ),
                  trailing: notificationList[i]['look'] == 0
                      ? Icon(
                          Icons.new_releases,
                          color: Colors.red,
                        )
                      : SizedBox(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text("${notificationList[i]['text']}")],
                  ),
                ),
              ),
            ),
          );
        }
        ;
        if (notificationList[i]['type'] == "bill") {
          return InkWell(
            onTap: () async {
              changenotlook(notificationList[i]['notid']);
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BillReminderUser()));
              refreshnot();
            },
            child: Container(
              constraints: BoxConstraints(
                minHeight: 80,
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.notification_important,
                    size: 30,
                    color: Colors.blueAccent[900],
                  ),
                  trailing: notificationList[i]['look'] == 0
                      ? Icon(
                          Icons.new_releases,
                          color: Colors.red,
                        )
                      : SizedBox(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text("${notificationList[i]['text']}")],
                  ),
                ),
              ),
            ),
          );
        }
      },
      separatorBuilder: (context, i) => Divider(
        height: 0,
      ),
    );
  }

  changenotlook(String id) async {
    var result = await http_get("changenotlook/$id");
    print(result.data['code']);
  }

  deleteoldnot() async {
    var result;
    if (wholerole == "admin")
      result = await http_get("deleteoldnotification/$wholeresid");
    else if (wholerole == "user")
      result = await http_get("deleteoldnotification/$wholeid");
    if (result.data['code'] == 200) {
      refreshnot();
    }
    setState(() {
      loading = false;
    });
  }

  // List<User> users = [];
  // List<User> mainuserlist = [];
  Future<void> refreshUsers() async {
    setState(() {
      notcounter = 0;
    });

    print(notcounter);
    // mainquery = 0;
    // textEditingController.clear();
    var result = await http_get('changenot/$wholeid');
    if (result.ok) {
      setState(() {});
    }
  }

  Future<void> refreshnot() async {
    var result;
    if (wholerole == "admin") result = await http_get('getnotify/$wholeresid');
    if (wholerole == "user") result = await http_get('getnotify/$wholeid');
    if (result.ok) {
      if (result.data['code'] == 200)
        setState(() {
          notificationList = result.data['list'];
        });
      print(notificationList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return showdeletealert(context);
                    });
              },
              icon: Icon(Icons.delete_forever, color: Colors.redAccent),
              label: Text("Clear", style: TextStyle(color: Colors.redAccent)))
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()));
            }),
        title: Text(
          "Notification",
          style: TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: refreshnot,
          child: !loading
              ? ListView(
                  children: <Widget>[
                    Container(
                      child: buildGridView(),
                    ),
                  ],
                )
              : Container(
                  child: loadingWidget,
                )),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    print("notcount");
    // ChatModel().init();
    getall();
    super.initState();
  }

  getall() {
    refreshNotificationCount();
    refreshMeetCount();
  }

  bool meetingstatus = false;
  Future<void> refreshMeetCount() async {
    var result = await http_get('getmeetcount/$wholeresid');
    print(result.data);
    if (result.ok) {
      setState(() {
        if (result.data['length'] == 0) {
          meetingstatus = false;
          print("0count");
        } else {
          meetingstatus = true;
        }
      });
      print(meetingstatus);
    }
  }

  Future<void> refreshNotificationCount() async {
    if (wholerole == "admin") {
      var result = await http_get('getnotnum/$wholeresid');
      if (result.ok) {
        setState(() {
          if (result.data['count'] == null) {
            notcounter = 0;
          } else {
            notcounter = result.data['count'];
          }
        });
      }
    } else {
      var result = await http_get('getnotnum/$wholeid');
      if (result.ok) {
        setState(() {
          if (result.data['count'] == null) {
            notcounter = 0;
          } else {
            notcounter = result.data['count'];
          }
        });
      }
    }
  }

  meetingbutton() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          // BoxShadow(
          //   offset: Offset(0, 4),
          //   blurRadius: 20,
          //   color: Color(0xFFB0CCE1).withOpacity(0.32),
          // ),
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.9),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MeetingPage();
                  },
                ),
              );
              getall();
            },
            child: Container(
              height: 175,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Meeting :",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                          height: 20,
                          width: 30,
                          decoration: BoxDecoration(
                              color: meetingstatus == false
                                  ? Colors.redAccent
                                  : Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        )
                      ],
                    ),
                    SvgPicture.asset(
                      "assets/images/meeting.svg",
                      height: 100,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.greenAccent[100],
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/menu.svg"),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
          title: RichText(
            text: TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: "Resid",
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: "Inn",
                  style: TextStyle(color: kPrimaryColor),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: new Stack(
                  children: <Widget>[
                    new Icon(
                      LineIcons.bell,
                      size: 26,
                    ),
                    if (notcounter != 0)
                      new Positioned(
                        right: 0,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: new Text(
                            '$notcounter',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                  ],
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                  print("object");
                  refreshNotificationCount();
                }),
          ]),
      body: Container(
        color: Colors.greenAccent[100],
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    // child: Image.asset(
                    //   "assets/images/r2.png",
                    //   width: 300,
                    // ),
                    child: Container(
                      height: 150,
                      child: SvgPicture.asset(
                        "assets/images/io1.svg",
                      ),
                    ),
                  ),
                  Divider(),
                  // SearchBox(
                  //   onChanged: (value) {
                  //     print(value);
                  //   },
                  // ),
                  meetingbutton(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      HomeScreenButton(
                        svgSrc: "assets/images/i4.png",
                        title: "Directory",
                        shopName: "",
                        width: 0.4,
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Directory();
                              },
                            ),
                          );
                        },
                        t: 1,
                      ),
                      HomeScreenButton(
                        svgSrc: "assets/images/i9.png",
                        title: "Event Schedule",
                        shopName: "",
                        width: 0.6,
                        press: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EventShedule();
                              },
                            ),
                          );
                          getall();
                        },
                        t: 2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      HomeScreenButton(
                        svgSrc: "assets/images/i3.png",
                        title: "Gallery",
                        width: 0.6,
                        shopName: "",
                        press: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EventGallery1();
                                // return MeetingPage();
                              },
                            ),
                          );
                          getall();
                        },
                        t: 1,
                      ),
                      HomeScreenButton(
                        svgSrc: "assets/images/i8.png",
                        title: "Bill Reminder",
                        shopName: "",
                        width: 0.4,
                        press: () async {
                          if (wholerole == "admin") {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return BillReminderAdmin();
                                },
                              ),
                            );
                          }
                          if (wholerole == "user") {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return BillReminderUser();
                                },
                              ),
                            );
                          }
                          getall();
                        },
                        t: 2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      wholerole == "admin"
                          ? HomeScreenButton(
                              svgSrc: "assets/images/i7.png",
                              title: "Complaints",
                              shopName: "",
                              width: 0.5,
                              press: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ComplaintSec()));
                                getall();
                              },
                              t: 1,
                            )
                          : HomeScreenButton(
                              svgSrc: "assets/images/i6.png",
                              title: "Chat With Admin",
                              shopName: "",
                              width: 0.5,
                              press: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Chatbot();
                                    },
                                  ),
                                );
                                getall();
                              },
                              t: 1,
                            ),
                      HomeScreenButton(
                        svgSrc: "assets/images/i5.png",
                        title: "Alert",
                        shopName: "",
                        width: 0.5,
                        press: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Alert();
                              },
                            ),
                          );
                          getall();
                        },
                        t: 2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      HomeScreenButton(
                        svgSrc: "assets/images/i10.png",
                        title: "Polling",
                        shopName: "",
                        width: 0.6,
                        press: () async {
                          if (wholerole == "admin") {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PollingAdmin();
                                },
                              ),
                            );
                          }
                          if (wholerole == "user") {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PollingUser();
                                },
                              ),
                            );
                          }
                          getall();
                        },
                        t: 2,
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: <Widget>[
                  //     wholerole == "admin"
                  //         ? HomeScreenButton(
                  //             svgSrc: "assets/images/i7.png",
                  //             title: "Complaints",
                  //             shopName: "",
                  //             width: 0.6,
                  //             press: () {
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => ComplaintSec()));
                  //             },
                  //             t: 1,
                  //           )
                  //         : HomeScreenButton(
                  //             svgSrc: "assets/images/i6.png",
                  //             title: "Chat With Admin",
                  //             shopName: "",
                  //             width: 0.6,
                  //             press: () {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) {
                  //                     return Chatbot();
                  //                   },
                  //                 ),
                  //               );
                  //             },
                  //             t: 1,
                  //           ),
                  //     HomeScreenButton(
                  //       svgSrc: "assets/images/i1.png",
                  //       title: "Event",
                  //       shopName: "Wendys",
                  //       width: 0.4,
                  //       press: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) {
                  //               return Chatbot(
                  //                 title: "Chatbot",
                  //               );
                  //             },
                  //           ),
                  //         );
                  //       },
                  //       t: 2,
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 50,
                  )
                  // DiscountCard(),
                ],
              ),
            ],
          ),
        ),
      ),
      endDrawer: DrawerInWidget(context),
      floatingActionButton: new IconButton(
          focusColor: Colors.red,
          icon: new Icon(Icons.navigation),
          color: Colors.green,
          onPressed: () {
            // setState(() {
            //   _messages.insert(0, new Text("message ${_messages.length}"));
            // });
            if (_scrollController.offset != 0.0) {
              print(1);
              _scrollController.animateTo(
                double.maxFinite,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            } else if (_scrollController.offset == 0.0) {
              print(0);

              _scrollController.animateTo(
                300,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          }),
    );
  }

  bool scroll = true;
}

class _DrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(50, 0);
    path.quadraticBezierTo(0, size.height / 2, 50, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class DrawerInWidget extends StatelessWidget {
  final BuildContext mcontext;
  DrawerInWidget(this.mcontext);
  showcode() async {
    // if (_formKey.currentState.validate()) {
    // _formKey.currentState.save();
    print("hello inece");
    String code;
    var result = await http_post("showcode", {"resid": wholeresid});
    if (result.data['code'] == 200) {
      code = result.data['codeforres'];
    } else {
      code = "Server problem";
    }
    showCode(mcontext, code);
  }

  showCode(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(child: Text(code)),
          actions: <Widget>[
            FlatButton(
              child: Text("Continue"),
              onPressed: () {
                //Put your code here which you want to execute on Cancel button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _logout(BuildContext mcontext) async {
    print("logout");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    mainuserlist.clear();
    meetforpage.clear();
    notificationList.clear();

    users.clear();

    Navigator.of(mcontext).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => new SignInScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _DrawerClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(top: 48, bottom: 32),
          height: (true)
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kPrimaryColor,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              DrawerItem(
                text: "Profile",
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileView())),
              ),
              DrawerItem(
                text: "Show Residence Code",
                onPressed: () {
                  showcode();
                },
              ),
              DrawerItem(
                text: "Settings",
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              ),
              DrawerItem(
                  text: "SignOut",
                  onPressed: () {
                    _logout(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreenButton extends StatelessWidget {
  final String title, shopName, svgSrc;
  final Function press;
  final double width;
  final int t;
  const HomeScreenButton(
      {Key key,
      this.title,
      this.shopName,
      this.svgSrc,
      this.press,
      this.t,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This size provide you the total height and width of the screen
    var kkk = 20;
    return Container(
      margin: t == 1
          ? EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10)
          : EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.9),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: press,
          child: Container(
            height: 150,
            width: (MediaQuery.of(context).size.width * width) - 30,
            // margin: kkk == 20
            //     ? EdgeInsets.fromLTRB(10, 0, 20, 10)
            //     : EdgeInsets.fromLTRB(20, 0, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   decoration: BoxDecoration(
                //       image: DecorationImage(
                //           fit: BoxFit.cover,
                //           image: widget.name == "SGPA/CGPA"
                //               ? AssetImage("images/GPA.png")
                //               : AssetImage("images/${widget.name}.png"))),
                // ),

                Container(
                  padding: EdgeInsets.all(10),
                  width: 130,
                  child: Image(fit: BoxFit.contain, image: AssetImage(svgSrc)),
                ),
                Text(
                  "$title",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
