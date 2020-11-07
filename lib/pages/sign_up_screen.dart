import 'dart:math';

import 'package:ResidInn/animation/fadeanimation.dart';
import 'package:ResidInn/geolocator/model.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/home-screen.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpAdminScreen extends StatefulWidget {
  static String routeName = "/sign_up_admin";
  @override
  _SignUpAdminScreenState createState() => _SignUpAdminScreenState();
}

class _SignUpAdminScreenState extends State<SignUpAdminScreen> {
  String email;
  String password;
  String conpassword;
  String resname;
  String adminname;
  bool remember = false;
  String code;

  String phonenumber;
  Map<String, double> currentLocation = Map();
  Address address;
  getUserCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    //String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality},${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country} ';
    String specificAddress = '${mPlaceMark.locality},${mPlaceMark.country}';
    locationcontroller.text = specificAddress; //location permisiion not asking
    print(locationcontroller.text);
  }

  Future<void> signupAdmin() async {
    var result = await http_post("registeradmin", {
      "email": email,
      "password": password,
      "phonenumber": "$countrycode $phonenumber",
      "adminname": adminname,
      "residencename": resname,
      "code": code,
      "location": locationcontroller.text
    });
    print(result.data['code']);
    if (result.data['code'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        // preferences.setString("id", id);
        wholerole = result.data['role'];
        wholeuseremail = email;
        wholeid = result.data['id'];
        wholeresid = result.data['resid'];
        print(wholeid);
        preferences.setString("email", wholeuseremail);
        preferences.setString("role", wholerole);
        preferences.setString("id", wholeid);
        preferences.setString("resid", wholeresid);
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => new HomeScreen()),
          (Route<dynamic> route) => false);
    } else {
      SnackBar snackBar = SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text("Error: ${result.data['message']}"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    // print("dsfdsgdg");
    // dynamic data = {"email": "assasfasfasf", "password": "asfasfasfasf"};
    // var dataStr = jsonEncode(data);
    // print(dataStr);
    // final response = await http.post('http://192.168.1.6:8000/create-user',
    //     headers: {
    //       "Content-Type": "application/json",
    //     },
    //     body: dataStr);

    // print(response.body);
  }

  var _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  textcodeproducer() {
    setState(() {
      code = getRandomString(8);
    });
  }

  @override
  initState() {
    //variables with location assigned as 0.0
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    initPlatformState(); //method to call location
    super.initState();
    textcodeproducer();
  }

  initPlatformState() async {
    Address first = await getUserLocation();
    setState(() {
      address = first;
    });
  }

  String countrycode = '+91';
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController locationcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Sign up for admin",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create an account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    textfieldcustom("Residence", false, TextInputType.text, 0),
                    textfieldcustom("Admin Name", false, TextInputType.text, 1),
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
                    textfieldcustom(
                        "Phone Number", false, TextInputType.phone, 2),
                    Divider(),
                    Row(
                      children: [
                        Text("Residence code:  $code"),
                        Spacer(),
                        GestureDetector(
                          onTap: () => textcodeproducer(),
                          child: Text(
                            "Generate code",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        )
                      ],
                    ),
                    Divider(),
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
                              title: location(label: "Location")),
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
                            ),
                          ),
                    textfieldcustom(
                        "Email", false, TextInputType.emailAddress, 3),
                    textfieldcustom(
                        "Password", true, TextInputType.visiblePassword, 4),
                    textfieldcustom("Confirm Password", true,
                        TextInputType.visiblePassword, 5),
                  ],
                ),

                Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        signupAdmin();
                      }
                    },
                    color: Colors.greenAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Sign up",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
                // FadeAnimation(
                //     1.6,
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         Text("Already have an account?"),
                //         Text(
                //           " Login",
                //           style: TextStyle(
                //               fontWeight: FontWeight.w600, fontSize: 18),
                //         ),
                //       ],
                //     )),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
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

  location({label, String value}) {
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

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatepassword(String value) {
    if (value.isEmpty) return 'Password Cannot be empty';
    if (value.length <= 8) return 'password length should greater than 8';
    return null;
  }

  String confirmpassword(String value) {
    print("cong $conpassword pass $password");
    if (value.isEmpty) return 'Empty';
    if (value.length <= 8) return 'password length should greater than 8';

    if (value != password) return 'Not Match';
    return null;
  }

  String others(String value) {
    if (value.isEmpty) return 'Empty field';

    return null;
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
          onChanged: (newValue) {
            if (t == 0) resname = newValue;
            if (t == 1) adminname = newValue;
            if (t == 2) phonenumber = newValue;

            if (t == 3) email = newValue;
            if (t == 4) password = newValue;
            if (t == 5) conpassword = newValue;
          },
          obscureText: obscure,
          validator: (val) {
            if (t == 0) return others(val);
            if (t == 1) return others(val);
            if (t == 2) return others(val);

            if (t == 3) return validateEmail(val);
            if (t == 4) return validatepassword(val);
            if (t == 5) return confirmpassword(val);
          },
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
}
