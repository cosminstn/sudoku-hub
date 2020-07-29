import 'package:flutter/material.dart';
import 'package:sudoku_plus/pages/splashscreen_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Hub',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xffffa500),
          accentColor: Color(0xffffa500),
          backgroundColor: Colors.black),
      home: SplashScreenPage(),
    );
  }
}
