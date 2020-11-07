// import 'dart:convert';
// import 'dart:async';
// import 'package:ResidInn/modules/http.dart';
// import 'package:http/http.dart' as http;
// import 'package:workmanager/workmanager.dart';
import 'package:flutter/material.dart';
import 'package:ResidInn/calendar_strip.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// //this is the name given to the background fetch
// const simplePeriodicTask = "simplePeriodicTask";
// // flutter local notification setup
// void showNotification(v, flp) async {
//   var android = AndroidNotificationDetails(
//       'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
//       priority: Priority.high, importance: Importance.max);
//   var iOS = IOSNotificationDetails();
//   var platform = NotificationDetails(android: android, iOS: iOS);
//   await flp.show(0, 'Virtual intelligent solution', '$v', platform,
//       payload: 'VIS \n $v');
// }

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Workmanager.initialize(callbackDispatcher,
// //       isInDebugMode:
// //           true); //to true if still in testing lev turn it to false whenever you are launching the app
// //   await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
// //       existingWorkPolicy: ExistingWorkPolicy.replace,
// //       frequency: Duration(minutes: 15), //when should it check the link
// //       initialDelay:
// //           Duration(seconds: 5), //duration before showing the notification
// //       constraints: Constraints(
// //         networkType: NetworkType.connected,
// //       ));
// //   runApp(MyApp());
// // }

// void callbackDispatcher() {
//   Workmanager.executeTask((task, inputData) async {
//     FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
//     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOS = IOSInitializationSettings();
//     var initSetttings = InitializationSettings(android: android, iOS: iOS);
//     flp.initialize(initSetttings);

//     var response = await http_post("testnot");
//     print("here================");
//     print(response);

//     if (response.data['status'] == true) {
//       showNotification(response.data['msg'], flp);
//     } else {
//       print("no messgae");
//     }

//     return Future.value(true);
//   });
// }

// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Testing push notification"),
//           centerTitle: true,
//         ),
//         body: Align(
//           alignment: Alignment.center,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//                 child: Text(
//                     "Flutter push notification without firebase with background fetch feature")),
//           ),
//         ));
//   }
// }
class Test12 extends StatefulWidget {
  Test12({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _Test12State createState() => _Test12State();
}

class _Test12State extends State<Test12> {
  DateTime startDate = DateTime.now().subtract(Duration(days: 2));
  DateTime endDate = DateTime.now().add(Duration(days: 30));
  DateTime selectedDate = DateTime.now().subtract(Duration(days: 0));
  List<DateTime> markedDates = [
    // DateTime.now().subtract(Duration(days: 1)),
    // DateTime.now().subtract(Duration(days: 2)),
    // DateTime.now().add(Duration(days: 30))
  ];

  @override
  void initState() {
    super.initState();
  }

  onSelect(data) {
    print("Selected Date -> $data");
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: CalendarStrip(
        startDate: startDate,
        endDate: endDate,
        selectedDate: selectedDate,
        onDateSelected: onSelect,
        onWeekSelected: onWeekSelect,
        dateTileBuilder: dateTileBuilder,
        iconColor: Colors.black87,
        monthNameWidget: _monthNameWidget,
        markedDates: markedDates,
        containerDecoration: BoxDecoration(color: Colors.black12),
        addSwipeGesture: true,
      )),
    );
  }
}
