import 'package:flutter/material.dart';
import 'package:perpus_flutter/screens/homepage.dart';
import 'package:perpus_flutter/screens/login.dart';
import 'package:perpus_flutter/screens/perpuspage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => Homepage(),
        '/perpus': (context) => PerpusPage(),
      },
    );
  }
}
