import 'package:ResidInn/pages/sign_up_screen.dart';
import 'package:ResidInn/pages/sign_up_user.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Do you want to be an ",
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpAdminScreen();
                  },
                ),
              ),
              child: Text(
                "Admin?",
                style: TextStyle(fontSize: 16, color: kPrimaryColor),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Do you want to be a  ",
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpUserScreen();
                  },
                ),
              ),
              child: Text(
                "Resident?",
                style: TextStyle(fontSize: 16, color: kPrimaryColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
