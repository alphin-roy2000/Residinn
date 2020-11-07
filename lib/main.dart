import 'package:ResidInn/pages/splash_screen.dart';
import 'package:ResidInn/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResidInn',
      theme: theme(),
      home: SplashScreen(),
    );
  }
}
