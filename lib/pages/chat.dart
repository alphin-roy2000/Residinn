// import 'dart:convert';

// import 'package:ResidInn/pages/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_socket_io/flutter_socket_io.dart';
// import 'package:flutter_socket_io/socket_io_manager.dart';
// import 'package:scoped_model/scoped_model.dart';

// class ChatModel extends Model {
//   List<Message> messages = List<Message>();
//   SocketIO socketIO;

//   void init() {
//     socketIO = SocketIOManager().createSocketIO('http://192.168.1.4:4010', '/',
//         query: 'chatID=$wholeid');
//     socketIO.init();

//     socketIO.subscribe('receive_message', (jsonData) {
//       Map<String, dynamic> data = json.decode(jsonData);
//       messages.add(Message(
//           data['content'], data['senderChatID'], data['receiverChatID']));
//       notifyListeners();
//     });

//     socketIO.connect();
//   }

//   void sendMessage(String text, String receiverChatID) {
//     messages.add(Message(text, wholeid, receiverChatID));
//     socketIO.sendMessage(
//       'send_message',
//       json.encode({
//         'receiverChatID': receiverChatID,
//         'senderChatID': wholeid,
//         'content': text,
//       }),
//     );
//     notifyListeners();
//   }

//   List<Message> getMessagesForChatID(String chatID) {
//     return messages
//         .where((msg) => msg.senderID == chatID || msg.receiverID == chatID)
//         .toList();
//   }
// }

// class Message {
//   final String text;
//   final String senderID;
//   final String receiverID;

//   Message(this.text, this.senderID, this.receiverID);
// }

// class User {
//   String name;
//   String chatID;

//   User(this.name, this.chatID);
// }

// class ChatPage extends StatefulWidget {
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController textEditingController = TextEditingController();

//   Widget buildSingleMessage(Message message) {
//     return Container(
//       alignment: message.senderID == "asasgsagsag"
//           ? Alignment.centerLeft
//           : Alignment.centerRight,
//       padding: EdgeInsets.all(10.0),
//       margin: EdgeInsets.all(10.0),
//       child: Text(message.text),
//     );
//   }

//   Widget buildChatList() {
//     return ScopedModelDescendant<ChatModel>(
//       builder: (context, child, model) {
//         List<Message> messages = model.getMessagesForChatID("asasgsagsag");

//         return Container(
//           height: MediaQuery.of(context).size.height * 0.75,
//           child: ListView.builder(
//             itemCount: messages.length,
//             itemBuilder: (BuildContext context, int index) {
//               return buildSingleMessage(messages[index]);
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget buildChatArea() {
//     return ScopedModelDescendant<ChatModel>(
//       builder: (context, child, model) {
//         return Container(
//           child: Row(
//             children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 child: TextField(
//                   controller: textEditingController,
//                 ),
//               ),
//               SizedBox(width: 10.0),
//               FloatingActionButton(
//                 onPressed: () {
//                   model.sendMessage(textEditingController.text, "asasgsagsag");
//                   textEditingController.text = '';
//                 },
//                 elevation: 0,
//                 child: Icon(Icons.send),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("asasgsagsag"),
//       ),
//       body: ListView(
//         children: <Widget>[
//           // buildChatList(),
//           buildChatArea(),
//         ],
//       ),
//     );
//   }
// }
