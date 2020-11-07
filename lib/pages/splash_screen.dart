import 'package:ResidInn/components/default_button.dart';
import 'package:ResidInn/pages/home-screen.dart';
import 'package:ResidInn/pages/sign_in_screen.dart';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

String wholerole;
String wholeuseremail;
String wholeid;
String wholeresid;
int notcounter = 0;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loading = false;

  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {"text": "Welcome to ResidInn", "image": "assets/images/r1.png"},
    {"text": "Connect the community", "image": "assets/images/r4.png"},
  ];

  String value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      wholeuseremail = preferences.getString("email");
      wholerole = preferences.getString("role");
      wholeid = preferences.getString("id");
      wholeresid = preferences.getString("resid");
    });
    print(wholeresid);

    return preferences.getString("email");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Spacer(),
            RichText(
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "Resid",
                    style: TextStyle(
                        fontFamily: "Lond",
                        color: ksecondaryColor1,
                        fontSize: 36),
                  ),
                  TextSpan(
                    text: "Inn",
                    style: TextStyle(
                        fontFamily: "Lond", color: kPrimaryColor, fontSize: 36),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              height: 300,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    loading == false
                        ? DefaultButton(
                            text: "Continue",
                            press: () async {
                              setState(() {
                                loading = true;
                              });

                              if (true) {
                                value = await getPref();
                                print("$value");
                                if (value == null) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new SignInScreen()),
                                      (Route<dynamic> route) => false);
                                } else {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new HomeScreen()),
                                      (Route<dynamic> route) => false);
                                }
                              } else {}
                              setState(() {
                                loading = false;
                              });
                            },
                          )
                        : SpinKitWave(
                            size: 24,
                            color: Colors.green,
                            type: SpinKitWaveType.start),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
        Image.asset(
          image,
          height: 210,
        ),
      ],
    );
  }
}
