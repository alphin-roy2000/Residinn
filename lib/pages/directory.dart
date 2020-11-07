import 'dart:io';
import 'package:ResidInn/everyconstants/cons.dart';
import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Note {
  String title;
  String text;

  Note(this.title, this.text);

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
  }
}

class Directory extends StatefulWidget {
  @override
  _DirectoryState createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  void initState() {
    refreshUsers();
    print("dhgdhfd");
    super.initState();
  }

  TextEditingController textEditingController = TextEditingController();
  // final ImageManager manager = ImageManager();
  // List<Note> _notes = List<Note>();
  // List<Note> _notesForDisplay = List<Note>();

  Future<void> refreshUsers() async {
    mainquery = 0;
    textEditingController.clear();
    var result = await http_get('getdirectory/$wholeresid');
    if (result.ok) {
      setState(() {
        users.clear();
        var in_users = result.data as List<dynamic>;
        in_users.forEach((in_user) {
          users.add(User(in_user['id'].toString(), in_user['housename'],
              in_user['latitude'], in_user['longitude']));
        });
        mainuserlist = users;
      });
    }
  }

  // Future<List<Note>> fetchNotes() async {
  //   var url = 'https://192.168.1.2:4000/getdirectory/$wholeresid';
  //   var response = await http.get(url);

  //   var notes = List<Note>();

  //   if (response.statusCode == 200) {
  //     var notesJson = json.decode(response.body);
  //     for (var noteJson in notesJson) {
  //       notes.add(Note.fromJson(noteJson));
  //     }
  //   }
  //   return notes;
  // }
//list= [{user:asfasf,name:alphin,latitude:11.0},{user:asfasf,name:alphin,latitude:11.0},{user:asfasf,name:alphin,latitude:11.0},{user:asfasf,name:alphin,latitude:11.0}]
  // final DirectoryManager dirmanager = DirectoryManager();

  //list[0]['name']
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Directory",
          style: TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () => refreshUsers())
        ],
      ),
      body: Container(
          // onRefresh: refreshUsers,
          child: Column(
        children: <Widget>[
          // _searchBar(),
          header(),
          Expanded(
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

  header() {
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.5, 0.9],
                colors: [
                  Color(0xffFFA69E),
                  Color(0xffFAF3DD),
                  Color(0xffB8F2E6),
                ],
              ),
            ),
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     SizedBox(height: 80),
          //     Text(
          //       "Directory",
          //       style: TextStyle(
          //           fontFamily: "Cor",
          //           fontSize: 73,
          //           fontWeight: FontWeight.bold,
          //           color: Color(0xff5E6472),
          //           height: 0.5),
          //     ),
          //   ],
          // ),
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
                  controller: textEditingController,
                  decoration: InputDecoration(hintText: 'Search...'),
                  onChanged: (query) {
                    setState(() {
                      print(query);
                      mainquery = query.length;
                      mainuserlist = users
                          .where((p) => p.name
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();
                    });
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
    );
  }

  buildGridView() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemCount: mainuserlist.length,
      itemBuilder: (context, i) =>
          // Card Which Holds Layout Of ListView Item
          Card(
        child: GestureDetector(
          onTap: () {
            print("dir");
          },
          child: Container(
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
            height: 80,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${mainuserlist[i].name}",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                if (mainuserlist[i].latitude != "0.0000000000" &&
                    mainuserlist[i].longitude != "0.0000000000")
                  FlatButton(
                    onPressed: () {
                      _launchURL(String url) async {
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      }

                      var latitude = mainuserlist[i].latitude;
                      var longitude = mainuserlist[i].longitude;

                      var url =
                          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                      _launchURL(url);
                    },
                    child: Icon(Icons.location_on),
                  ),
                FlatButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ContactView(
                            userid: mainuserlist[i].id,
                            username: mainuserlist[i].name);
                      },
                    ),
                  ),
                  child: Icon(Icons.call),
                )
              ],
            ),
          ),
        ),
      ),
      // separatorBuilder: (context, i) => Divider(),
    );
  }

  var mainquery = 0;
  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(hintText: 'Search...'),
          onChanged: (query) {
            setState(() {
              print(query);
              mainquery = query.length;
              mainuserlist = users
                  .where(
                      (p) => p.name.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            });
            //   text = text.toLowerCase();
            //   setState(() {
            //     _notesForDisplay = _notes.where((note) {
            //       var noteTitle = note.title.toLowerCase();
            //       return noteTitle.contains(text);
            //     }).toList();
            //   });
            // },
          }),
    );
  }

  // _listItem(index) {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.only(
  //           top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text(
  //             _notesForDisplay[index].title,
  //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //           ),
  //           Text(
  //             _notesForDisplay[index].text,
  //             style: TextStyle(color: Colors.grey.shade600),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

AppBar buildAppBar(BuildContext context,
    {bool isTransparent = false, String title}) {
  return AppBar(
    backgroundColor: isTransparent ? Colors.transparent : Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: Icon(
        Icons.menu,
        // color: kIconColor,
      ),
      onPressed: () {},
    ),
    title: !isTransparent
        ? Text(
            isTransparent ? "" : title,
            style: TextStyle(color: Colors.black),
          )
        : null,
    centerTitle: true,
  );
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/home_bg.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Text(
                "Directory",
                style: TextStyle(
                    fontSize: 73,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0.5),
              ),
              Text(
                "Travel Community App",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Positioned(
            bottom: -25,
            child: SearchField(),
          )
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 313,
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
      child: TextField(
        onChanged: (value) {},
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
          hintText: "Search.............…",
          hintStyle: TextStyle(
            fontSize: 16,
            color: Color(0xFF464A7E),
          ),
          suffixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
        ),
      ),
    );
  }
}
// Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           title: Text("Directory"),
//         ),
//         body: ListView.builder(
//           itemBuilder: (context, index) {
//             return index == 0 ? _searchBar() : _listItem(index - 1);
//           },
//           itemCount: _notesForDisplay.length + 1,
//         )
// class Note {
//   String title;
//   String text;

//   Note(this.title, this.text);

//   Note.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     text = json['text'];
//   }
// }

// class DestinationScreen extends StatefulWidget {
//   final Destination destination;

//   DestinationScreen({this.destination});

//   @override
//   _DestinationScreenState createState() => _DestinationScreenState();
// }

// class _DestinationScreenState extends State<DestinationScreen> {
//   Text _buildRatingStars(int rating) {
//     String stars = '';
//     for (int i = 0; i < rating; i++) {
//       stars += '⭐ ';
//     }
//     stars.trim();
//     return Text(stars);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Stack(
//             children: <Widget>[
//               Container(
//                 height: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       offset: Offset(0.0, 2.0),
//                       blurRadius: 6.0,
//                     ),
//                   ],
//                 ),
//                 child: Hero(
//                   tag: widget.destination.imageUrl,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(30.0),
//                     child: Image(
//                       image: AssetImage(widget.destination.imageUrl),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(Icons.arrow_back),
//                       iconSize: 30.0,
//                       color: Colors.black,
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         IconButton(
//                           icon: Icon(Icons.search),
//                           iconSize: 30.0,
//                           color: Colors.black,
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.arrow_drop_down_circle),
//                           iconSize: 25.0,
//                           color: Colors.black,
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 left: 20.0,
//                 bottom: 20.0,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       widget.destination.city,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 35.0,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Icon(
//                           Icons.location_on,
//                           size: 15.0,
//                           color: Colors.white70,
//                         ),
//                         SizedBox(width: 5.0),
//                         Text(
//                           widget.destination.country,
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 20.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 right: 20.0,
//                 bottom: 20.0,
//                 child: Icon(
//                   Icons.location_on,
//                   color: Colors.white70,
//                   size: 25.0,
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
//               itemCount: widget.destination.activities.length,
//               itemBuilder: (BuildContext context, int index) {
//                 Activity activity = widget.destination.activities[index];
//                 return Stack(
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
//                       height: 170.0,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   width: 120.0,
//                                   child: Text(
//                                     activity.name,
//                                     style: TextStyle(
//                                       fontSize: 18.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 2,
//                                   ),
//                                 ),
//                                 Column(
//                                   children: <Widget>[
//                                     Text(
//                                       '\$${activity.price}',
//                                       style: TextStyle(
//                                         fontSize: 22.0,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     Text(
//                                       'per pax',
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               activity.type,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             _buildRatingStars(activity.rating),
//                             SizedBox(height: 10.0),
//                             Row(
//                               children: <Widget>[
//                                 Container(
//                                   padding: EdgeInsets.all(5.0),
//                                   width: 70.0,
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(context).accentColor,
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     activity.startTimes[0],
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.0),
//                                 Container(
//                                   padding: EdgeInsets.all(5.0),
//                                   width: 70.0,
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(context).accentColor,
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     activity.startTimes[1],
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 20.0,
//                       top: 15.0,
//                       bottom: 15.0,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(20.0),
//                         child: Image(
//                           width: 110.0,
//                           image: AssetImage(
//                             activity.imageUrl,
//                           ),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Activity {
//   String imageUrl;
//   String name;
//   String type;
//   List<String> startTimes;
//   int rating;
//   int price;

//   Activity({
//     this.imageUrl,
//     this.name,
//     this.type,
//     this.startTimes,
//     this.rating,
//     this.price,
//   });
// }

// class Destination {
//   String imageUrl;
//   String city;
//   String country;
//   String description;
//   List<Activity> activities;

//   Destination({
//     this.imageUrl,
//     this.city,
//     this.country,
//     this.description,
//     this.activities,
//   });
// }

// List<Activity> activities = [
//   Activity(
//     imageUrl: 'assets/images/stmarksbasilica.jpg',
//     name: 'St. Mark\'s Basilica',
//     type: 'Sightseeing Tour',
//     startTimes: ['9:00 am', '11:00 am'],
//     rating: 5,
//     price: 30,
//   ),
//   Activity(
//     imageUrl: 'assets/images/gondola.jpg',
//     name: 'Walking Tour and Gonadola Ride',
//     type: 'Sightseeing Tour',
//     startTimes: ['11:00 pm', '1:00 pm'],
//     rating: 4,
//     price: 210,
//   ),
//   Activity(
//     imageUrl: 'assets/images/murano.jpg',
//     name: 'Murano and Burano Tour',
//     type: 'Sightseeing Tour',
//     startTimes: ['12:30 pm', '2:00 pm'],
//     rating: 3,
//     price: 125,
//   ),
// ];

// List<Destination> destinations = [
//   Destination(
//     imageUrl: 'assets/images/venice.jpg',
//     city: 'Venice',
//     country: 'Italy',
//     description: 'Visit Venice for an amazing and unforgettable adventure.',
//     activities: activities,
//   ),
//   Destination(
//     imageUrl: 'assets/images/paris.jpg',
//     city: 'Paris',
//     country: 'France',
//     description: 'Visit Paris for an amazing and unforgettable adventure.',
//     activities: activities,
//   ),
//   Destination(
//     imageUrl: 'assets/images/newdelhi.jpg',
//     city: 'New Delhi',
//     country: 'India',
//     description: 'Visit New Delhi for an amazing and unforgettable adventure.',
//     activities: activities,
//   ),
//   Destination(
//     imageUrl: 'assets/images/saopaulo.jpg',
//     city: 'Sao Paulo',
//     country: 'Brazil',
//     description: 'Visit Sao Paulo for an amazing and unforgettable adventure.',
//     activities: activities,
//   ),
//   Destination(
//     imageUrl: 'assets/images/newyork.jpg',
//     city: 'New York City',
//     country: 'United States',
//     description: 'Visit New York for an amazing and unforgettable adventure.',
//     activities: activities,
//   ),
// ];
class ContactView extends StatefulWidget {
  final String username;
  final String userid;
  ContactView({this.username, this.userid});
  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  void initState() {
    super.initState();
    getphonenumber();
  }

  List phonelist = List();
  getphonenumber() async {
    var results = await http_get("phonenumber/${widget.userid}");
    print(results.data);

    setState(() {
      phonelist = results.data;
    });
    print(phonelist);
    print("Helloworld");
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  buildGridView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: phonelist.length,
      itemBuilder: (context, i) => GestureDetector(
        onTap: () {
          _makePhoneCall('tel:${phonelist[i]['phonenumber']}');
        },
        // Card Which Holds Layout Of ListView Item
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${phonelist[i]['name']}",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        "${phonelist[i]['phonenumber']}",
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                      ),
                    ),
                  ],
                ),
              ),
              if (phonelist[i]['whatsapp'] == 1)
                FlatButton(
                  onPressed: () {
                    launchWhatsApp(
                        phone: phonelist[i]['phonenumber'],
                        message: "Hello Friend");
                  },
                  child: Image.asset(
                    'assets/images/whatsapp.png',
                    height: 25,
                  ),
                ),
            ],
          ),
        ),
      ),
      separatorBuilder: (context, i) => Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts of ${widget.username}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[buildGridView()],
        ),
      ),
    );
  }
}
