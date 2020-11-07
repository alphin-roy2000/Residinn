import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ResidInn/modules/http.dart';

import 'package:ResidInn/pages/splash_screen.dart';
import 'package:ResidInn/pages/uploadspage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:line_icons/line_icons.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';

class EventGallery1 extends StatefulWidget {
  @override
  _EventGallery1State createState() => _EventGallery1State();
}

class ImageAlbum {
  String eventid;
  String albumname;
  String indexurl;
  String category;
  ImageAlbum(this.eventid, this.albumname, this.indexurl, this.category);
}

class _EventGallery1State extends State<EventGallery1> {
  void initState() {
    refreshUsers();
    print("dhgdhfd");
    super.initState();
  }

  List wholegallery = [];
  Future<void> refreshUsers() async {
    selectedCategory = 0;
    categoryalbumlist = [
      "All",
    ];

    var result = await http_get('gettest/$wholeresid');
    if (result.ok) {
      setState(() {
        meetforpage.clear();
        wholegallery = result.data['test'] as List<dynamic>;

        meetforpage = wholegallery;

        var temp = groupBy(result.data['test'], (obj) => obj['category']);
        categoryalbumlist = [
          "All",
        ];
        temp.forEach((key, value) {
          categoryalbumlist.add(key);
        });
        print(meetforpage);
      });
    }
  }

  deletefromfirebase(String imageid) {
    FirebaseStorage.instance.ref().child(imageid).delete();
  }

  Future<void> deletealbum(String id) async {
    print("delete");
    var result = await http_get('deletetest/$id');
    if (result.ok) {
      if (result.data['code'] == 200) {
        var deletealbumlist = result.data['urls'];
        deletealbumlist.forEach((each) {
          deletefromfirebase(each['imageid']);
        });
        await refreshUsers();
      }
    }
  }

  showDelete(BuildContext context, var album) {
    return AlertDialog(
      title: Text("Delete Album: ${album['albumname']}"),
      content: Text("Do you want to delete the album selected"),
      actions: <Widget>[
        FlatButton(
          child: Text("Delete"),
          onPressed: () async {
            deletealbum(album['eventid']);
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            //Put your code here which you want to execute on Cancel button click.
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  var cardAspectRatio = 12.0 / 16.0;
  List meetforpage = List();
  buildhorizontallistview() {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: meetforpage.length,
        itemBuilder: (BuildContext context, int i) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onLongPress: () {
              if (wholerole == "admin") {
                showDialog(
                    context: context,
                    builder: (_) {
                      return showDelete(context, meetforpage[i]);
                    });
              }
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CarouselDemo(
                      eventid: meetforpage[i]['eventid'],
                    );
                  },
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.network(meetforpage[i]['indexurl'],
                          fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text("${meetforpage[i]['albumname']}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19.0,
                                    // fontFamily: "SF-Pro-Text-Regular"
                                  )),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 12.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text("${meetforpage[i]['category']}",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController textEditingController = TextEditingController();

  header() {
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.5, 0.9],
                colors: [
                  Color(0xff67E0A3),
                  Color(0xff7CF0BD),
                  Color(0xffAFF9C9),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Text(
                "Gallery",
                style: TextStyle(
                    fontFamily: "Cor",
                    fontSize: 73,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0.5),
              ),
            ],
          ),
          // Positioned(
          //   bottom: -25,
          //   child: Container(
          //     width: 300,
          //     height: 50,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(25),
          //       border: Border.all(
          //         color: Color(0xFF3E4067),
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           offset: Offset(3, 3),
          //           blurRadius: 10,
          //           color: Colors.black.withOpacity(0.16),
          //           spreadRadius: -2,
          //         )
          //       ],
          //     ),
          //     // padding: const EdgeInsets.all(4),
          //     child: TextField(
          //         controller: textEditingController,
          //         decoration: InputDecoration(hintText: 'Search...'),
          //         onChanged: (query) {
          //           setState(() {
          //             print(query);
          //             // mainquery = query.length;
          //             // if (selectedCategory == 0) {
          //             //   mainalbumlist = album
          //             //       .where((p) => p.albumname
          //             //           .toLowerCase()
          //             //           .contains(query.toLowerCase()))
          //             //       .toList();
          //             // } else {
          //             //   mainalbumlist = mainalbumlist
          //             //       .where((p) => p.albumname
          //             //           .toLowerCase()
          //             //           .contains(query.toLowerCase()))
          //             //       .toList();
          //             // }
          //           });
          //           //   text = text.toLowerCase();
          //           //   setState(() {
          //           //     _notesForDisplay = _notes.where((note) {
          //           //       var noteTitle = note.title.toLowerCase();
          //           //       return noteTitle.contains(text);
          //           //     }).toList();
          //           //   });
          //           // },
          //         }),
          //   ),
          // )
        ],
      ),
    );
  }

  List categoryalbumlist = [];
  int selectedCategory = 0;
  categoryselect() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryalbumlist.length,
          itemBuilder: (context, index) => buildCategory(index, context),
        ));
  }

  Padding buildCategory(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          var query = categoryalbumlist[index];

          setState(() {
            textEditingController.clear();
            selectedCategory = index;
            if (selectedCategory == 0) {
              meetforpage = wholegallery;
            } else {
              meetforpage = wholegallery
                  .where((p) => p['category'].contains(query))
                  .toList();
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: index == selectedCategory
                ? Color(0xFFff6e6e)
                : Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
              child: Text(categoryalbumlist[index],
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  refreshUsers();
                })
          ],
        ),
        body: SingleChildScrollView(
            // onRefresh: refreshUsers,
            child: Column(
          children: <Widget>[
            // _searchBar(),
            header(),

            Container(
              height: 50,
              child: categoryselect(),
            ),
            Text("${meetforpage.length} Albums",
                style: TextStyle(color: Colors.blueAccent)),
            Container(
              height: 300,
              child: buildhorizontallistview(),
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
        floatingActionButton: (wholerole == "admin")
            ? FloatingActionButton(
                child: Icon(Icons.file_upload),
                onPressed: () async {
                  // loadAssets();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return GalleryUpload();
                      },
                    ),
                  );
                  refreshUsers();
                },
              )
            : SizedBox(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}

class CarouselDemo extends StatefulWidget {
  final String eventid;

  CarouselDemo({this.eventid});

  final String title = "Event gallery";

  @override
  CarouselDemoState createState() => CarouselDemoState();
}

class CarouselDemoState extends State<CarouselDemo> {
  @override
  void initState() {
    super.initState();
    getimage();
    // print(imgList);
  }

  List imgList1;
  bool loading = true;

  getimage() async {
    var results =
        await http_post("getalbum", {"eventgalleryid": widget.eventid});
    setState(() {
      imgList1 = results.data;
      loading = false;
    });

    print(imgList1[0]['imgurl']);
  }

  //
  CarouselSlider carouselSlider;
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  bool showBottomMenu = false;

  bool gridon = true;
  int photocount = 2;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            // if (wholerole == "admin")
            //   IconButton(
            //       icon: Icon(Icons.add_a_photo),
            //       onPressed: () {
            //         setState(() {});
            //       }),
            IconButton(
                icon: Icon(Icons.grid_on,
                    color: gridon == false ? Colors.redAccent : Colors.green),
                onPressed: () {}),
          ],
        ),
        body: loading == false
            ? gridon == false
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        carouselSlider = CarouselSlider(
                          height: MediaQuery.of(context).size.height * 0.5,
                          initialPage: 0,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          reverse: false,
                          enableInfiniteScroll: true,
                          autoPlayInterval: Duration(seconds: 2),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 2000),
                          pauseAutoPlayOnTouch: Duration(seconds: 10),
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index) {
                            setState(() {
                              _current = index;
                            });
                          },
                          items: imgList1.map((imgUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return PostView(imgUrl['imgurl']);
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent),
                                    child: Image.network(
                                      imgUrl['imgurl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: map<Widget>(imgList1, (index, url) {
                            return Container(
                              width: (MediaQuery.of(context).size.width - 20) *
                                  ((1 / imgList1.length)),
                              height: MediaQuery.of(context).size.height * 0.01,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 2 * ((1 / imgList1.length))),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Colors.redAccent
                                    : Colors.green,
                              ),
                            );
                          }),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlineButton(
                              onPressed: goToPrevious,
                              child: Icon(Icons.chevron_left),
                            ),
                            OutlineButton(
                              onPressed: goToNext,
                              child: Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : gridshow()
            : Center(
                child: SpinKitWave(
                    size: 24, color: Colors.green, type: SpinKitWaveType.start),
              ));
  }

  gridshow() {
    print(imgList1);
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      itemCount: imgList1.length,
      itemBuilder: (context, i) {
        String imgPath = imgList1[i]['imgurl'];
        return new Material(
          elevation: 8.0,
          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new PostView(imgPath)));
            },
            child: new Hero(
              tag: imgPath,
              child: new Container(
                child: new Image.network(
                  imgPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
      staggeredTileBuilder: (i) => new StaggeredTile.count(2, i.isEven ? 2 : 3),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }

  postTile(var url) {
    return GestureDetector(
      onLongPress: () {
        showAlert(context, url['imgurl']);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PostView(url['imgurl']);
            },
          ),
        );
      },
      child: Image.network(
        url['imgurl'],
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      ),
    );
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }
}

showAlert(BuildContext context, String imgUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          child: Image.network(
            imgUrl,
            fit: BoxFit.cover,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Continue"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class PostView extends StatefulWidget {
  final String imgUrl;
  PostView(this.imgUrl);
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  Color backGroundcolor = Colors.black54;
  PhotoViewScaleStateController scaleStateController;
  @override
  void initState() {
    super.initState();
    useWhiteTextColor(widget.imgUrl);

    callforinit();
  }

  callforinit() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterDownloader.initialize(
          debug: true // optional: set false to disable printing logs to console
          );
      print("settingup");
    } catch (err) {
      print("not be called");
    }
  }

  useWhiteTextColor(String imageUrl) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),

      size: Size(300, 300),

      // I want the dominant color of the top left section of the image
      region: Offset.zero & Size(40, 40),
    );
    setState(() {
      backGroundcolor = paletteGenerator.dominantColor?.color;
    });
    print(backGroundcolor);
  }

  String imageData;
  bool dataLoaded = false;
  var progressString = "";
  bool downloading = false;
  bool shareloading = false;
  Future<void> _shareImageFromUrl(String url) async {
    setState(() {
      shareloading = true;
    });
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('Residinn', 'amlog.jpg', bytes, 'image/jpg');
    } catch (e) {
      print('error: $e');
    }
    setState(() {
      shareloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("View"),
          actions: <Widget>[
            IconButton(
                icon: Icon(LineIcons.share),
                onPressed: () {
                  _shareImageFromUrl(widget.imgUrl);
                })
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            child: Icon(Icons.file_download),
            onPressed: () async {
              final externaldir = await getExternalStorageDirectory();
              final assetsDir = externaldir.path + '/images';
              var firstPath = externaldir.path; //%%%

              //You'll have to manually create subdirectories
              await Directory(firstPath).create(recursive: true);
              print(firstPath);
              final taskId = await FlutterDownloader.enqueue(
                url: widget.imgUrl,
                savedDir: firstPath,
                fileName: "IMG${Random().nextInt(100000)}.jpg",
                // headers: requestHeaders,
                showNotification:
                    true, // show download progress in status bar (for Android)
                openFileFromNotification:
                    true, // click on notification to open downloaded file (for Android)
              );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        // bottomNavigationBar: BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   child: new Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: <Widget>[
        //       IconButton(
        //         onPressed: () {},
        //         icon: Icon(Icons.menu),
        //       ),
        //     ],
        //   ),
        // ),
        body: Stack(
          children: <Widget>[
            Container(
                child: PhotoView(
              backgroundDecoration: BoxDecoration(color: backGroundcolor),
              imageProvider: NetworkImage(widget.imgUrl),
            )),
            if (shareloading == true)
              Container(
                  color: Colors.white54,
                  child: SpinKitWave(
                      size: 24,
                      color: Colors.green,
                      type: SpinKitWaveType.start))
          ],
        ));
  }
}
