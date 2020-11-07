import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:flutter/material.dart';

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
    refreshUsers();
    print("dhgdhfd");
    super.initState();
  }

  buildGridView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, i) => GestureDetector(
        onTap: () {},
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text("data"),
        ),
      ),
      separatorBuilder: (context, i) => Divider(),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.of(context).pop(MaterialPageRoute(
        //           builder: (BuildContext context) => HomeScreen()));
        //     }),
        title: Text("Notification"),
      ),
      body: RefreshIndicator(
          onRefresh: refreshUsers,
          child: ListView(
            children: <Widget>[
              Container(
                child: buildGridView(),
              ),
              // ListView.separated(
              //   itemCount: users.length,
              //   itemBuilder: (context, i) => ListTile(
              //     leading: Icon(Icons.person),
              //     title: Text(users[i].name),
              //   ),
              //   separatorBuilder: (context, i) => Divider(),
              // ),
            ],
          )),
    );
  }
}
