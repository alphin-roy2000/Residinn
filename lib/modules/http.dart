import 'dart:convert';

import "package:http/http.dart" as http;

class RequestResult {
  bool ok;
  dynamic data;
  RequestResult(this.ok, this.data);
}

const PROTOCOL = "http";
var DOMAIN = "residinn20.herokuapp.com";
// var DOMAIN = "192.168.1.3:4000";

Future<RequestResult> http_get(String route, [dynamic data]) async {
  var dataStr = jsonEncode(data);
  var url = "$PROTOCOL://$DOMAIN/$route?data=$dataStr";
  print(url);
  var result = await http.get(
    url,
  );
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> http_post(String route, [dynamic data]) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  print("$url");

  var dataStr = jsonEncode(data);
  print(dataStr);
  var result = await http
      .post(url, body: dataStr, headers: {"Content-Type": "application/json"});
  return RequestResult(true, jsonDecode(result.body));
}
