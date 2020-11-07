
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:flutter/material.dart';

class Phonenumbers extends StatefulWidget {
  @override
  _PhonenumbersState createState() => _PhonenumbersState();
}

class _PhonenumbersState extends State<Phonenumbers> {
  void initState() {
    super.initState();
    getphonenumber();
  }

  List phonelist = List();
  getphonenumber() async {
    var results = await http_get("phonenumber/$wholeid");
    print(results.data);

    setState(() {
      phonelist = results.data;
    });
  }

  TextEditingController name = TextEditingController();
  TextEditingController phonenumber = TextEditingController();

  addphonenumer() async {
    print(wholeid);
    var result = await http_post("addphonenumber", {
      "userid": wholeid,
      "name": name.text,
      "phonenumber": phonenumber.text,
      "whatsapp": checkBoxValue
    });
    print(result.data['code']);
    if (result.data['code'] == 200) {
      getphonenumber();
      name.clear();
      phonenumber.clear();
    }
    setState(() {
      checkBoxValue = false;
    });
  }

  bool checkBoxValue = false;
  deletephonenumer(var dirid) async {
    var result = await http_get("deletephonenumber/$dirid");
    print(result.data['code']);
    if (result.data['code'] == 200) {
      getphonenumber();
    }
  }

  buildGridView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: phonelist.length,
      itemBuilder: (context, i) => GestureDetector(
        onTap: () {},
        child: ListTile(
            trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => deletephonenumer(phonelist[i]['directoryid'])),
            leading: Icon(Icons.person),
            title: Column(
              children: <Widget>[
                Text("${phonelist[i]['name']}"),
                Text("${phonelist[i]['phonenumber']}")
              ],
            )),
      ),
      separatorBuilder: (context, i) => Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Phone Number"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        buildGridView(),
                        Divider(),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new TextField(
                                    controller: name,
                                    decoration: InputDecoration(
                                        hintText: 'Enter name',
                                        contentPadding: EdgeInsets.all(10))),
                              ),
                            ),
                            Text(":"),
                            new Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new TextField(
                                    keyboardType: TextInputType.phone,
                                    controller: phonenumber,
                                    decoration: InputDecoration(
                                        hintText: 'Phone number',
                                        contentPadding: EdgeInsets.all(10))),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              Text("   Whatsapp ?  "),
                              new Checkbox(
                                  value: checkBoxValue,
                                  activeColor: Colors.green,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      checkBoxValue = newValue;
                                    });
                                  }),
                            ],
                          ),
                        ),
                        RaisedButton(
                            onPressed: () {
                              addphonenumer();
                            },
                            child: Text("Add")),
                      ],
                    )
                  ],
                ))));
  }

  makeInput({label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          onChanged: (val) {
            setState(() {});
          },
          obscureText: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
