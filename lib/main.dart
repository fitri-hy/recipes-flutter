import 'package:flutter/material.dart';
import 'pages/Landing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resep Masakan',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LandingPage(),
    );
  }
}
