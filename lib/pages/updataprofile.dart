import 'package:ResidInn/geolocator/model.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ResidInn/pages/location.dart';
import 'package:ResidInn/constants.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'dart:async';

class UpdateProfile extends StatefulWidget {
  final String role;
  UpdateProfile({this.role});
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  void initState() {
    initPlatformState();
    getNormalValues();
    super.initState();
  }

  Map list;
  getNormalValues() async {
    var result;

    result = await http_get("profiledetails/$wholerole&$wholeid");
    print(result.data['list'][0]);
    list = result.data['list'][0];
    if (wholerole == "admin") {
      setState(() {
        textEditingController1.text = list['residencename'];
        textEditingController2.text = list['adminname'];

        textEditingController3.text = list['phonenumber'].split(" ")[1];
        locationcontroller.text = list['location'];
      });
    }
    if (wholerole == "user") {
      setState(() {
        textEditingController1.text = list['housename'];
        latitude = list['latitude'];
        longitude = list['longitude'];
      });
    }
    // textEditingController1.text = result.data[''];
  }

  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();
  TextEditingController textEditingController4 = TextEditingController();
  TextEditingController textEditingController5 = TextEditingController();

  var result;
  updateprofile() async {
    if (widget.role == "admin") {
      result = await http_post("updateadmin", {
        "id": wholeid,
        "residencename": textEditingController1.text,
        "adminname": textEditingController2.text,
        "phonenumber": "$countrycode ${textEditingController3.text}",
        "location": locationcontroller.text
      });
    } else if (widget.role == "user") {
      result = await http_post("updateuser", {
        "id": wholeid,
        "list": {
          "housename": textEditingController1.text,
          "longitude": longitude,
          "latitude": latitude
        }
      });
    }
    if (result.data['code'] == 200) {
      SnackBar snackBar = SnackBar(
        content: Text("Updated"),
        backgroundColor: Colors.greenAccent,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
    SnackBar snackBar = SnackBar(
      content: Text("Cant update"),
      backgroundColor: Colors.redAccent,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  contfun(int t) {
    if (t == 0) return textEditingController1;
    if (t == 1) return textEditingController2;

    if (t == 2) return textEditingController3;

    if (t == 3) return textEditingController4;
  }

  textfieldcustom(String label, bool obscure, TextInputType type, int t) {
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
        TextFormField(
          controller: contfun(t),
          obscureText: obscure,
          keyboardType: type,
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

  initPlatformState() async {
    Address first = await getUserLocation();
    setState(() {
      address = first;
    });
  }

  Location location = Location();
  String latitude = "Not set";
  String longitude = "Not set";
  int gotfromloc = 0;
  userupdate() {
    return Column(
      children: <Widget>[
        textfieldcustom("House name", false, TextInputType.text, 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: (MediaQuery.of(context).size.width / 1.4),
              child: ListTile(
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          latitude = "0.0";
                          longitude = "0.0";
                        });
                      }),
                  leading: IconButton(
                    icon: Icon(Icons.person_pin_circle),
                    iconSize: 26,
                    color:
                        gotfromloc == 2 ? Colors.greenAccent : Colors.redAccent,
                    onPressed: () async {
                      setState(() {
                        gotfromloc = 1;
                      });
                      await location.getCurrentLocation();
                      setState(() {
                        ///ivide change
                        latitude = location.latitude.toString();
                        longitude = location.longitude.toString();
                        if (latitude.isNotEmpty && longitude.isNotEmpty) {
                          gotfromloc = 2;
                        }
                      });
                    },
                  ),
                  title:
                      (gotfromloc == 1) ? loadingWidget : Text("Get location")),
            ),
          ],
        ),
        Text("Latitude: $latitude, Longitude: $longitude")
      ],
    );
  }

  getUserCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    //String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality},${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country} ';
    String specificAddress =
        '${mPlaceMark.subLocality} ${mPlaceMark.locality},${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country} ';
    locationcontroller.text = specificAddress; //location permisiion not asking
    print(locationcontroller.text);
  }

  String countrycode = "+91";
  TextEditingController locationcontroller = TextEditingController();
  adminupdate() {
    return Column(
      children: <Widget>[
        textfieldcustom("Residence Name", false, TextInputType.text, 0),
        textfieldcustom("Admin name", false, TextInputType.text, 1),
        SizedBox(
          width: 100,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CountryCodePicker(
              enabled: true,
              onChanged: (c) => countrycode = c.dialCode,
              initialSelection: 'IN',
              showOnlyCountryWhenClosed: true,
              favorite: ['+91', 'IN'],
            ),
          ),
        ),
        textfieldcustom("Phone Number", false, TextInputType.phone, 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: (MediaQuery.of(context).size.width / 1.4),
              child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.person_pin_circle),
                    iconSize: 20,
                    color: Colors.greenAccent,
                    onPressed: getUserCurrentLocation,
                  ),
                  title: location1(label: "Location")),
            ),
          ],
        ),
        (address == null)
            ? Container()
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    // buildLocationButton(address.featureName),
                    buildLocationButton(address.subLocality),
                    buildLocationButton(address.locality),
                    buildLocationButton(address.subAdminArea),
                    buildLocationButton(address.adminArea),
                    buildLocationButton(address.countryName),
                  ],
                ))
      ],
    );
  }

  buildLocationButton(String locationName) {
    if (locationName != null ?? locationName.isNotEmpty) {
      return InkWell(
        onTap: () {
          if (locationcontroller.text == '') {
            locationcontroller.text = locationName;
          } else {
            locationcontroller.text =
                locationcontroller.text + ", " + locationName;
          }
        },
        child: Center(
          child: Container(
            //width: 100.0,
            height: 30.0,
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(right: 3.0, left: 3.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                locationName,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Address address;
  location1({label, String value}) {
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
          controller: locationcontroller,
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 10,
        title: Text(
          "Update Profile",
          style: TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                widget.role == "admin" ? adminupdate() : userupdate(),
                SizedBox(
                  width: 100,
                  child: RaisedButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      updateprofile();
                    },
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Color(0xFF404A5C),
                      ),
                      child: Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            )),
      ),
    );
  }
}
