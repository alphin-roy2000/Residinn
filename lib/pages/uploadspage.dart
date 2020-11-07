import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';

class GalleryUpload extends StatefulWidget {
  @override
  _GalleryUploadState createState() => _GalleryUploadState();
}

class _GalleryUploadState extends State<GalleryUpload> {
  final _globalKey = GlobalKey<ScaffoldState>();
  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  String _error = 'No Error Dectected';
  String title;

  final _formKey = GlobalKey<FormState>();
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        print(asset.getByteData(quality: 100));
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 30,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#B5BFD0",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Future<dynamic> postImage(Asset imageFile, String filename) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  void uploadImages() {
    var uuid = Uuid().v4();
    print(uuid);
    List<List> settotalimage = List();

    for (var imageFile in images) {
      var imageuuid = Uuid().v4();
      postImage(imageFile, imageuuid).then((downloadUrl) {
        var setlist = [imageuuid, uuid, downloadUrl.toString()];
        print(setlist);
        settotalimage.add(setlist);
        print(settotalimage);
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          updatesql(uuid, settotalimage);
          // String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
          // Firestore.instance
          //     .collection('images')
          //     .document(documnetID)
          //     .setData({'urls': imageUrls}).then((_) {
          // SnackBar snackbar = SnackBar(content: Text('Uploaded Successfully'));
          // _globalKey.currentState.showSnackBar(snackbar);

          // setState(() {
          //   images = [];
          //   imageUrls = [];
          // });
          // Navigator.of(context).pop();
          // // });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  String category = "Other";
  updatesql(var uuid, var urltotal) async {
    print("InstantUrl");
    var result;
    try {
      result = await http_post("uploadimage", {
        "eventgalleryid": uuid,
        "emailid": wholeid,
        "albumname": title,
        "imgurlslist": urltotal,
        "category": category
      });
      print("step1");
      print(result.data['code']);
    } catch (err) {
      print(err);
    } finally {
      if (result.data['code'] == 200) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Upload"),
        actions: <Widget>[
          FlatButton.icon(
            label: Text("Upload"),
            icon: Icon(Icons.file_upload),
            onPressed: () {
              if (images.isNotEmpty && title.isNotEmpty) {
                uploadImages();
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () {
          loadAssets();
        },
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // isUploading == true
            //     ? Text(
            //         "Uploading",
            //         style: TextStyle(color: Colors.redAccent),
            //       )
            //     : SizedBox(),
            Padding(
              padding: EdgeInsets.only(
                top: 12.0,
              ),
            ),
            ListTile(
              title: Container(
                width: 250.0,
                child: new TextFormField(
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      labelText: "Title",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        //fillColor: Colors.green
                      )),
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: ShapeDecoration(
                  color: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: category,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
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
                      child: Text(value),
                    );
                  }).toList(),
                ))),
            Expanded(
              child: buildGridView(),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
