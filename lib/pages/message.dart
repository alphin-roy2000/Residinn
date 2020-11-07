import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class MyHomePage1 extends StatefulWidget {
  MyHomePage1({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePage1State createState() => _MyHomePage1State();
}

class _MyHomePage1State extends State<MyHomePage1> {
  TwilioFlutter twilioFlutter;

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC1709ee56f908a15d2921d6c4cf3b9785',
        authToken: '54696f9427d82e82012bc0b7136f4b8e',
        twilioNumber: '+91 9946839005');

    super.initState();
  }

  void sendSms() async {
    twilioFlutter.sendSMS(
        toNumber: '+91-9946839005', messageBody: 'hello world');
  }

  void getSms() async {
    var data = await twilioFlutter.getSmsList();
    print(data);

    await twilioFlutter.getSMS('***************************');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          'Click the button to send SMS.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendSms,
        tooltip: 'Send Sms',
        child: Icon(Icons.send),
      ),
    );
  }
}
