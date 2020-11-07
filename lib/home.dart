import 'dart:async';

import 'package:ResidInn/constants.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:ResidInn/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:ResidInn/data/data.dart';
import 'package:intl/intl.dart';

import 'models/date_model.dart';
import 'models/event_type_model.dart';
import 'models/events_model.dart';
import 'package:ResidInn/calendar_strip.dart';
import "package:collection/collection.dart";

TimeOfDay time;
DateTime pickedDate;
String textfor(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date);
}

class EventShedule extends StatefulWidget {
  @override
  _EventSheduleState createState() => _EventSheduleState();
}

class _EventSheduleState extends State<EventShedule> {
  DateTime startDate = DateTime.now().subtract(Duration(days: 2));
  DateTime endDate = DateTime.now().add(Duration(days: 30));
  DateTime selectedDate;
  List<DateTime> markedDates = [
    // DateTime.now().subtract(Duration(days: 1)),
    // DateTime.now().subtract(Duration(days: 2)),
    // DateTime.now().add(Duration(days: 30))
  ];

  List<DateModel> dates = new List<DateModel>();
  List<EventTypeModel> eventsType = new List();
  List<EventsModel> events = new List<EventsModel>();

  String todayDateIs = "1";
  onSelect(data) {
    print(DateFormat('yyyy-MM-dd').format(data));
    getApi(DateFormat('yyyy-MM-dd').format(data).toString());
    setState(() {
      selectcategory = 0;
      selectedDate = data;
    });
    print("Selected Date -> $selectcategory");
  }

  onWeekSelect(data) {
    print("Selected week starting at -> $data");
  }

  _monthNameWidget(monthName) {
    return Container(
      child: Text(
        monthName,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontStyle: FontStyle.italic,
        ),
      ),
      padding: EdgeInsets.only(top: 8, bottom: 4),
    );
  }

  getMarkedIndicatorWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 1, right: 1),
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      ),
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      )
    ]);
  }

  dateTileBuilder(
      date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black87);
    TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    if (isDateMarked == true) {
      _children.add(getMarkedIndicatorWidget());
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = DateTime.now();
    getApi(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
    getApiDate();
    eventsType = getEventTypes();
    events = getEvents();
  }

  List categoryevent = ['All'];
  List wholeevent = [];
  List tempevent = [];
  getApi(String date) async {
    var result = await http_get("getevent/$wholeresid&$date");
    print(result.data['list']);
    if (result.data['code'] == 200) {
      setState(() {
        categoryevent.clear();
        categoryevent = ['All'];
        print(categoryevent);
        tempevent.clear();

        wholeevent = result.data['list'] as List<dynamic>;
        print(wholeevent);
        tempevent = wholeevent;
        // var temp1 = groupBy(result.data['list'], (obj) => obj['date']);
        // temp1.forEach((key, value) {
        //   markedDates.add(DateTime.parse(key));
        // });
        var temp = groupBy(result.data['list'], (obj) => obj['category']);
        temp.forEach((key, value) {
          categoryevent.add(key);
        });
        print(categoryevent);
      });
    }
  }

  getApiDate() async {
    var result = await http_get("geteventdetails/$wholeresid");
    print(result.data['code']);
    if (result.data['code'] == 200) {
      markedDates.clear();
      setState(() {
        var temp1 = groupBy(result.data['list'], (obj) => obj['date']);
        temp1.forEach((key, value) {
          markedDates.add(DateTime.parse(key));
        });
      });
    }
  }

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  // color: Color(0xff102733)
                  color: Colors.white),
            ),
            SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Events",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        Spacer(),
                        SizedBox(
                          width: 16,
                        ),
                        FlatButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScheduleList()));
                            setState(() {
                              selectcategory = 0;
                            });
                            print(selectedDate);
                            getApi(DateFormat('yyyy-MM-dd')
                                .format(selectedDate)
                                .toString());
                            getApiDate();
                          },
                          icon: Icon(Icons.schedule),
                          label: Text(
                            "Schedule",
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Hello, Residents !",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Let's explore what’s happening next",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    /// Dates
                    // Container(
                    //   height: 60,
                    //   child: ListView.builder(
                    //       itemCount: dates.length,
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.horizontal,
                    //       itemBuilder: (context, index) {
                    //         return DateTile(
                    //           weekDay: dates[index].weekDay,
                    //           date: dates[index].date,
                    //           isSelected: todayDateIs == dates[index].date,
                    //         );
                    //       }),
                    // ),
                    Container(
                        child: CalendarStrip(
                      startDate: startDate,
                      endDate: endDate,
                      selectedDate: selectedDate,
                      onDateSelected: onSelect,
                      onWeekSelected: onWeekSelect,
                      dateTileBuilder: dateTileBuilder,
                      iconColor: Colors.grey,
                      monthNameWidget: _monthNameWidget,
                      markedDates: markedDates,
                      containerDecoration: BoxDecoration(color: Colors.black12),
                      addSwipeGesture: true,
                    )),

                    /// Events
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "All Events",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 100,
                      child: ListView.builder(
                          itemCount: categoryevent.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return eventitle(
                                imgAssetPath: eventsType[0].imgAssetPath,
                                eventType: categoryevent[index],
                                index: index);
                          }),
                    ),

                    /// Popular Events
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Popular Events",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    (tempevent.length != 0)
                        ? Container(
                            height: 400,
                            child: ListView.builder(
                                itemCount: tempevent.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return PopularEventTile(
                                      desc: tempevent[index]['eventname'],
                                      imgeAssetPath: events[0].imgeAssetPath,
                                      date: tempevent[index]['date'],
                                      address: tempevent[index]['venue'],
                                      time: tempevent[index]['time']);
                                }))
                        : Container(
                            child: Center(
                              child: Text("Not Events"),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int selectcategory = 0;
  eventitle({String imgAssetPath, String eventType, int index}) {
    return InkWell(
      splashColor: Colors.green,
      onTap: () {
        setState(() {
          selectcategory = index;
        });
        if (selectcategory == 0) {
          tempevent = wholeevent;
          print("asfasf");
          print(wholeevent);
        } else {
          tempevent = wholeevent
              .where((p) => p['category'].toLowerCase().contains(
                  categoryevent[selectcategory].toString().toLowerCase()))
              .toList();
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
            color: selectcategory != index ? Color(0xff29404E) : Colors.green,
            borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                imgAssetPath,
                height: 27,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                eventType,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  String weekDay;
  String date;
  bool isSelected;
  DateTile({this.weekDay, this.date, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: isSelected ? Color(0xffFCCD00) : Colors.transparent,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            weekDay,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  String imgAssetPath;
  String eventType;
  EventTile({this.imgAssetPath, this.eventType});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Color(0xff29404E), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imgAssetPath,
            height: 27,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            eventType,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class PopularEventTile extends StatelessWidget {
  String desc;
  String date;
  String address;
  String imgeAssetPath;
  String time;

  /// later can be changed with imgUrl
  PopularEventTile(
      {this.address, this.date, this.imgeAssetPath, this.desc, this.time});

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    desc,
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
                        DateFormat('dd-MM-yyyy').format(DateTime.parse(date)),
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
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        TimeOfDay(
                                hour: int.parse(time.split(":")[0]),
                                minute: int.parse(time.split(":")[1]))
                            .format(context),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/location.png",
                        height: 15,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        address,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleEvent extends StatefulWidget {
  @override
  _ScheduleEventState createState() => _ScheduleEventState();
}

class _ScheduleEventState extends State<ScheduleEvent> {
  String category = "Other";
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
      lastDate: DateTime(DateTime.now().year + 1),
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

  bool uploading = false;
  String eventname;
  sendEvent() async {
    print(pickedDate.toUtc());
    var result = await http_post("insertevent", {
      "eventname": eventname,
      "date": DateFormat('yyyy-MM-dd').format(pickedDate).toString(),
      "time": "${time.hour}:${time.minute}:00",
      "venue": venue,
      "resid": wholeresid,
      "category": category
    });
    if (result.data['code'] == 200) {
      SnackBar snackBar = SnackBar(
          backgroundColor: Colors.blueAccent,
          behavior: SnackBarBehavior.floating,
          content: Text("Event was successfully scheduled"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 1), onClose);
    } else {
      SnackBar snackBar = SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text("Event couldn't be registered"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    setState(() {
      uploading = false;
    });
  }

  onClose() {
    Navigator.pop(context);
  }

  //for better one i have use the bubble package check out the pubspec.yaml
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String venue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Schedule an Event",
          style: TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  uploading ? LinearProgressIndicator() : SizedBox(),
                  SizedBox(
                    height: 30,
                  ),
                  new TextFormField(
                    onChanged: (value) {
                      setState(() {
                        eventname = value;
                      });
                    },
                    decoration: new InputDecoration(
                        labelText: "Event Name",
                        prefixIcon: Icon(Icons.event),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          //fillColor: Colors.green
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        )),
                    validator: (val) {
                      if (val.length == 0) {
                        return "cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
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
                          "Tour",
                          "Family Fun",
                          "Enjoy",
                          "Annual Event",
                          "Christmas",
                          "Onam",
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
                  SizedBox(
                    height: 30,
                  ),
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
                  SizedBox(
                    height: 30,
                  ),
                  new TextFormField(
                    onChanged: (value) {
                      venue = value;
                    },
                    decoration: new InputDecoration(
                        labelText: "Venue",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),

                          //fillColor: Colors.green
                        ),
                        prefixIcon: Icon(Icons.location_on)),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Email cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      color: Color(0xff29404E),
                      height: 60,
                      width: 250,
                      child: OutlineButton(
                        onPressed: () {
                          setState(() {
                            uploading = true;
                          });
                          sendEvent();
                        },
                        child: Text(
                          "Schedule Event",
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
          ),
        ),
      ),
    );
  }
}

class ScheduleList extends StatefulWidget {
  @override
  _ScheduleListState createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  void initState() {
    super.initState();
    getApi();
  }

  List eventall = [];
  Future<void> getApi() async {
    var result = await http_get("geteventsall/$wholeresid");
    if (result.data['code'] == 200) {
      setState(() {
        eventall = result.data['list'];
      });
    }
  }

  Future<void> deletemeet() async {
    print("delete");
    var result = await http_get('deloldevents/$wholeresid');

    if (result.ok) {
      if (result.data['code'] == 200) {
        await getApi();
      }
    }
    setState(() {
      loading = false;
    });
  }

  bool loading = false;
  showDeleleMulti(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Old Event Record"),
      content: Text(
          "Do you want to delete your old resident event records (dates below 2 days ago will be deleted)"),
      actions: <Widget>[
        FlatButton(
          child: Text("Delete"),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            deletemeet();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            wholerole == "admin"
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return showDeleleMulti(context);
                          });
                    })
                : SizedBox(),
            wholerole == "admin"
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScheduleEvent()));
                      getApi();
                    })
                : SizedBox(),
          ],
          title: Text(
            "Schedules",
            style: TextStyle(
                color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
        body: RefreshIndicator(
            child: ListView(
              children: <Widget>[
                !loading
                    ? Container(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: eventall.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onLongPress: () {
                                  wholerole == "admin"
                                      ? showDialog(
                                          context: context,
                                          builder: (_) {
                                            return showDelele(
                                                context, eventall[index]);
                                          })
                                      : print("object");
                                },
                                child: PopularEventTile(
                                    desc: eventall[index]['eventname'],
                                    date: eventall[index]['date'],
                                    address: eventall[index]['venue'],
                                    time: eventall[index]['time']),
                              );
                            }),
                      )
                    : Container(
                        child: loadingWidget,
                      ),
              ],
            ),
            onRefresh: getApi));
  }

  showDelele(BuildContext context, var event) {
    return AlertDialog(
      title: Text("Delete This event : ${event['eventname']}"),
      content: Text("Date: ${event['date']}"),
      actions: <Widget>[
        FlatButton(
          child: Text("Delete"),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            deleteevent(event['eventid']);

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

  void deleteevent(String eventid) async {
    var result = await http_get("deleteevent/$eventid");
    if (result.data['code'] == 200) {
      getApi();
    }
    setState(() {
      loading = false;
    });
  }
}
