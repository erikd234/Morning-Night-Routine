import 'package:flutter/material.dart';
import 'nightView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NightPage(),
    );
  }
}
