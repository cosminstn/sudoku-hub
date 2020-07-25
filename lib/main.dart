import 'package:flutter/material.dart';
import 'package:sudoku_plus/pages/splashscreen_page.dart';

import 'pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenPage(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sudoku Plus',
//       theme: ThemeData(
//         primarySwatch: Colors.cyan,
//       ),
//       home: GameMenu(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   HomePage() : super();

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Sudoku Plus"),
//         ),
//         body: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               RaisedButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => GameMenu()));
//                 },
//                 child: Text("New Game"),
//               )
//             ],
//           ),
//         ));
//   }
// }
