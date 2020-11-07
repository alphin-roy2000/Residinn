import 'package:ResidInn/constants.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:ResidInn/pages/updataprofile.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void initState() {
    super.initState();
    getdata();
  }

  Map details;
  bool loading = true;

  getdata() async {
    var result = await http_get("profiledetails/$wholerole&$wholeid");
    details = result.data['list'][0];
    print(details);
    if (wholerole == "user") {
      getUserCurrentLocation();
      print("sfdfsdsd");
    }
    setState(() {
      loading = false;
    });
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.9],
          colors: [
            Color(0xff17BEBB),
            Color(0xff758BFD),
            Color(0xffAEB8FE),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTop() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      details['adminname'],
      style: _nameTextStyle,
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 22.0,
      fontWeight: FontWeight.w300,
    );

    return Text(
      wholeuseremail,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        wholerole,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  adminview(Size screenSize) {
    return Column(
      children: <Widget>[
        SizedBox(height: 80),
        _buildProfileTop(),
        SizedBox(
          height: 20,
        ),
        _buildFullName(),
        SizedBox(
          height: 10,
        ),
        _buildStatus(context),
        SizedBox(
          height: 10,
        ),
        Text(
          "Residence :${details['residencename']}",
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "Location :${details['location']}",
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: 70,
        )
      ],
    );
  }

  userview() {
    return Column(
      children: <Widget>[
        SizedBox(height: 80),
        Text(
          details['housename'],
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        _buildFullName(),
        SizedBox(
          height: 10,
        ),
        _buildStatus(context),
        SizedBox(
          height: 10,
        ),
        Text(
          "Residence :${details['residencename']}",
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Location: $locationvalue",
            style: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }

  getUserCurrentLocation() async {
    final coordinates = new Coordinates(
        double.parse(details['latitude']), double.parse(details['longitude']));
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var mPlaceMark = addresses.first;
    //String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality},${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country} ';
    String specificAddress = '${mPlaceMark.addressLine}';
    print(specificAddress);
    setState(() {
      locationvalue = specificAddress;
    });
  }

  String locationvalue = "No current location";
  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width - 30,
            child: RaisedButton(
              padding: EdgeInsets.all(0),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateProfile(role: wholerole)));
                getdata();
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: (loading == true)
            ? Container(color: Colors.white60, child: loadingWidget)
            : Padding(
                padding: EdgeInsets.all(0),
                child: Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.center,
                  children: [
                    _buildCoverImage(screenSize),
                    SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                          child: wholerole == "admin"
                              ? adminview(screenSize)
                              : userview()),
                    ),
                    Positioned(bottom: 0, child: _buildButtons())
                  ],
                ),
              ));
  }
}

// Padding(
//               padding: EdgeInsets.all(0),
//               child: Stack(
//                 children: <Widget>[
//                   _buildCoverImage(screenSize),
//                   SizedBox(
//                     width: double.infinity,
//                     child: SingleChildScrollView(
//                         child: wholerole == "admin"
//                             ? adminview(screenSize)
//                             : userview()),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     child: Container(
//                         width: double.infinity,
//                         height: 30,
//                         child: Text(
//                           "Balance",
//                         )),
//                   )
//                 ],
//               ),
//             ),
class Test1 extends StatefulWidget {
  @override
  _Test1State createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: -25,
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Color(0xFF3E4067),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(3, 3),
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.16),
                        spreadRadius: -2,
                      )
                    ],
                  ),
                  // padding: const EdgeInsets.all(4),
                  child: TextField(
                      decoration: InputDecoration(hintText: 'Search...'),
                      onChanged: (query) {
                        setState(() {});
                        //   text = text.toLowerCase();
                        //   setState(() {
                        //     _notesForDisplay = _notes.where((note) {
                        //       var noteTitle = note.title.toLowerCase();
                        //       return noteTitle.contains(text);
                        //     }).toList();
                        //   });
                        // },
                      }),
                ),
              )
            ],
          ),
        ));
  }
}
