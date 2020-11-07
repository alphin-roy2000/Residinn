// import 'package:carousel_pro/carousel_pro.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:multi_image_picker/multi_image_picker.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final _globalKey = GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         key: _globalKey,
//         backgroundColor: Theme.of(context).backgroundColor,
//         appBar: AppBar(
//           title: Text('Multiple Images'),
//           bottom: TabBar(
//             tabs: [
//               Tab(
//                 icon: Icon(Icons.image),
//                 text: 'Images',
//               ),
//               Tab(
//                 icon: Icon(Icons.cloud_upload),
//                 text: "Upload Images",
//               ),
//             ],
//             indicatorColor: Colors.red,
//             indicatorWeight: 5.0,
//           ),
//         ),
//         body: TabBarView(
//           children: <Widget>[
//             ViewImages(),
//             UploadImages(
//               globalKey: _globalKey,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class UploadImages extends StatefulWidget {
//   final GlobalKey<ScaffoldState> globalKey;
//   const UploadImages({Key key, this.globalKey}) : super(key: key);
//   @override
//   _UploadImagesState createState() => new _UploadImagesState();
// }

// class _UploadImagesState extends State<UploadImages> {
//   List<Asset> images = List<Asset>();
//   List<String> imageUrls = <String>[];
//   String _error = 'No Error Dectected';
//   bool isUploading = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Widget buildGridView() {
//     return GridView.count(
//       crossAxisCount: 3,
//       children: List.generate(images.length, (index) {
//         Asset asset = images[index];
//         print(asset.getByteData(quality: 100));
//         return Padding(
//           padding: EdgeInsets.all(8.0),
//           child: ThreeDContainer(
//             backgroundColor: MultiPickerApp.darker,
//             backgroundDarkerColor: MultiPickerApp.darker,
//             height: 50,
//             width: 50,
//             borderDarkerColor: MultiPickerApp.pauseButton,
//             borderColor: MultiPickerApp.pauseButtonDarker,
//             child: ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(15)),
//               child: AssetThumb(
//                 asset: asset,
//                 width: 300,
//                 height: 300,
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   InkWell(
//                     onTap: loadAssets,
//                     child: ThreeDContainer(
//                       width: 130,
//                       height: 50,
//                       backgroundColor: MultiPickerApp.navigateButton,
//                       backgroundDarkerColor: MultiPickerApp.background,
//                       child: Center(
//                           child: Text(
//                         "Pick images",
//                         style: TextStyle(color: Colors.white),
//                       )),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       if (images.length == 0) {
//                         showDialog(
//                             context: context,
//                             builder: (_) {
//                               return AlertDialog(
//                                 backgroundColor:
//                                     Theme.of(context).backgroundColor,
//                                 content: Text("No image selected",
//                                     style: TextStyle(color: Colors.white)),
//                                 actions: <Widget>[
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: ThreeDContainer(
//                                       width: 80,
//                                       height: 30,
//                                       backgroundColor:
//                                           MultiPickerApp.navigateButton,
//                                       backgroundDarkerColor:
//                                           MultiPickerApp.background,
//                                       child: Center(
//                                           child: Text(
//                                         "Ok",
//                                         style: TextStyle(color: Colors.white),
//                                       )),
//                                     ),
//                                   )
//                                 ],
//                               );
//                             });
//                       } else {
//                         SnackBar snackbar = SnackBar(
//                             content: Text('Please wait, we are uploading'));
//                         widget.globalKey.currentState.showSnackBar(snackbar);
//                         uploadImages();
//                       }
//                     },
//                     child: ThreeDContainer(
//                       width: 130,
//                       height: 50,
//                       backgroundColor: MultiPickerApp.navigateButton,
//                       backgroundDarkerColor: MultiPickerApp.background,
//                       child: Center(
//                           child: Text(
//                         "Upload Images",
//                         style: TextStyle(color: Colors.white),
//                       )),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Expanded(
//                 child: buildGridView(),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void uploadImages() {
//     for (var imageFile in images) {
//       postImage(imageFile).then((downloadUrl) {
//         imageUrls.add(downloadUrl.toString());
//         if (imageUrls.length == images.length) {
//           String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
//           Firestore.instance
//               .collection('images')
//               .document(documnetID)
//               .setData({'urls': imageUrls}).then((_) {
//             SnackBar snackbar =
//                 SnackBar(content: Text('Uploaded Successfully'));
//             widget.globalKey.currentState.showSnackBar(snackbar);
//             setState(() {
//               images = [];
//               imageUrls = [];
//             });
//           });
//         }
//       }).catchError((err) {
//         print(err);
//       });
//     }
//   }

//   Future<void> loadAssets() async {
//     List<Asset> resultList = List<Asset>();
//     String error = 'No Error Dectected';
//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 10,
//         enableCamera: true,
//         selectedAssets: images,
//         cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
//         materialOptions: MaterialOptions(
//           actionBarColor: "#B5BFD0",
//           actionBarTitle: "Upload Image",
//           allViewTitle: "All Photos",
//           useDetailsView: false,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );
//       print(resultList.length);
//       print((await resultList[0].getThumbByteData(122, 100)));
//       print((await resultList[0].getByteData()));
//       print((await resultList[0].metadata));
//     } on Exception catch (e) {
//       error = e.toString();
//     }

//     if (!mounted) return;
//     setState(() {
//       images = resultList;
//       _error = error;
//     });
//   }

//   Future<dynamic> postImage(Asset imageFile) async {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
//     StorageUploadTask uploadTask =
//         reference.putData((await imageFile.getByteData()).buffer.asUint8List());
//     StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//     print(storageTaskSnapshot.ref.getDownloadURL());
//     return storageTaskSnapshot.ref.getDownloadURL();
//   }
// }

// class ViewImages extends StatelessWidget {
//   List<NetworkImage> _listOfImages = <NetworkImage>[];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         SizedBox(
//           height: 20,
//         ),
//         Flexible(
//             child: StreamBuilder<QuerySnapshot>(
//                 stream: Firestore.instance.collection('images').snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return ListView.builder(
//                         itemCount: snapshot.data.documents.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           _listOfImages = [];
//                           for (int i = 0;
//                               i <
//                                   snapshot.data.documents[index].data['urls']
//                                       .length;
//                               i++) {
//                             _listOfImages.add(NetworkImage(snapshot
//                                 .data.documents[index].data['urls'][i]));
//                           }
//                           return Column(
//                             children: <Widget>[
//                               Container(
//                                 margin: EdgeInsets.all(10.0),
//                                 height: 200,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                 ),
//                                 width: MediaQuery.of(context).size.width,
//                                 child: Carousel(
//                                     boxFit: BoxFit.cover,
//                                     images: _listOfImages,
//                                     autoplay: false,
//                                     indicatorBgPadding: 5.0,
//                                     dotPosition: DotPosition.bottomCenter,
//                                     animationCurve: Curves.fastOutSlowIn,
//                                     animationDuration:
//                                         Duration(milliseconds: 2000)),
//                               ),
//                               Container(
//                                 height: 1,
//                                 width: MediaQuery.of(context).size.width,
//                                 color: Colors.red,
//                               )
//                             ],
//                           );
//                         });
//                   } else {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 }))
//       ],
//     );
//   }
// }

// class MultiPickerApp {
//   static Color navigateButton = Color(0xff141516);
//   static Color pauseButton = Color(0xffF41F00);
//   static Color pauseButtonDarker = Color(0xff9B1400);
//   static Color background = Color(0xff1E2025);
//   static Color brighter = Color(0xff353235);
//   static Color darker = Colors.black;
// }

// // I  found this widget on Github
// class ThreeDContainer extends StatelessWidget {
//   final Widget child;
//   final double width;
//   final double height;
//   final Color backgroundColor;
//   final Color backgroundDarkerColor;
//   final Color borderColor;
//   final Color borderDarkerColor;
//   final double spreadRadius;
//   final double offset;
//   final double blurRadius;
//   const ThreeDContainer({
//     Key key,
//     @required this.child,
//     @required this.width,
//     @required this.height,
//     @required this.backgroundColor,
//     @required this.backgroundDarkerColor,
//     this.borderColor,
//     this.borderDarkerColor,
//     this.blurRadius = 15,
//     this.spreadRadius = 4,
//     this.offset = 4,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       padding: EdgeInsets.all(width / 30),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(15)),
//         boxShadow: [
//           BoxShadow(
//               color: MultiPickerApp.darker,
//               offset: Offset(offset, offset),
//               blurRadius: blurRadius,
//               spreadRadius: spreadRadius),
//           BoxShadow(
//               color: MultiPickerApp.brighter,
//               offset: Offset(-offset, -offset),
//               blurRadius: blurRadius,
//               spreadRadius: spreadRadius),
//         ],
//         gradient: LinearGradient(
//           // Where the linear gradient begins and ends
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             borderDarkerColor ?? MultiPickerApp.darker,
//             borderColor ?? MultiPickerApp.brighter,
//           ],
//         ),
//       ),
//       child: Container(
//         width: width,
//         height: height,
//         child: child,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(15)),
//             gradient: LinearGradient(
//               // Where the linear gradient begins and ends
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 backgroundDarkerColor,
//                 backgroundColor,
//               ],
//             )),
//       ),
//     );
//   }
// }
