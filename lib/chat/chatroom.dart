import 'package:ResidInn/chat/chat.dart';
import 'package:ResidInn/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ResidInn/modules/http.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List chatRooms = [];

  Widget chatRoomsList() {
    return ListView.builder(
        itemCount: chatRooms.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ChatRoomsTile(
            userName: chatRooms[index]['housename'],
            chatRoomId: chatRooms[index]['roomid'],
          );
        });
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    var results = await http_get("getroomadmin/$wholeresid");
    if (results.data['code'] == 200)
      setState(() {
        chatRooms = results.data['results'];
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Chats"),
        actions: [],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                      admin: true,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
