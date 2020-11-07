import 'dart:async';
import 'dart:convert';

import 'package:ResidInn/modules/http.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:http/http.dart' as http;

class ImageServices {
  static var dataStr = jsonEncode({"resid": wholeresid});
  static String _url = "http://$DOMAIN/getimages";

  static Future browse() async {
    var dataStr = jsonEncode({"resid": wholeresid});
    http.Response response = await http.post(_url,
        body: dataStr, headers: {"Content-Type": "application/json"});
    String content = response.body;

    List collection = json.decode(content);

    print("$dataStr adssdgsdgsdg");
    List<ListAlbum> albumlist =
        collection.map((json) => ListAlbum.fromJson(json)).toList();
    print("\n\n\nalbumlist");
    // print(albumlist[0]);
    return albumlist;
  }
}

void main() async {
  List result = await ImageServices.browse();
  print(result);
}

class ListAlbum {
  final String albumname;
  final String eventid;
  final String residid;
  final String indexurl;

  ListAlbum.fromJson(Map<String, dynamic> json)
      : albumname = json['albumname'],
        eventid = json['eventid'],
        residid = json['resid'],
        indexurl = json['indexurl'];
}

class ImageManager {
  final StreamController<int> _listcount = StreamController<int>();
  Stream<int> get listCount => _listcount.stream;

  Stream<List<ListAlbum>> get contactListView async* {
    yield await ImageServices.browse();
  }

  ImageManager() {
    contactListView.listen((list) => _listcount.add(list.length));
  }
}

// class DirectoryServices {
//   static var dataStr = jsonEncode({"resid": wholeresid});
//   static String _url = "http://192.168.1.2:4000/getdirectory";

//   static Future browse() async {
//     var dataStr = jsonEncode({"resid": wholeresid});
//     http.Response response = await http.post(_url,
//         body: dataStr, headers: {"Content-Type": "application/json"});
//     String content = response.body;

//     List collection = json.decode(content);

//     print("$dataStr adssdgsdgsdg");
//     List<ListDirectory> albumlist =
//         collection.map((json) => ListDirectory.fromJson(json)).toList();
//     print("\n\n\nalbumlist");
//     // print(albumlist[0]);
//     return albumlist;
//   }
// }

// void main1() async {
//   List result = await DirectoryServices.browse();
//   print(result);
// }

// class ListDirectory {
//   final String housename;
//   final String residenceid;
//   final String id;
//   final String phonenumber;

//   ListDirectory.fromJson(Map<String, dynamic> json)
//       : housename = json['housename'],
//         id = json['id'],
//         residenceid = json['residenceid'],
//         phonenumber = json['phonenumber'];
// }

// class DirectoryManager {
//   final StreamController<int> _listcount = StreamController<int>();
//   Stream<int> get listCount => _listcount.stream;

//   Stream<List<ListDirectory>> get contactListView async* {
//     yield await DirectoryServices.browse();
//   }

//   DirectoryManager() {
//     contactListView.listen((list) => _listcount.add(list.length));
//   }
// }
