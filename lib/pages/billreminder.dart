import 'dart:math';

import 'package:ResidInn/constants.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:intl/intl.dart';

DateTime pickedDate;

class BillReminderAdmin extends StatefulWidget {
  @override
  _BillReminderAdminState createState() => _BillReminderAdminState();
}

class _BillReminderAdminState extends State<BillReminderAdmin> {
  void initState() {
    super.initState();
    getusersforbill();
    pickedDate = DateTime.now();
  }

  String name;
  String desc;
  List allusers = [];
  Future<void> getusersforbill() async {
    var result = await http_get("getusersforbill/$wholeresid");
    if (result.data['code'] == 200) {
      setState(() {
        allusers = result.data['list'];
        print(allusers);
      });
    }
    setState(() {
      loading = false;
    });
  }

  sendbill(String id) async {
    var result = await http_post("sendbill", {
      "billname": name,
      "description": desc,
      "duedate": DateFormat('dd-MM-yyyy').format(pickedDate).toString(),
      "category": category,
      "resid": wholeresid,
      "userid": id,
      "amount": amount
    });
    if (result.data['code'] == 200) {
      Navigator.pop(context);
    }
    setState(() {
      loading = false;
    });
  }

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

  int amount = 0;
  buildGridView() {
    return ListView.builder(
        itemCount: allusers.length,
        itemBuilder: (context, index) {
          return Card(
            color: Color(0xff29404E),
            child: InkWell(
              onTap: () {
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
                            constraints: BoxConstraints(maxHeight: 600),
                            child: ListView(
                              children: <Widget>[
                                Text(
                                  allusers[index]['housename'],
                                  style: TextStyle(fontSize: 27),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                new TextFormField(
                                  onChanged: (val) {
                                    name = val;
                                  },
                                  decoration: new InputDecoration(
                                      labelText: "Bill Name",
                                      fillColor: Colors.white,
                                      border: new OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),

                                        //fillColor: Colors.green
                                      ),
                                      prefixIcon:
                                          Icon(Icons.featured_play_list)),
                                  validator: (val) {},
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
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
                                        "Water Bill",
                                        "Electricity Bill",
                                        "Annual Resident Bill",
                                        "Other",
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
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
                                  height: 20,
                                ),
                                new TextFormField(
                                  onChanged: (val) {
                                    desc = val;
                                  },
                                  maxLines: 4,
                                  decoration: new InputDecoration(
                                      labelText: "Description",
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
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                new TextFormField(
                                  onChanged: (val) {
                                    amount = int.parse(val);
                                  },
                                  decoration: new InputDecoration(
                                      labelText: "Amount",
                                      fillColor: Colors.white,
                                      border: new OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),

                                        //fillColor: Colors.green
                                      ),
                                      prefixIcon: Icon(Icons.monetization_on)),
                                  validator: (val) {},
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                OutlineButton(
                                  onPressed: () => _pickDate(setState),
                                  child: Text(
                                    "Due Date: ${DateFormat('dd-MM-yyyy').format(pickedDate)}",
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
                                        sendbill(allusers[index]['id']);
                                      },
                                      child: Text(
                                        "Send Bill",
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
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                constraints: BoxConstraints(minHeight: 100),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          allusers[index]['housename'],
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        Text(
                          allusers[index]['email'] != null
                              ? allusers[index]['email']
                              : "",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool loading = true;
  String category = "Other";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BillList();
                    },
                  ),
                );
              },
              child: Icon(Icons.list))
        ],
        title: Text(
          "Make a Reminder",
          style: TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getusersforbill,
        child: Container(
          child: !loading ? buildGridView() : loadingWidget,
        ),
      ),
    );
  }
}

class BillList extends StatefulWidget {
  @override
  _BillListState createState() => _BillListState();
}

class _BillListState extends State<BillList> {
  void initState() {
    super.initState();
    getusersforbill();
  }

  deletebill(String billid) async {
    var result = await http_get("deletebill/$billid");
    if (result.data['code'] == 200) {
      getusersforbill();
      Navigator.pop(context);
    }
    setState(() {
      loading = false;
    });
  }

  bool loading = true;
  buildGridView() {
    if (allusers.isEmpty) {
      return Container(
        height: 500,
        child: Center(
          child: Text("Empty"),
        ),
      );
    }
    return ListView.builder(
        itemCount: allusers.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(15.0)),
                        ),
                        title: Text("Do you want to delete this bill record"),
                        content: Container(
                          constraints: BoxConstraints(maxHeight: 100),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "User: ${allusers[index]['housename']}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                allusers[index]['billname'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
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
                                      deletebill(allusers[index]['billid']);
                                    },
                                    child: Text(
                                      "Delete Bill",
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
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            allusers[index]['housename'],
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                          Text(
                            "Bill: ${allusers[index]['billname']}",
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                          Text(
                            "Description: ${allusers[index]['description']}",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Text(
                            "Amount: ${allusers[index]['amount']}",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Text(
                            "Due Date: ${allusers[index]['duedate']}",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(minHeight: 150)),
            ),
          );
        });
  }

  Future<void> getusersforbill() async {
    var result = await http_get("getbilllist/$wholeresid");
    if (result.data['code'] == 200) {
      setState(() {
        allusers = result.data['list'];
        print(allusers);
      });
    }
    setState(() {
      loading = false;
    });
  }

  List allusers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bill List",
          style: TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getusersforbill,
        child: Container(
          child: !loading ? buildGridView() : loadingWidget,
        ),
      ),
    );
  }
}

class BillReminderUser extends StatefulWidget {
  @override
  _BillReminderUserState createState() => _BillReminderUserState();
}

class _BillReminderUserState extends State<BillReminderUser> {
  void initState() {
    super.initState();
    getbill();
  }

  Future<void> getbill() async {
    var result = await http_get("getbill/$wholeid");
    print(result.data['code']);
    if (result.data['code'] == 200) {
      setState(() {
        billreminder = result.data['list'];
      });
    }
  }

  buildGridView() {
    if (billreminder.isEmpty) {
      return Container(
        height: 500,
        child: Center(child: Text("Not bills")),
      );
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: billreminder.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey,
            child: Container(
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(minHeight: 200),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Billname: ${billreminder[index]['billname']}",
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                      Spacer()
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("DueDate: ${billreminder[index]['duedate']}",
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                      Spacer()
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text("About: ${billreminder[index]['description']}",
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      Text("Total Amount: ${billreminder[index]['amount']}",
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  List billreminder = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bill Reminder",
          style: TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: getbill,
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
